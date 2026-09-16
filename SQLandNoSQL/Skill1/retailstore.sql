CREATE DATABASE RetailStoreDB;

USE RetailStoreDB;

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(200)
);

-- Category Table
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- Product Table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    CategoryID INT NOT NULL,

    FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),

    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
);

-- OrderItem Table
CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),

    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID)
);

----------------
-- Insert Categories
INSERT INTO Category (CategoryName)
VALUES
('Electronics'),
('Groceries'),
('Stationery');

-- Insert Customers
INSERT INTO Customer (Name, Phone, Email, Address)
VALUES
('Rahul Sharma', '9876543210', 'rahul@gmail.com', 'Pune'),
('Priya Patil', '9823456789', 'priya@gmail.com', 'Mumbai'),
('Amit Joshi', '9765432109', 'amit@gmail.com', 'Nashik');

-- Insert Products
INSERT INTO Product
(ProductName, Price, StockQuantity, CategoryID)
VALUES
('Wireless Mouse', 799.00, 25, 1),
('USB Keyboard', 999.00, 20, 1),
('Rice 5kg', 450.00, 30, 2),
('Notebook', 80.00, 100, 3),
('Ball Pen', 20.00, 200, 3);

-- Insert Orders
INSERT INTO Orders
(OrderDate, CustomerID, TotalAmount)
VALUES
('2026-09-10', 1, 1798.00),
('2026-09-11', 2, 530.00);

-- Insert Order Items
INSERT INTO OrderItem
(OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 799.00),
(1, 2, 1, 999.00),
(2, 3, 1, 450.00),
(2, 4, 1, 80.00);


-- prints
SELECT * FROM Customer;

SELECT * FROM Category;

SELECT * FROM Product;

SELECT * FROM Orders;

SELECT * FROM OrderItem;
