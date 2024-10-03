DROP SCHEMA IF EXISTS sugar CASCADE;

DROP POLICY IF EXISTS "Users can view their own data" ON auth.users;
CREATE POLICY "Users can view their own data" on auth.users
FOR SELECT
USING ( auth.uid() = auth.users.id );

CREATE SCHEMA sugar;

-- Create Functions
CREATE OR REPLACE FUNCTION create_crud_policy_with_reference(
    table_name text, 
    reference_table_name text, 
    reference_column_name text
) RETURNS VOID AS $$
BEGIN
    EXECUTE format('
        CREATE POLICY "Users can insert their own data on %1$s" ON %1$s
        FOR INSERT
        TO authenticated
        WITH CHECK ((SELECT user_id FROM %2$s WHERE %3$s = %1$s.%3$s) = auth.uid());

        CREATE POLICY "Users can select their own data on %1$s" ON %1$s
        FOR SELECT
        TO authenticated
        USING ((SELECT user_id FROM %2$s WHERE %3$s = %1$s.%3$s) = auth.uid());

        CREATE POLICY "Users can update their own data on %1$s" ON %1$s
        FOR UPDATE
        TO authenticated
        USING ((SELECT user_id FROM %2$s WHERE %3$s = %3$s) = auth.uid());

        CREATE POLICY "Users can delete their own data on %1$s" ON %1$s
        FOR DELETE
        TO authenticated
        USING ((SELECT user_id FROM %2$s WHERE %3$s = %3$s) = auth.uid());
    ', table_name, reference_table_name, reference_column_name);
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
    user_type sugar.user_type NOT NULL DEFAULT 'BABY',
    unique_code VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.user_data ENABLE ROW LEVEL SECURITY;
SELECT create_crud_policy_with_reference('sugar.user_data', 'auth.users', 'user_id');

CREATE TABLE sugar.monthly_budget (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    budget integer NOT NULL DEFAULT 10000,
    reset_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.monthly_budget ENABLE ROW LEVEL SECURITY;
SELECT create_crud_policy_with_reference('sugar.monthly_budget', 'auth.users', 'user_id');

CREATE TABLE sugar.balance (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    balance INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.balance ENABLE ROW LEVEL SECURITY;
SELECT create_crud_policy_with_reference('sugar.balance', 'auth.users', 'user_id');

CREATE TABLE sugar.account (
    id UUID NOT NULL UNIQUE DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id),
    account_name TEXT NOT NULL DEFAULT 'sweet funds',
    budget_id UUID REFERENCES sugar.monthly_budget(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE sugar.account ENABLE ROW LEVEL SECURITY;
SELECT create_crud_policy_with_reference('sugar.account', 'auth.users', 'user_id');

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
