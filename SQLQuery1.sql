-- Tạo cơ sở dữ liệu
CREATE DATABASE SalesDB;
GO

USE SalesDB;
GO

-- Bảng Customer
CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(255)
);

-- Bảng Employee
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20)
);

-- Bảng Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(18,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Bảng Product
CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    StockQuantity INT NOT NULL
);

-- Bảng OrderDetail
CREATE TABLE OrderDetail (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Chèn dữ liệu vào bảng Customer
INSERT INTO Customer (Name, Email, Phone, Address) VALUES
('Nguyen Van A', 'a@gmail.com', '0123456789', 'Hanoi'),
('Le Thi B', 'b@gmail.com', '0987654321', 'HCM'),
('Tran Van C', 'c@gmail.com', '0345678901', 'Da Nang'),
('Pham Thi D', 'd@gmail.com', '0567890123', 'Can Tho'),
('Hoang Van E', 'e@gmail.com', '0789012345', 'Hue');

-- Chèn dữ liệu vào bảng Employee
INSERT INTO Employee (Name, Position, Email, Phone) VALUES
('Nguyen Tuan', 'Manager', 'tuan@gmail.com', '0901234567'),
('Tran Ha', 'Sales', 'ha@gmail.com', '0912345678'),
('Le Khang', 'Support', 'khang@gmail.com', '0923456789'),
('Pham Hieu', 'Sales', 'hieu@gmail.com', '0934567890'),
('Dang Phuc', 'Manager', 'phuc@gmail.com', '0945678901');

-- Chèn dữ liệu vào bảng Product
INSERT INTO Product (Name, Price, StockQuantity) VALUES
('Laptop', 15000000, 10),
('Smartphone', 8000000, 20),
('Tablet', 5000000, 15),
('Monitor', 3000000, 25),
('Keyboard', 500000, 50);

-- Chèn dữ liệu vào bảng Orders
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, TotalAmount) VALUES
(1, 2, '2025-03-06', 15000000),
(2, 3, '2025-03-05', 8000000),
(3, 1, '2025-03-04', 5000000),
(4, 4, '2025-03-03', 3000000),
(5, 5, '2025-03-02', 500000),
(1, 3, '2025-03-07', 20000000); -- Thêm đơn hàng mới cho khách hàng CustomerID=1

-- Chèn dữ liệu vào bảng OrderDetail
INSERT INTO OrderDetail (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 15000000),
(2, 2, 1, 8000000),
(3, 3, 1, 5000000),
(4, 4, 1, 3000000),
(5, 5, 1, 500000),
(6, 1, 2, 20000000); -- Thêm chi tiết đơn hàng cho đơn mới


SELECT Product.*
FROM PRODUCT
join OrderDetail on product.ProductID = OrderDetail.ProductID
where OrderID = 2;

select *
FROM Customer
join Orders on Customer.CustomerID = Orders.CustomerID;

select *
FROM Orders
join Customer on Orders.CustomerID = Customer.CustomerID;

select *
FROM Orders
join Customer on Orders.CustomerID = Customer.CustomerID
Where OrderID = 2;

select *
from product
where Product.StockQuantity <20 ;

select *
from product

--1)Hiển thị danh sách các sản phẩm cùng giá của nó 
select *
from Product p1
join Product p2 on p1.Price=p2.Price
and p1.ProductID <> p2.ProductID
where