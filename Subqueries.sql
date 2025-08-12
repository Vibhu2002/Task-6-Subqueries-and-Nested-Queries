-- Create tables
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT
);

CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT,
    dept_id INTEGER,
    salary INTEGER,
    hire_date DATE,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

-- Insert data
INSERT INTO departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO employees VALUES
(101, 'Alice', 1, 50000, '2020-01-10'),
(102, 'Bob', 2, 70000, '2019-03-15'),
(103, 'Charlie', 2, 65000, '2021-07-22'),
(104, 'David', 3, 55000, '2022-06-01'),
(105, 'Eva', 1, 60000, '2023-01-12');



1. Subquery in SELECT (Scalar Subquery)
sql

-- Show each employee with the company average salary
SELECT 
    emp_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees;


2. Subquery in WHERE (IN)


-- Employees working in departments with 'IT' or 'Finance'
SELECT emp_name, salary
FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments
    WHERE dept_name IN ('IT', 'Finance')
);

3. Subquery in WHERE (EXISTS)


-- Employees who have salary above the average of their department
SELECT e.emp_name, e.salary, e.dept_id
FROM employees e
WHERE EXISTS (
    SELECT 1 
    FROM employees e2
    WHERE e2.dept_id = e.dept_id 
    AND e.salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id)
);



4. Correlated Subquery


-- For each employee, show how much more they earn than the department average
SELECT 
    emp_name,
    salary,
    salary - (
        SELECT AVG(salary) 
        FROM employees e2
        WHERE e2.dept_id = e1.dept_id
    ) AS diff_from_dept_avg
FROM employees e1;

5. Subquery in FROM (Derived Table)

-- Show department-wise average salary, then filter those above 60,000
SELECT dept_name, avg_salary
FROM (
    SELECT d.dept_name, AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
) AS dept_avg
WHERE avg_salary > 60000;
