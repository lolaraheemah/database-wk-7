-- answers.sql

-- ============================================================
-- Question 1 🛠️ Achieving 1NF
-- The Products column has multiple values per row, violating 1NF.
-- Goal: Split into separate rows so each product is atomic.

-- Assuming we start with a table ProductDetail(OrderID, CustomerName, Products).
-- In MySQL, one way is to use INSERT + SELECT UNION ALL to normalize data.

-- First create a new table in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert normalized data
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES 
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Now ProductDetail_1NF is in 1NF (no repeating groups, atomic values).


-- ============================================================
-- Question 2 🧩 Achieving 2NF
-- OrderDetails table is in 1NF but has a partial dependency:
-- CustomerName depends only on OrderID, not on (OrderID, Product).
-- Solution: Separate into two tables: Orders and OrderItems.

-- Table 1: Orders (OrderID → CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique orders
INSERT INTO Orders (OrderID, CustomerName)
VALUES 
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Table 2: OrderItems (OrderID + Product → Quantity)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert order details
INSERT INTO OrderItems (OrderID, Product, Quantity)
VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Now:
-- Orders table handles CustomerName (depends only on OrderID).
-- OrderItems table handles product-level details (depends on OrderID + Product).
-- This removes partial dependency, so table is in 2NF.