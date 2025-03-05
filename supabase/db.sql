DROP SCHEMA IF EXISTS sugar CASCADE;

DROP POLICY IF EXISTS "Users can view their own data" ON auth.users;
CREATE POLICY "Users can view their own data" on auth.users
FOR SELECT
USING ( auth.uid() = auth.users.id );

CREATE SCHEMA sugar;
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Unschedule existing job if it exists
SELECT cron.unschedule('daily_reset_check');

-- Schedule new job to handle both reset and daily budget calculation
SELECT cron.schedule('daily_reset_check', '0 0 * * *', $$
    SELECT sugar.check_reset_day();
    SELECT sugar.check_remaining_daily_budget();
$$);

SET timezone = 'Asia/Manila';

-- Create Functions
CREATE OR REPLACE FUNCTION sugar.generate_unique_code()
RETURNS TRIGGER AS $$
BEGIN
  -- Generate a random 6-character alphanumeric code
  NEW.unique_code := substring(md5(random()::text) from 1 for 6);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.set_monthly_budget_balance()
RETURNS TRIGGER AS $$
BEGIN
  -- Generate a random 6-character alphanumeric code
  NEW.balance := NEW.budget;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Types
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_type') THEN 
    CREATE TYPE sugar.user_type AS ENUM ('DADDY', 'BABY', 'NONE'); 
  END IF; 
END $$;

-- Create Types
DO $$ 
BEGIN 
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'expense_type') THEN 
    CREATE TYPE sugar.expense_type AS ENUM ('SNACKS', 'COFFEE', 'ICE_CREAM', 'MEAL', 'GROCERY', 'RAMEN'); 
  END IF; 
END $$;


