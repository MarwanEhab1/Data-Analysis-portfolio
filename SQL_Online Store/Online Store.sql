create database OnlineStore;

-- Create Category Table
CREATE TABLE Category (
    cid INT PRIMARY KEY,
    category_name nvarchar(255) NOT NULL
);

-- Create Product Table
CREATE TABLE Product (
    pid INT PRIMARY KEY,
    product_name NVARCHAR(255) NOT NULL,
    qty INT NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    cid INT FOREIGN KEY REFERENCES Category(cid)
);

-- Create User Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name NVARCHAR(255) NOT NULL,
    address NVARCHAR(255),
    phone NVARCHAR(15),
    gender NVARCHAR(10)
);

-- Create Order Table
CREATE TABLE Orders (
    id INT PRIMARY KEY,
    status NVARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    delivery_date DATE,
    user_id INT FOREIGN KEY REFERENCES Users(user_id)
);

-- Create Payment Table
CREATE TABLE Payment (
    id INT PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(id),
    amount DECIMAL(10, 2) NOT NULL,
    method NVARCHAR(50) NOT NULL,
    payment_status NVARCHAR(50) NOT NULL
);

-- Create Shipping Table
CREATE TABLE Shipping (
    sid INT PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(id),
    address NVARCHAR(255) NOT NULL
);

-- Create Customer Table (Subtype of User)
CREATE TABLE Customer (
    user_id INT PRIMARY KEY FOREIGN KEY REFERENCES Users(user_id),
    credit_card NVARCHAR(20)
);

-- Create Cashier Table (Subtype of User)
CREATE TABLE Cashier (
    user_id INT PRIMARY KEY FOREIGN KEY REFERENCES Users(user_id),
    salary DECIMAL(10, 2) NOT NULL
);

-- Create Delivery_man Table (Subtype of User)
CREATE TABLE Delivery_man (
    user_id INT PRIMARY KEY FOREIGN KEY REFERENCES Users(user_id),
    salary DECIMAL(10, 2) NOT NULL
);

-- Establish Relationships

-- Relationship between Product and Order through an associative table
CREATE TABLE Order_Product (
    order_id INT FOREIGN KEY REFERENCES Orders(id),
    pid INT FOREIGN KEY REFERENCES Product(pid),
    order_qty INT NOT NULL,
    PRIMARY KEY (order_id, pid)
);




-- Insert categories into the Category table
INSERT INTO Category (cid, category_name) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing'),
(4, 'Home & Kitchen');

-- Insert products into the Product table
INSERT INTO Product (pid, product_name, qty, description, price, cid) VALUES
(1, 'Smartphone', 50, 'Latest model smartphone', 699.99, 1),
(2, 'Laptop', 30, 'High performance laptop', 1299.99, 1),
(3, 'Fiction Book', 100, 'A best-selling fiction novel', 15.99, 2),
(4, 'T-shirt', 200, 'Cotton t-shirt in various colors', 19.99, 3),
(5, 'Coffee Maker', 20, 'Automatic coffee maker with grinder', 89.99, 4);

-- Insert users into the User table
INSERT INTO Users (user_id, user_name, address, phone, gender) VALUES
(1, 'John Doe', '123 Elm St, Springfield', '555-1234', 'Male'),
(2, 'Jane Smith', '456 Oak St, Springfield', '555-5678', 'Female'),
(3, 'Alex Johnson', '789 Pine St, Springfield', '555-8765', 'Other'),
(4, 'Michael Brown', '321 Cedar St, Springfield', '555-4321', 'Male'),
(5, 'Emma Wilson', '654 Birch St, Springfield', '555-6789', 'Female'),
(6, 'Liam Davis', '987 Maple St, Springfield', '555-9876', 'Male');

-- Insert orders into the Order table
INSERT INTO Orders (id, status, date, delivery_date, user_id) VALUES
(1, 'Pending', '2024-10-01', '2024-10-05', 1),
(2, 'Shipped', '2024-10-02', '2024-10-06', 2),
(3, 'Delivered', '2024-10-03', '2024-10-07', 3);

-- Insert payments into the Payment table
INSERT INTO Payment (id, order_id, amount, method, payment_status) VALUES
(1, 1, 699.99, 'Credit Card', 'Paid'),
(2, 2, 15.99, 'PayPal', 'Paid'),
(3, 3, 19.99, 'Debit Card', 'Pending');

-- Insert shipping details into the Shipping table
INSERT INTO Shipping (sid, order_id, address) VALUES
(1, 1, '123 Elm St, Springfield'),
(2, 2, '456 Oak St, Springfield'),
(3, 3, '789 Pine St, Springfield');

-- Insert customers into the Customer table
INSERT INTO Customer (user_id, credit_card) VALUES
(1, '1234-5678-9012-3456'),
(2, '9876-5432-1098-7654');

-- Insert cashiers into the Cashier table
INSERT INTO Cashier (user_id, salary) VALUES
(3, 3500.00),
(4, 3000.00); 

-- Insert delivery men into the Delivery_man table
INSERT INTO Delivery_man (user_id, salary) VALUES
(5, 2500.00),
(6, 2700.00); 

