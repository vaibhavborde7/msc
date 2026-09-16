
-- Practical 1:


-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS shopdb;
USE shopdb;

-- Remove existing tables so the script can be rerun
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

-- 2. Create the categories table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Create the customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    city VARCHAR(100),
    signup_date DATE 
);

-- 4. Create the products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

-- 5. Create the orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'placed',

    CONSTRAINT chk_order_status
        CHECK (status IN
        ('placed', 'shipped', 'delivered', 'cancelled')),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 6. Create the order_items table
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================

-- 7. Insert categories
INSERT INTO categories (category_name)
VALUES
('Electronics'),
('Books'),
('Clothing');

-- 8. Insert customers
INSERT INTO customers
(name, email, city, signup_date)
VALUES
('Asha Rao', 'asha@x.com', 'Pune', '2024-01-05'),
('Ravi Nair', 'ravi@x.com', 'Mumbai', '2024-02-10'),
('Sara Ali', 'sara@x.com', 'Pune', '2024-03-01'),
('Om Verma', 'om@x.com', 'Delhi', '2024-03-15'),
('Neha Shah', 'neha@x.com', 'Mumbai', '2024-04-02');

-- 9. Insert products
INSERT INTO products
(product_name, category_id, price, stock)
VALUES
('Laptop', 1, 60000, 10),
('Headphones', 1, 2000, 50),
('SQL Book', 2, 800, 100),
('Novel', 2, 400, 60),
('T-Shirt', 3, 700, 80),
('Jacket', 3, 3000, 20);

-- 10. Insert orders
INSERT INTO orders
(customer_id, order_date, status)
VALUES
(1, '2024-05-01', 'delivered'),
(2, '2024-05-03', 'shipped'),
(1, '2024-06-10', 'placed'),
(3, '2024-06-12', 'delivered'),
(4, '2024-07-01', 'cancelled');

-- 11. Insert order items
INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 60000),
(1, 2, 2, 2000),
(2, 3, 3, 800),
(2, 5, 2, 700),
(3, 2, 1, 2000),
(4, 1, 1, 60000),
(4, 6, 1, 3000),
(5, 4, 2, 400);

-- =====================================================
-- VERIFICATION STATEMENTS
-- =====================================================

-- (a) List every product with its category name and price
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price
FROM products AS p
JOIN categories AS c
    ON p.category_id = c.category_id;

-- (b) Reduce the stock of Laptop by 1
SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET stock = stock - 1
WHERE product_name = 'Laptop';

-- Verify the updated Laptop stock
SELECT product_name, stock
FROM products
WHERE product_name = 'Laptop';

-- (c) Delete the cancelled order together with its order_items

-- First delete the related order_items
DELETE FROM order_items
WHERE order_id IN (
    SELECT order_id
    FROM orders
    WHERE status = 'cancelled'
);

-- Then delete the cancelled order
DELETE FROM orders
WHERE status = 'cancelled';
SET SQL_SAFE_UPDATES = 1;
-- Verify that the cancelled order has been removed
SELECT *
FROM orders;

-- Verify that its order_items have been removed
SELECT *
FROM order_items;