-- Create Tables
CREATE TABLE IF NOT EXISTS sugar.user_data (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL UNIQUE PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    partner_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    user_type sugar.user_type NOT NULL DEFAULT 'NONE',
    unique_code VARCHAR(255),
    fcm_token TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sugar.monthly_budget (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL UNIQUE PRIMARY KEY REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    partner_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    budget NUMERIC(10,2) NOT NULL DEFAULT 10000.00,
    balance NUMERIC(10,2),
    reset_day INTEGER CHECK (reset_day BETWEEN 1 AND 31),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sugar.account (
    id UUID NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    account_name TEXT NOT NULL DEFAULT 'sweet funds',
    balance  NUMERIC(10,2) NOT NULL DEFAULT 0,
    color TEXT NOT NULL DEFAULT '0xff000000',
    account_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sugar.account_balance_history (
    id UUID NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL UNIQUE REFERENCES sugar.account(id) ON DELETE CASCADE,
    balance NUMERIC(10,2) NOT NULL,
    recorded_at DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS sugar.expense(
    id UUID NOT NULL PRIMARY KEY  UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    expense_type sugar.expense_type NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
alter table sugar.expense replica identity full;

CREATE TABLE IF NOT EXISTS sugar.personal_budget (
    id UUID NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    budget NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    balance NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    daily_budget NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES sugar.monthly_budget(user_id)
);

-- Create Triggers
CREATE OR REPLACE FUNCTION sugar.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.set_account_index()
RETURNS TRIGGER AS $$
DECLARE
    last_index INT;
BEGIN
    -- Find the last account_index for the user
    SELECT COALESCE(MAX(account_index), -1) + 1 INTO last_index
    FROM sugar.account
    WHERE user_id = NEW.user_id;

    -- Set the account_index for the new account
    NEW.account_index := last_index;

    RETURN NEW; -- Return the modified new row
END;

CREATE OR REPLACE FUNCTION sugar.decrement_account_index()
RETURNS TRIGGER AS $$
BEGIN
    -- Decrement index of all accounts that have a higher index than the deleted account
    UPDATE sugar.account
    SET account_index = GREATEST(account_index - 1, 0)  -- Ensure index does not go below 0
    WHERE user_id = OLD.user_id AND account_index > OLD.account_index;

    RETURN OLD;  -- Return OLD to indicate the row that was deleted
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sugar.update_budget_balance()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the user_id in the expense matches either the user_id or partner_id in the monthly_budget table
    UPDATE sugar.monthly_budget
    SET balance = balance - NEW.amount, -- Deduct the expense amount from the balance
        updated_at = NOW() -- Update the updated_at timestamp
    WHERE (user_id = NEW.user_id OR partner_id = NEW.user_id);
    
    RETURN NEW; -- Return the new record for insertion
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.update_budget_balance_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the user_id in the expense matches either the user_id or partner_id in the monthly_budget table
    UPDATE sugar.monthly_budget
    SET balance = balance + OLD.amount, -- Readd the expense amount from the balance
        updated_at = NOW() -- Update the updated_at timestamp
    WHERE (user_id = OLD.user_id OR partner_id = OLD.user_id);
    
    RETURN OLD; -- Return the new record for insertion
END;
$$ LANGUAGE plpgsql;

DO $$ 
DECLARE
    rec RECORD;
    schema_name CONSTANT TEXT := 'sugar';
BEGIN
    FOR rec IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = schema_name
    LOOP
        EXECUTE format(
            'CREATE TRIGGER update_updated_at_%I 
            BEFORE UPDATE ON %I.%I 
            FOR EACH ROW 
            EXECUTE FUNCTION sugar.update_updated_at_column();',
            rec.tablename, schema_name, rec.tablename
        );
    END LOOP;
END $$;

CREATE OR REPLACE FUNCTION sugar.update_account_balance_history()
RETURNS TRIGGER AS $$
BEGIN
    -- If it's an insert (account creation), add a new entry with a balance of 0
    IF TG_OP = 'INSERT' THEN
        INSERT INTO sugar.account_balance_history (account_id, balance, recorded_at)
        VALUES (NEW.id, 0, CURRENT_DATE);

    -- If it's an update, update the balance in account_balance_history
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO sugar.account_balance_history (account_id, balance, recorded_at)
        VALUES (NEW.id, NEW.balance, CURRENT_DATE)
        ON CONFLICT (account_id) 
        DO UPDATE SET balance = EXCLUDED.balance, recorded_at = CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER set_unique_code
BEFORE INSERT ON sugar.user_data
FOR EACH ROW
EXECUTE FUNCTION sugar.generate_unique_code();

CREATE TRIGGER set_balance
BEFORE INSERT ON sugar.monthly_budget
FOR EACH ROW
EXECUTE FUNCTION sugar.set_monthly_budget_balance();

CREATE TRIGGER update_budget_balance_trigger
AFTER INSERT ON sugar.expense
FOR EACH ROW
EXECUTE FUNCTION sugar.update_budget_balance();

CREATE TRIGGER update_budget_balance_trigger_delete
BEFORE DELETE ON sugar.expense
FOR EACH ROW
EXECUTE FUNCTION sugar.update_budget_balance_delete();

CREATE TRIGGER before_insert_account
BEFORE INSERT ON sugar.account
FOR EACH ROW
EXECUTE FUNCTION sugar.set_account_index();

CREATE TRIGGER after_delete_account
AFTER DELETE ON sugar.account
FOR EACH ROW
EXECUTE FUNCTION sugar.decrement_account_index();


CREATE TRIGGER account_balance_history_trigger
AFTER INSERT OR UPDATE ON sugar.account
FOR EACH ROW
EXECUTE FUNCTION sugar.update_account_balance_history();


CREATE OR REPLACE FUNCTION update_account_balance_history()
RETURNS TRIGGER AS $$
BEGIN
    -- If it's an insert (account creation), add a new entry with a balance of 0
    IF TG_OP = 'INSERT' THEN
        INSERT INTO sugar.account_balance_history (account_id, balance, recorded_at)
        VALUES (NEW.id, 0, CURRENT_DATE);

    -- If it's an update, update the balance in account_balance_history
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO sugar.account_balance_history (account_id, balance, recorded_at)
        VALUES (NEW.id, NEW.balance, CURRENT_DATE)
        ON CONFLICT (account_id) 
        DO UPDATE SET balance = EXCLUDED.balance, recorded_at = CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Create callable functions through rpc

CREATE OR REPLACE FUNCTION sugar.check_reset_day() 
RETURNS VOID AS $$
DECLARE
    rec sugar.monthly_budget%ROWTYPE;
    days_in_month INTEGER;
    days_until_next_reset INTEGER;
BEGIN
    -- Loop through all monthly budgets
    FOR rec IN SELECT * FROM sugar.monthly_budget LOOP
        IF EXTRACT(DAY FROM CURRENT_DATE) = rec.reset_day THEN
            -- Calculate days until next reset
            days_in_month := EXTRACT(DAYS FROM DATE_TRUNC('MONTH', CURRENT_DATE + INTERVAL '1 MONTH') - DATE_TRUNC('MONTH', CURRENT_DATE));
            
            IF rec.reset_day > EXTRACT(DAY FROM CURRENT_DATE) THEN
                days_until_next_reset := rec.reset_day - EXTRACT(DAY FROM CURRENT_DATE);
            ELSE
                days_until_next_reset := (days_in_month - EXTRACT(DAY FROM CURRENT_DATE) + rec.reset_day)::INTEGER;
            END IF;

            -- Update the monthly budget balance
            UPDATE sugar.monthly_budget
            SET balance = rec.budget, updated_at = NOW()
            WHERE sugar.monthly_budget.id = rec.id;

            -- Update the personal budget balance and initialize daily budget
            UPDATE sugar.personal_budget
            SET 
                balance = budget,
                daily_budget = ROUND((budget / days_until_next_reset)::NUMERIC, 2),
                updated_at = NOW()
            WHERE user_id = rec.user_id;

            -- Log the updates
            RAISE NOTICE 'Updated monthly budget: id=%, user_id=%, budget=%, balance=% at %',
                rec.id, rec.user_id, rec.budget, rec.budget, NOW();
            RAISE NOTICE 'Updated personal budgets for user_id=% with initial daily budget for % days at %',
                rec.user_id, days_until_next_reset, NOW();
        ELSE
            -- Log skipped rows
            RAISE NOTICE 'Skipped row: id=%, user_id=%, reset_day=% (Today: %)',
                rec.id, rec.user_id, rec.reset_day, EXTRACT(DAY FROM CURRENT_DATE);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.add_partner(_unique_code VARCHAR(255), _user_id UUID)
RETURNS UUID AS $$
DECLARE
    partner_user_id UUID;
    partner_user_type sugar.user_type;
BEGIN
    -- Check if the partner exists and get their info
    SELECT user_id, user_type INTO partner_user_id, partner_user_type
    FROM sugar.user_data
    WHERE unique_code = _unique_code;

    -- Raise exception if partner not found
    IF partner_user_id IS NULL THEN
        RAISE EXCEPTION 'Partner does not exist in user_data';
    END IF;

    -- Update partner relationship and roles
    IF partner_user_type = 'DADDY' THEN
        -- Set current user as BABY
        UPDATE sugar.user_data
        SET partner_id = partner_user_id, user_type = 'BABY'
        WHERE user_id = _user_id;

        -- Set partner's partner_id to current user
        UPDATE sugar.user_data
        SET partner_id = _user_id
        WHERE user_id = partner_user_id;
    ELSE
        -- Set current user as DADDY
        UPDATE sugar.user_data
        SET partner_id = partner_user_id, user_type = 'DADDY'
        WHERE user_id = _user_id;

        -- Set partner's partner_id to current user
        UPDATE sugar.user_data
        SET partner_id = _user_id
        WHERE user_id = partner_user_id;
    END IF;

    UPDATE sugar.monthly_budget
    SET partner_id = _user_id
    WHERE user_id = partner_user_id;

    -- Return the partner's user_id
    RETURN partner_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.get_expenses(_user_id UUID)
RETURNS TABLE (
    id UUID,
    user_id UUID,
    expense_type sugar.expense_type,
    amount NUMERIC,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT * 
    FROM sugar.expense e
    WHERE e.user_id = _user_id
    OR e.user_id = (SELECT ud.partner_id FROM sugar.user_data ud WHERE ud.user_id = _user_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.check_remaining_daily_budget()
RETURNS VOID AS $$
DECLARE
    pb_rec RECORD;
    days_until_reset INTEGER;
    current_day INTEGER;
    reset_day INTEGER;
BEGIN
    -- Only run at midnight (00:00)
    IF EXTRACT(HOUR FROM CURRENT_TIMESTAMP) = 0 AND EXTRACT(MINUTE FROM CURRENT_TIMESTAMP) = 0 THEN
        -- Loop through all personal budgets
        FOR pb_rec IN 
            SELECT pb.*, mb.reset_day 
            FROM sugar.personal_budget pb
            JOIN sugar.monthly_budget mb ON pb.user_id = mb.user_id
        LOOP
            -- Get current day of month
            current_day := EXTRACT(DAY FROM CURRENT_DATE);
            reset_day := pb_rec.reset_day;
            
            -- Calculate days until reset
            IF current_day < reset_day THEN
                days_until_reset := reset_day - current_day;
            ELSE
                -- If we're past reset day, calculate days until next month's reset
                days_until_reset := (reset_day + EXTRACT(DAYS FROM 
                    (DATE_TRUNC('MONTH', CURRENT_DATE + INTERVAL '1 MONTH') - CURRENT_DATE)
                ))::INTEGER;
            END IF;

            -- Update daily budget
            IF days_until_reset > 0 THEN
                UPDATE sugar.personal_budget
                SET daily_budget = ROUND((balance / days_until_reset)::NUMERIC, 2)
                WHERE id = pb_rec.id;

                RAISE NOTICE 'Updated daily budget for budget "%(%)" to % (% days until reset)',
                    pb_rec.name, pb_rec.id, ROUND((pb_rec.balance / days_until_reset)::NUMERIC, 2), days_until_reset;
            END IF;
        END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_user_account_index' 
        AND table_name = 'account'
    ) THEN
        ALTER TABLE sugar.account
        ADD CONSTRAINT unique_user_account_index UNIQUE (user_id, account_index);
    END IF;
END $$;




GRANT SELECT ON auth.users TO authenticated;
GRANT USAGE ON SCHEMA sugar TO anon, authenticated, service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sugar TO authenticated, service_role;