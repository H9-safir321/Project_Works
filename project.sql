-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Users\hasni\Downloads\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Books.csv'
delimiter ','
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\Users\hasni\Downloads\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Customers.csv'
delimiter ','
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\hasni\Downloads\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Orders.csv'
delimiter ','
CSV HEADER;

-- Verify Data
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--- basic----
---1
SELECT book_id, title, author, genre AS books_of_fiction
FROM Books
WHERE genre = 'Fiction';
---2
SELECT * FROM Books
WHERE published_year > 1950 order by published_year asc;
---3
SELECT * FROM Customers
WHERE country = 'Canada';
---4
SELECT * FROM Orders
WHERE order_date between '2023-11-01' and '2023-11-30';
---5
select sum(stock) as total_stocks from Books;
---6
select * from Books order by price desc limit 1;
---7
select * from orders where quantity >1;
---8
select * from orders where total_amount >20;
---9
select distinct genre from Books;
---10
select * from Books order by stock asc limit 1;
---11
select sum(total_amount) as total_revenue from orders ;

---advance---
--1
select b.genre , sum(o.quantity) as total_sold
from orders o join books b
on o.book_id = b.book_id
group by b.genre;
--2
select avg(price) as avg_price
from books where genre = 'Fantasy';
--3
select o.customer_id,c.name, count(o.order_id) as order_count
from orders o join customers c 
on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(order_id)>=2;
--4
select o.book_id,b.title, count(o.order_id) as ordr_cnt
from orders o join books b on b.book_id=o.book_id
group by o.book_id, b.title
order by ordr_cnt desc limit 1;
--5
select * from books
where genre = 'Fantasy'
order by price desc limit 3;
--6
select b.author, sum(o.quantity) as sold_qnt
from orders o join books b on b.book_id=o.book_id
group by b.author
order by sold_qnt desc;
--7
select distinct c.city, o.total_amount as paid_over_30$
from orders o join customers c on o.customer_id = c.customer_id
where o.total_amount>30;
--8
select c.name, sum(o.total_amount) as max_spent
from orders o join customers c on o.customer_id = c.customer_id
group by c.name
order by max_spent desc limit 1 ;
--9
select b.book_id,b.title,b.stock,
coalesce(sum(quantity),0)as order_qnty,b.stock-coalesce(sum(quantity),0)as remaining_qnty
from books b left join orders o on b.book_id=o.book_id
group by b.book_id;

