CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    region VARCHAR(50),
    join_date DATE);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2));    
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    sale_date DATE,
    payment_method VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)); 

LOAD DATA INFILE '"C:\Users\akhil\OneDrive\Desktop\akhil anand\sql project\customers.csv"'
INTO TABLE customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Total counts in each table
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_sales FROM sales;

-- Data preview
SELECT * FROM customers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM sales LIMIT 5;

-- Missing values check
SELECT COUNT(*) - COUNT(customer_name) AS missing_customer_names FROM customers;
SELECT COUNT(*) - COUNT(product_name) AS missing_product_names FROM products;
SELECT * FROM sales WHERE sale_id IS NULL OR customer_id IS NULL OR product_id IS NULL OR quantity IS NULL OR sale_date IS NULL OR payment_method IS NULL;


-- Duplicates
SELECT customer_id, COUNT(*) FROM customers GROUP BY customer_id HAVING COUNT(*) > 1;
SELECT product_id, COUNT(*) FROM products GROUP BY product_id HAVING COUNT(*) > 1;
SELECT sale_id, COUNT(*) FROM sales GROUP BY sale_id HAVING COUNT(*) >1;

-- Total revenue
SELECT SUM(s.quantity * p.price) AS total_revenue
FROM sales s JOIN products p ON s.product_id = p.product_id;

-- Average order value
SELECT AVG(s.quantity * p.price) AS avg_order_value
FROM sales s JOIN products p ON s.product_id = p.product_id;
-- Regional Distribution

SELECT c.region, COUNT(DISTINCT c.customer_id) AS total_customers,
       SUM(s.quantity * p.price) AS total_sales_value
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
GROUP BY c.region
ORDER BY total_sales_value DESC;

-- Product Category Performance
SELECT p.category, COUNT(s.sale_id) AS total_orders,
       SUM(s.quantity * p.price) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Time Trends
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
       SUM(s.quantity * p.price) AS monthly_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Payment Method Insights

SELECT payment_method,
       COUNT(*) AS total_transactions,
       SUM(s.quantity * p.price) AS total_value
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY payment_method
ORDER BY total_value DESC;








