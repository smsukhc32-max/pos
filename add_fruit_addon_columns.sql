-- Add fruit addon columns to products table
ALTER TABLE products ADD COLUMN IF NOT EXISTS fruit_addon_enabled BOOLEAN DEFAULT false;
ALTER TABLE products ADD COLUMN IF NOT EXISTS fruit_addon_price INTEGER DEFAULT 0;
