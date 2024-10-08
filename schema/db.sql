DROP SCHEMA IF EXISTS sugar CASCADE;

DROP POLICY IF EXISTS "Users can view their own data" ON auth.users;
CREATE POLICY "Users can view their own data" on auth.users
FOR SELECT
USING ( auth.uid() = auth.users.id );

CREATE SCHEMA sugar;

-- Create Functions
CREATE OR REPLACE FUNCTION generate_unique_code()
RETURNS TRIGGER AS $$
BEGIN
  -- Generate a random 6-character alphanumeric code
  NEW.unique_code := substring(md5(random()::text) from 1 for 6);
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
    budget integer NOT NULL DEFAULT 10000,
    reset_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.monthly_budget ENABLE ROW LEVEL SECURITY;

CREATE TABLE sugar.balance (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    balance INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.balance ENABLE ROW LEVEL SECURITY;

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
CREATE OR REPLACE FUNCTION update_updated_at_column()
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
            EXECUTE FUNCTION update_updated_at_column();',
            rec.tablename, schema_name, rec.tablename
        );
    END LOOP;
END $$;

CREATE TRIGGER set_unique_code
BEFORE INSERT ON sugar.user_data
FOR EACH ROW
EXECUTE FUNCTION generate_unique_code();



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


GRANT USAGE ON SCHEMA sugar TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sugar TO authenticated;


-- TODO: create a table for transactions