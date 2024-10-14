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
    CREATE TYPE sugar.user_type AS ENUM ('DADDY', 'BABY'); 
  END IF; 
END $$;

-- Create Tables
CREATE TABLE sugar.user_data (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    partner_id UUID REFERENCES auth.users(id),
    user_type sugar.user_type NOT NULL DEFAULT 'BABY',
    unique_code VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.user_data ENABLE ROW LEVEL SECURITY;

CREATE TABLE sugar.monthly_budget (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    partner_id UUID REFERENCES auth.users(id),
    budget integer NOT NULL DEFAULT 10000,
    balance integer,
    reset_day INTEGER CHECK (reset_day BETWEEN 1 AND 31),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.monthly_budget ENABLE ROW LEVEL SECURITY;

CREATE TABLE sugar.account (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    account_name TEXT NOT NULL DEFAULT 'sweet funds',
    budget_id UUID REFERENCES sugar.monthly_budget(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.account ENABLE ROW LEVEL SECURITY;

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


DO $$
DECLARE
    rec RECORD;
    schema_name CONSTANT TEXT := 'sugar';
BEGIN
    FOR rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = schema_name
          AND table_type = 'BASE TABLE'
    LOOP
        -- Check if 'user_id' column exists in the table
        IF EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = schema_name
              AND table_name = rec.table_name
              AND column_name = 'user_id'
        ) THEN
            -- Enable RLS on the table
            EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY;', schema_name, rec.table_name);

            -- Create the policy
            EXECUTE format(
                'CREATE POLICY "Users can manage their own data on %I.%I" ON %I.%I
                 FOR ALL
                 TO authenticated
                 USING (auth.uid() = user_id)
                 WITH CHECK (auth.uid() = user_id);',
                schema_name, rec.table_name, schema_name, rec.table_name
            );
        END IF;
    END LOOP;
END $$;

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


CREATE OR REPLACE VIEW sugar.user_data_limited AS
SELECT user_id, user_type, unique_code,created_at
FROM sugar.user_data;


GRANT USAGE ON SCHEMA sugar TO anon, authenticated;
GRANT SELECT ON sugar.user_data_limited TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sugar TO authenticated;



-- TODO: create a table for transactions