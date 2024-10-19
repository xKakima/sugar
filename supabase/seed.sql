DROP SCHEMA IF EXISTS sugar CASCADE;

DROP POLICY IF EXISTS "Users can view their own data" ON auth.users;
CREATE POLICY "Users can view their own data" on auth.users
FOR SELECT
USING ( auth.uid() = auth.users.id );

CREATE SCHEMA sugar;
CREATE EXTENSION IF NOT EXISTS pg_cron;

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
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    partner_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    user_type sugar.user_type NOT NULL DEFAULT 'NONE',
    unique_code VARCHAR(255),
    fcm_token TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sugar.monthly_budget (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    partner_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    budget integer NOT NULL DEFAULT 10000,
    balance integer,
    reset_day INTEGER CHECK (reset_day BETWEEN 1 AND 31),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sugar.account (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    account_name TEXT NOT NULL DEFAULT 'sweet funds',
    balance NUMERIC NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sugar.expense(
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL REFERENCES sugar.user_data(user_id) ON DELETE CASCADE,
    expense_type sugar.expense_type NOT NULL,
    amount NUMERIC NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create Triggers
CREATE OR REPLACE FUNCTION sugar.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
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

CREATE TRIGGER set_unique_code
BEFORE INSERT ON sugar.user_data
FOR EACH ROW
EXECUTE FUNCTION sugar.generate_unique_code();

CREATE TRIGGER set_balance
BEFORE INSERT ON sugar.monthly_budget
FOR EACH ROW
EXECUTE FUNCTION sugar.set_monthly_budget_balance();

CREATE OR REPLACE FUNCTION sugar.check_reset_day() 
RETURNS VOID AS $$
DECLARE
    rec sugar.monthly_budget%ROWTYPE; -- Declare rec as a row type of the table
BEGIN
    -- Loop through all monthly budgets
    FOR rec IN SELECT * FROM sugar.monthly_budget LOOP
        IF EXTRACT(DAY FROM CURRENT_DATE) = rec.reset_day THEN
            -- Update the balance to match the budget
            UPDATE sugar.monthly_budget
            SET balance = rec.budget, updated_at = NOW()
            WHERE sugar.monthly_budget.id = rec.id;

            -- Log the update
            RAISE NOTICE 'Updated row: id=%, user_id=%, budget=%, balance=% at %',
                rec.id, rec.user_id, rec.budget, rec.budget, NOW();
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

    -- Return the partner's user_id
    RETURN partner_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sugar.get_expenses(_user_id UUID)
RETURNS TABLE (
    id UUID,
    user_id UUID,
    expense_type sugar.expense_type,
    amount numeric,
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



GRANT SELECT ON auth.users TO authenticated;
GRANT USAGE ON SCHEMA sugar TO anon, authenticated, service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sugar TO authenticated, service_role;