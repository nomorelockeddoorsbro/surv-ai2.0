/*
  # Initial Schema Setup for Survey AI Platform

  1. New Tables
    - users
      - Stores user profile information
      - Links to Supabase auth.users
    - surveys
      - Stores survey information and completion status
    - earnings
      - Tracks user earnings across different payment platforms
    - ai_logs
      - Stores AI activity and communication logs
    
  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  email text NOT NULL,
  full_name text,
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Surveys table
CREATE TABLE IF NOT EXISTS surveys (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  platform text NOT NULL,
  status text NOT NULL,
  reward_amount decimal(10,2),
  reward_currency text,
  completed_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE surveys ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own surveys"
  ON surveys
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own surveys"
  ON surveys
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Earnings table
CREATE TABLE IF NOT EXISTS earnings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  amount decimal(10,2) NOT NULL,
  currency text NOT NULL,
  platform text NOT NULL,
  status text NOT NULL,
  payout_method text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE earnings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own earnings"
  ON earnings
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own earnings"
  ON earnings
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- AI Logs table
CREATE TABLE IF NOT EXISTS ai_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  action text NOT NULL,
  details jsonb,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE ai_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own AI logs"
  ON ai_logs
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own AI logs"
  ON ai_logs
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);