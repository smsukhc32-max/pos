-- ===== ป้าณาน้ำผลไม้ปั่น — Supabase Schema =====
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor → New Query)

-- 1) Profiles table (users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'customer' CHECK (role IN ('owner', 'employee', 'customer')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2) Products table
CREATE TABLE IF NOT EXISTS products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER NOT NULL,
  category TEXT NOT NULL DEFAULT 'ผลไม้ปั่น',
  emoji TEXT DEFAULT '🍹',
  description TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  fruit_addon_enabled BOOLEAN DEFAULT false,
  fruit_addon_price INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3) Orders table
CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  items JSONB NOT NULL DEFAULT '[]',
  total INTEGER NOT NULL DEFAULT 0,
  payment_method TEXT NOT NULL DEFAULT 'cash',
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('completed', 'pending', 'cancelled')),
  customer_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  employee_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  slip_url TEXT,
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4) Disable RLS (we handle auth in app code)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Allow anon access (since we do custom auth, not Supabase Auth)
CREATE POLICY "Allow all for profiles" ON profiles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for products" ON products FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for orders" ON orders FOR ALL USING (true) WITH CHECK (true);

-- 5) Seed default data

-- Owner account
INSERT INTO profiles (username, password, name, email, phone, role) VALUES
  ('admin', '1234', 'ป้าณา', 'pana@shop.com', '081-234-5678', 'owner');

-- Employee account
INSERT INTO profiles (username, password, name, email, phone, role) VALUES
  ('somchai', '1234', 'สมชาย ใจดี', 'somchai@shop.com', '089-111-2222', 'employee');

-- Customer account
INSERT INTO profiles (username, password, name, email, phone, role) VALUES
  ('manee', '1234', 'มานี รักสุข', 'manee@mail.com', '086-333-4444', 'customer');

-- Products
INSERT INTO products (name, price, category, emoji, description) VALUES
  ('น้ำมะม่วงปั่น', 45, 'ผลไม้ปั่น', '🥭', 'มะม่วงสุกหวานฉ่ำ ปั่นสด'),
  ('น้ำสตรอว์เบอร์รี่ปั่น', 55, 'ผลไม้ปั่น', '🍓', 'สตรอว์เบอร์รี่สดจากดอย'),
  ('น้ำแตงโมปั่น', 35, 'ผลไม้ปั่น', '🍉', 'แตงโมเย็นชื่นใจ'),
  ('น้ำส้มคั้นสด', 40, 'น้ำคั้นสด', '🍊', 'ส้มคั้นสด 100%'),
  ('น้ำแอปเปิ้ลปั่น', 50, 'ผลไม้ปั่น', '🍎', 'แอปเปิ้ลปั่นสด หวานธรรมชาติ'),
  ('น้ำกีวี่ปั่น', 60, 'ผลไม้ปั่น', '🥝', 'กีวี่สดนำเข้า เปรี้ยวหวาน'),
  ('น้ำเสาวรสปั่น', 40, 'ผลไม้ปั่น', '🍈', 'เสาวรสสดชื่น วิตามินซีสูง'),
  ('น้ำฝรั่งปั่น', 35, 'ผลไม้ปั่น', '🍐', 'ฝรั่งปั่นหวานกรอบ'),
  ('สมูทตี้มิกซ์เบอร์รี่', 65, 'สมูทตี้', '🫐', 'ผสมผสานเบอร์รี่นานาชนิด'),
  ('สมูทตี้กล้วยโยเกิร์ต', 55, 'สมูทตี้', '🍌', 'กล้วย+โยเกิร์ต อร่อยมีประโยชน์'),
  ('น้ำมะพร้าวปั่น', 45, 'น้ำคั้นสด', '🥥', 'มะพร้าวน้ำหอมปั่นเย็น'),
  ('น้ำแครอทปั่น', 40, 'น้ำคั้นสด', '🥕', 'แครอทสดปั่น บำรุงสายตา');
