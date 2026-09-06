CREATE DATABASE Learnerdetails;
USE Learnerdetails;
/*Tasks
1. Create the database and schema. Populate the Schema:
●	Create a Database for this project and
●	Create all three tables in MySQL with appropriate data types and relationships.
●	Insert sample data covering at least:
○	4–5 learners
○	4–5 courses (spread across multiple categories)
○	6–8 purchase records*/

CREATE TABLE learners(learner_id INT PRIMARY KEY,full_name VARCHAR(50),Country VARCHAR(50));
INSERT INTO learners (learner_id, full_name, Country)
VALUES
(1, 'Arun Kumar', 'India'),
(2, 'Priya Sharma', 'India'),
(3, 'Rahul Singh', 'Singapore'),
(4, 'Divya Menon', 'UAE'),
(5, 'John Smith', 'USA'); 

CREATE TABLE courses(course_id INT PRIMARY KEY,course_name VARCHAR(50),category VARCHAR(50),unit_price DECIMAL(10,2));
INSERT INTO courses (course_id, course_name, category, unit_price)
VALUES
(101, 'SQL', 'Database', 2500.00),
(102, 'Python', 'Programming', 3500.00),
(103, 'Power BI', 'Data Visualization', 3000.00),
(104, 'Excel', 'Productivity', 2000.00),
(105, 'MachineLearning', 'AI & ML', 5000.00);

CREATE TABLE purchases (purchase_id INT PRIMARY KEY,learner_id INT,course_id INT,Quantity INT,purchase_date DATE,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id));
INSERT INTO purchases 
(purchase_id, learner_id, course_id, Quantity, purchase_date)
VALUES
(1001, 1, 101, 1, '2026-08-01'),
(1002, 2, 102, 1, '2026-08-03'),
(1003, 3, 103, 2, '2026-08-05'),
(1004, 1, 104, 1, '2026-08-07'),
(1005, 4, 105, 1, '2026-08-10'),
(1006, 5, 101, 2, '2026-08-12'),
(1007, 2, 103, 1, '2026-08-15'),
(1008, 3, 105, 1, '2026-08-18');    

SELECT * FROM learners;
SELECT * FROM courses;
SELECT * FROM purchases;

/*2. Data Exploration Using Joins
   Data Presentation Guidelines for the following query 
●	Format currency values to 2 decimal places.
●	Use aliases for column names (e.g., AS total_revenue).
●	Sort results appropriately (e.g., highest total_spent first).
Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to:
●	Combine learner, course, and purchase data.
●	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).*/


SELECT l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(p.Quantity * c.unit_price,2) AS Total_revenue,
p.purchase_date
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
ORDER BY Total_revenue DESC;

SELECT l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(p.Quantity * c.unit_price,2) AS Total_revenue,
p.purchase_date
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY Total_revenue DESC;

SELECT l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(p.Quantity * c.unit_price,2) AS Total_revenue,
p.purchase_date
FROM learners l
RIGHT JOIN purchases p
    ON l.learner_id = p.learner_id
RIGHT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY Total_revenue DESC;


/*3. Analytical Queries
		Write SQL queries to answer the following questions:
Q1. Display each learner’s total spending (quantity × unit_price) along with their country.*/
SELECT
    l.learner_id,
    l.full_name,
    l.Country,
    FORMAT(SUM(p.Quantity * c.unit_price), 2) AS total_spending
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.Country
ORDER BY total_spending DESC;

##3Q2. Find the top 3 most purchased courses based on total quantity sold.
SELECT
    c.course_id AS course_id,
    c.course_name AS course_name,
    SUM(p.Quantity) AS total_quantity_sold
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

##*Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.

    SELECT
    c.category,
    FORMAT(SUM(p.Quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

##Q4. List all learners who have purchased courses from more than one category.
SELECT
    l.learner_id,
    l.full_name,
    COUNT(DISTINCT c.category) AS category_count
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name
HAVING category_count > 1;

##Q5. Identify courses that have not been purchased at all.
SELECT
    c.course_id,
    c.course_name,
    c.category
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;
