-- Active: 1742151109658@@127.0.0.1@5432@postgres
-- create database bookstore_db
CREATE DATABASE bookstore_db;

-- create 'books' table   
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price >= 0) NOT NULL,
    stock INT CHECK (stock >= 0) NOT NULL,
    published_year INT CHECK (published_year > 0) NOT NULL
);

-- insert into books table
INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);




-- create "customers" table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- insert into customers table
INSERT INTO customers (name, email, joined_date) VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', '2023-06-20');



-- create 'orders' table 
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    quantity INT CHECK (quantity > 0) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- insert into orders table
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 2, 1, '2024-03-10'),
(2, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');


-- show all data use this 
select * from books;
select * from customers;    
select * from orders;



-- 1️⃣ Find books that are out of stock
SELECT title FROM books WHERE stock = 0;


-- 2️⃣ Retrieve the most expensive book in the store.
SELECT * FROM books where price=(select MAX(price) from books);

-- 3️⃣ Find the total number of orders placed by each customer.


SELECT name, COUNT(*) AS orders_count
    FROM customers 
        JOIN orders  ON orders.customer_id = customers.id
            GROUP BY customers.id 
            ORDER BY orders_count DESC;

-- 4️⃣ Calculate the total revenue generated from book sales.
SELECT SUM(price * quantity) AS total_revenue
    FROM books 
        JOIN orders ON orders.book_id = books.id;



-- 5️⃣ List all customers who have placed more than one order.
SELECT name, COUNT(*) AS orders_count FROM customers 
    JOIN orders  ON orders.customer_id = customers.id
        GROUP BY customers.id
            HAVING COUNT(*) >1;

-- 6️⃣ Find the average price of books in the store.
SELECT ROUND(AVG(price),2) AS avg_book_price FROM books;

-- 7️⃣ Increase the price of all books published before 2000 by 10%.
UPDATE books SET price = price * 1.1 WHERE published_year < 2000;


-- 8️⃣ Delete customers who haven't placed any orders.
DELETE FROM customers 
    WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);