-- Insert records into the Order_Product associative table
INSERT INTO Order_Product (order_id, pid, order_qty) VALUES
(1, 1, 1),  -- Order 1 includes 1 Smartphone
(1, 3, 2),  -- Order 1 includes 2 Fiction Books
(2, 2, 1),  -- Order 2 includes 1 Laptop
(3, 4, 3);  -- Order 3 includes 3 T-shirts




SELECT * FROM product WHERE cid = 13 OR price < 20 ;

SELECT * FROM product
SELECT DISTINCT cid FROM product;

SELECT cid, sum(price) AS 'TOTAL PRICE'
FROM product
GROUP BY cid;


SELECT *
FROM product
WHERE cid is not null;



SELECT cid, sum(price) AS 'TOTAL PRICE'
FROM product
WHERE cid is null	
GROUP BY cid;



SELECT cid, sum(price) AS 'TOTAL PRICE'
FROM product
WHERE cid is not null	
GROUP BY cid
HAVING sum(price) <= 100;



SELECT cid, sum(price) AS 'TOTAL PRICE'
FROM product
WHERE cid is not null	
GROUP BY cid
HAVING sum(price) <= 100
ORDER BY cid DESC;

SELECT Category.category_name, avg (price) AS 'Average PRICE'
FROM product
join Category
on Category.cid=product.cid
WHERE product.cid is not null	
GROUP BY Category.category_name
HAVING sum(price) <= 100
;

SELECT Category.category_name, Sum (price) AS 'Sum PRICE'
FROM product
join Category
on Category.cid=product.cid
WHERE product.cid is not null	
GROUP BY Category.category_name
;


SELECT *
FROM Order_Product -- Table #1
INNER JOIN 
Orders -- Table #2
ON Order_Product.order_id = Orders.id
INNER JOIN 
Users -- Table #3 
ON Orders.user_id = Users.user_id
INNER JOIN 
Product -- Table #4 
ON Product.pid = Order_Product.pid;


-- Full Join
SELECT *
FROM Users 
FULL JOIN
Customer
ON Customer.user_id = Users.user_id
where Users.gender = 'Male'
;

SELECT *
FROM Product
LEFT JOIN
Category
ON Category.cid = Product.cid;

SELECT *
FROM Product
RIGHT JOIN
Category
ON Category.cid = Product.cid
;


SELECT * 
FROM Users -- 1
LEFT JOIN Delivery_man -- 2
ON Users.user_id = Delivery_man.user_id
LEFT JOIN 
Cashier -- 3
ON Users.user_id = Cashier.user_id
LEFT JOIN
Customer -- 4
ON Users.user_id = Customer.user_id
LEFT JOIN
Orders -- 5
ON Users.user_id = Orders.user_id
LEFT JOIN
Payment -- 6
ON Orders.id = Payment.order_id
LEFT JOIN
Shipping -- 7
ON Orders.id = Shipping.order_id
LEFT JOIN 
Order_Product -- 8
ON Orders.id = Order_Product.order_id
LEFT JOIN
Product -- 9
ON Product.pid = Order_Product.pid
LEFT JOIN
Category  -- 10
ON Product.cid = Category.cid
;

CREATE VIEW OrderDetailsView AS
select O.status,S.address from Orders As O
left join Shipping As S
ON O.id = S.order_id;


select * from OrderDetailsView
;


SELECT Product.product_name AS 'Product Name', Category.category_name
FROM Product
INNER JOIN
Category
ON Product.cid = Category.cid
WHERE Category.category_name = 'Electronics'


SELECT * FROM Category where category_name = 'Electronics'

-- SELECT * FROM Product where cid = X




SELECT * FROM Product where cid = (
	SELECT cid FROM Category where category_name = 'Electronics'
)



SELECT * FROM Orders WHERE id = 1


SELECT * FROM Payment WHERE order_id IN (
	SELECT id FROM Orders WHERE status = 'Pending'
)


SELECT * FROM Orders where user_id IN (
	SELECT user_id FROM Users WHERE user_name LIKE 'John%' 
)

SELECT *
FROM Orders
INNER JOIN
Users
ON Orders.user_id = Users.user_id
WHERE Users.user_name LIKE 'John%'



SELECT * FROM Product WHERE cid IS NOT NULL

SELECT * FROM Product WHERE cid IN(
	SELECT cid from Category
);

SELECT *
FROM Orders
INNER JOIN
Users
ON Orders.user_id = Users.user_id
WHERE Users.user_name LIKE 'John%'
;




SELECT Product.product_name AS 'Product Name', Category.category_name
FROM Product
INNER JOIN
Category
ON Product.cid = Category.cid
WHERE Category.category_name = 'Electronics'







SELECT * FROM Product where cid = (
	SELECT cid FROM Category where category_name = 'Electronics'
)



SELECT * FROM Orders WHERE id = 1


SELECT * FROM Payment WHERE order_id IN (
	SELECT id FROM Orders WHERE status = 'Pending'
)


SELECT * FROM Orders where user_id IN (
	SELECT user_id FROM Users WHERE user_name LIKE 'John%' 
)


SELECT * FROM Product WHERE cid IN(
	SELECT cid from Category
);