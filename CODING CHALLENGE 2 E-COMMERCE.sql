CREATE DATABASE ECOM

CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(50),
    address VARCHAR(50)
);
INSERT INTO Customer (customerID, firstName, lastName, email, address) VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '123 Main St, City'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '456 Elm St, Town'),
(3, 'Robert', 'Johnson', 'robert@example.com', '789 Oak St, Village'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '101 Pine St, Suburb'),
(5, 'David', 'Lee', 'david@example.com', '234 Cedar St, District'),
(6, 'Laura', 'Hall', 'laura@example.com', '567 Birch St, County'),
(7, 'Michael', 'Davis', 'michael@example.com', '890 Maple St, State'),
(8, 'Emma', 'Wilson', 'emma@example.com', '321 Redwood St, Country'),
(9, 'William', 'Taylor', 'william@example.com', '432 Spruce St, Province'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '765 Fir St, Territory');

CREATE TABLE Product (
    productID INT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(50),
    price INT,
    stockQuantity INT
);

INSERT INTO Product (productID, name, description, price, stockQuantity) VALUES
(1, 'Laptop', 'High-performance laptop', 800, 10),
(2, 'Smartphone', 'Latest smartphone', 600, 15),
(3, 'Tablet', 'Portable tablet', 300, 20),
(4, 'Headphones', 'Noise-canceling', 150, 30),
(5, 'TV', '4K Smart TV', 900, 5),
(6, 'Coffee Maker', 'Automatic coffee maker', 50, 25),
(7, 'Refrigerator', 'Energy-efficient', 700, 10),
(8, 'Microwave Oven', 'Countertop microwave', 80, 15),
(9,'Blender','High-speed blender',70,20),
(10,'Vaccum Cleaner','BAgless vaccum vleaner',120,10);

CREATE TABLE Cart (
    cartID INT PRIMARY KEY,
    customerID INT foreign key(customerID) references Customer(customerID) on delete cascade,
    productID INT foreign key(productID) references Product(productID) on delete cascade,
    quantity INT
);
INSERT INTO Cart (cartID, customerID, productID, quantity) VALUES
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 2, 3),
(4, 3, 4, 4),
(5, 3, 5, 2),
(6, 4, 6, 1),
(7, 5, 1, 1),
(8, 6, 10, 2),
(9, 6, 9, 3),
(10, 7, 7, 2);

CREATE TABLE Orders (
    orderID INT PRIMARY KEY,
    customerID INT foreign key(customerID) references Customer(customerID) on delete cascade,
    orderDate DATE,
    totalAmount INT
);
INSERT INTO Orders(orderID, customerID, orderDate, totalAmount) VALUES
(1, 1, '2023-01-05', 1200),
(2, 2, '2023-02-10', 900),
(3, 3, '2023-03-15', 300),
(4, 4, '2023-04-20', 150),
(5, 5, '2023-05-25', 1800),
(6, 6, '2023-06-30', 400),
(7, 7, '2023-07-05', 700),
(8, 8, '2023-08-10', 160),
(9, 9, '2023-09-15', 140),
(10, 10, '2023-10-20', 1400);


CREATE TABLE OrderItem (
    orderItemID INT PRIMARY KEY,
    orderID INT foreign key(orderID) references Orders(orderID) on delete cascade,
    productID INT foreign key(productID) references Product(productID) on delete cascade,
    quantity INT,
    itemAmount INT
);
INSERT INTO OrderItem (orderItemID, orderID, productID, quantity, itemAmount) VALUES
(1, 1, 1, 2, 1600),
(2, 1, 3, 1, 300),
(3, 2, 2, 3, 1800),
(4, 3, 5, 2, 1800),
(5, 4, 4, 4, 600),
(6, 4, 6, 1, 50),
(7, 5, 1, 1, 800),
(8, 5, 2, 2, 1200),
(9, 6, 10, 2, 240),
(10, 6, 9, 3, 210);

--Q1
UPDATE Product
set price=800 
where name='Refrigerator'
--Q2
delete Cart
where customerID=1
--Q3
select * from Product
where price<100
--Q4
select * from Product
where stockQuantity>5
--Q5
select * from Orders
where totalAmount between 500 and 1000
--Q6
select * from Product
where [name] like '%r'
--Q7
select * from Cart as c
inner join Product as p on p.productID=c.productID
where p.productID=5 
--Q8
select * from Orders
where YEAR(orderDate) = 2023
--Q9
select name, min(stockQuantity) as min_stock_quantity from Product
group by name
--Q10
select c.firstName,c.lastName, c.customerID, totalAmount from Orders as o
inner join Customer as c on c.customerID = o.customerID
--Q11
select firstName,lastName, avg(itemAmount) as average_amount from OrderItem as OI
inner join Orders as o on o.orderID=OI.orderID
inner join Customer as C on C.customerID=o.customerID
group by o.orderID, firstName,lastName
--Q12
select c.firstName,c.lastName,count(orderID) as total_orders_placed from Orders as o
inner join Customer as c on c.customerID=o.customerID
group by c.customerID,c.firstName,c.lastName
--Q13
select customerID,max(totalAmount) as max_order_amount from Orders
group by customerID
--Q14
select firstName,lastName,totalAmount from Customer as c
inner join Orders as o on c.customerID=o.customerID
where totalAmount>1000
--Q15
select * from Product 
where productID not in(select productID from Cart)
--Q16
select * from Customer
where customerID not in (select c.customerID from OrderItem as oi
inner join Orders as o on o.orderID=oi.orderID
inner join Customer as c on c.customerID=o.customerID
group by c.customerID)
--Q17
select name,p.productID, sum(oi.itemAmount) as TotalRevenue from OrderItem as OI
right join Product as p on p.productID = oi.productID 
group by p.productID,name
order by TotalRevenue desc
--Q18
select name,stockQuantity from Product
where stockQuantity<(select avg(stockQuantity) from Product)
--Q19
select firstName,lastName,totalAmount from Customer as c
inner join Orders as o on c.customerID=o.customerID
where totalAmount>(select avg(totalAmount) from Orders)