create database shopping_project;
use shopping_project;

create table customer (
cust_id varchar(5) primary key,
f_name varchar(50),
l_name varchar(50),
area varchar(10),
phone_no varchar(10)
);
INSERT INTO customer (cust_id, f_name, l_name, area, phone_no)
VALUES
('C001', 'Rahul', 'Sharma', 'Pune', '9876543210'),
('C002', 'Priya', 'Patil', 'Mumbai', '9123456780'),
('C003', 'Amit', 'Joshi', 'Nagpur', '9988776655'),
('C004', 'Sneha', 'Kulkarni', 'Nashik', '9765432109'),
('C005', 'Rohan', 'Deshmukh', 'Pune', '9012345678'),
('C006', 'Neha', 'More', 'Mumbai', '9898989898'),
('C007', 'Akash', 'Jadhav', 'Nagpur', '9090909090');

select * from customer;
select f_name, area from customer where cust_id='C003';
select f_name,l_name,phone_no from customer;
select count(*) from customer;
select * from customer where area in ('DA','MU' OR 'PU');
update customer set area = 'UK' where cust_id='C004';
select * from customer where f_name like 'P%';
select f_name from customer where area like '_A%';
update customer set phone_no= '567889' where f_name= 'Rohan';
delete from customer where cust_id='C007';

create table category(
category_id varchar(5) primary key,
category_name varchar(30)
);
INSERT INTO category (category_id, category_name)
VALUES
('C001', 'Electronics'),
('C002', 'Clothing'),
('C003', 'Furniture'),
('C004', 'Grocery'),
('C005', 'Stationery'),
('C006', 'Footwear'),
('C007', 'Cosmetics');



create table product (
product_id varchar(5) primary key,
product_name varchar(50),
category_id varchar(5),
price decimal(8,2),
stock int,
foreign key (category_id) references category(category_id)
);
INSERT INTO product (product_id, product_name, category_id, price, stock)
VALUES
('P001', 'Wireless Mouse', 'C001', 599.00, 50),
('P002', 'Cotton Shirt', 'C002', 899.00, 30),
('P003', 'Study Table', 'C003', 4500.00, 10),
('P004', 'Basmati Rice', 'C004', 750.00, 100),
('P005', 'Notebook', 'C005', 80.00, 200),
('P006', 'Running Shoes', 'C006', 2499.00, 25),
('P007', 'Face Cream', 'C007', 450.00, 40);
select * from product where price > 150.0;
select * from product where price between 200 and 580;
select category_id, count(*) as total_product from product group by category_id;
select max(price) as max_price , min(price) as min_price from product;
select avg(price) from product;
SELECT p.*
FROM product AS p
JOIN category AS c
ON p.category_id = c.category_id
WHERE c.category_name IN ('Electronics', 'Clothing');
update product set price = 550000 where product_name='Notebook';
select * from product order by product_name asc;

create table orders(
order_id varchar(5) primary key,
cust_id varchar(5),
order_date date,
total_amount decimal(10,2),
foreign key (cust_id) references customer(cust_id)
);
INSERT INTO orders (order_id, cust_id, order_date, total_amount)
VALUES
('O001', 'C001', '2026-06-15', 4500.00),
('O002', 'C002', '2026-07-10', 3200.00),
('O003', 'C003', '2026-08-05', 7500.00),
('O004', 'C002', '2026-08-20', 5600.00),
('O005', 'C004', '2026-09-12', 9800.00),
('O006', 'C005', '2026-09-25', 2500.00),
('O007', 'C006', '2026-10-01', 6700.00);

select *
from orders as o 
join customer as c
on o.cust_id = c.cust_id where cust_id='C02';
select * from orders where cust_id='C002';
select count(*) from orders;
select * from orders where order_date < '2026-08-01';
select order_id,order_date from orders;
update orders set total_amount=12000 where  order_id='O005';

create table order_items(
order_item_id int auto_increment primary key,
order_id varchar(5),
product_id varchar(5),
quality int,
price decimal(8,2),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references product(product_id)
);
INSERT INTO order_items (order_id, product_id, quality, price)
VALUES
('O001', 'P001', 2, 599.00),
('O001', 'P002', 3, 899.00),
('O002', 'P001', 4, 599.00),
('O003', 'P003', 1, 4500.00),
('O004', 'P004', 5, 750.00),
('O005', 'P005', 6, 80.00),
('O006', 'P001', 2, 599.00);

select * from order_items;
select quality from order_items;
SELECT product_id, SUM(quality) AS total_quantity
FROM order_items
GROUP BY product_id
HAVING SUM(quality) > 3; 
SELECT order_id,
       SUM(quality * price) AS total_price
FROM order_items
GROUP BY order_id;

create table  invoice(
inv_no varchar(5) primary key,
order_id varchar(5),
inv_date date,
amount decimal(10,2),
foreign key (order_id) references orders(order_id)
);
INSERT INTO invoice (inv_no, order_id, inv_date, amount)
VALUES
('I001', 'O001', '2026-06-16', 4500.00),
('I002', 'O002', '2026-07-11', 3200.00),
('I003', 'O003', '2026-08-06', 7500.00),
('I004', 'O004', '2026-08-21', 5600.00),
('I005', 'O005', '2026-09-13', 9800.00),
('I006', 'O006', '2026-09-26', 2500.00),
('I007', 'O007', '2026-10-02', 6700.00);
select * from invoice;
select * from invoice where order_id='O003';
DELETE FROM invoice
WHERE inv_no = 'I002';
UPDATE invoice
SET inv_date = '2023-08-16'
WHERE inv_no = 'I007';


create table payment(
payment_id varchar(5) primary key,
inv_no varchar(5),
payment_date date,
payment_mode varchar(20),
payment_status varchar(15),
foreign key (inv_no) references invoice(inv_no)
);
INSERT INTO payment (payment_id, inv_no, payment_date, payment_mode, payment_status)
VALUES
('P001', 'I001', '2026-06-17', 'UPI', 'Paid'),
('P002', 'I002', '2026-07-12', 'Credit Card', 'Paid'),
('P003', 'I003', '2026-08-07', 'Debit Card', 'Paid'),
('P004', 'I004', '2026-08-22', 'Cash', 'Pending'),
('P005', 'I005', '2026-09-14', 'UPI', 'Paid'),
('P006', 'I006', '2026-09-27', 'Net Banking', 'Pending'),
('P007', 'I007', '2026-10-03', 'Credit Card', 'Paid');

select * from payment;
select * from payment where payment_status='Pending';
select count(*) from payment where payment_status='Paid';
select * from payment where payment_mode='UPI';
delete from payment where payment_id='P005'; 

select c.f_name, o.order_id from customer c join orders o on c.cust_id = o.cust_id;
SELECT c.f_name, p.product_name, od.quality
FROM customer c
JOIN orders o
ON c.cust_id = o.cust_id
JOIN order_items od
ON o.order_id = od.order_id
JOIN product p
ON od.product_id = p.product_id;

SELECT c.cust_name,
       SUM(od.quality * od.price) AS total_amount
FROM customer c
JOIN orders o
ON c.cust_id = o.cust_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY c.cust_id, c.cust_name;

