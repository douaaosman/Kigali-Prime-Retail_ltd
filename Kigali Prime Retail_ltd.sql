-- 1. Branches Table
CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- 2. Employees Table (includes self-referencing manager_id)
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    branch_id INT,
    manager_id INT,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL
);

-- 3. Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE NOT NULL
);

-- 4. Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL
);

-- 5. Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    emp_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Completed'
);

-- 6. Order Items Table
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    sold_price NUMERIC(10, 2) NOT NULL
);

-- Foreign Key & Check Constraints
ALTER TABLE employees
    ADD CONSTRAINT fk_emp_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id) REFERENCES employees(emp_id) ON DELETE SET NULL;

ALTER TABLE orders
    ADD CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_order_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE SET NULL,
    ADD CONSTRAINT chk_order_status CHECK (status IN ('Completed', 'Pending', 'Cancelled'));

ALTER TABLE order_items
    ADD CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    ADD CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    ADD CONSTRAINT chk_price_positive CHECK (sold_price >= 0);

ALTER TABLE products
    ADD CONSTRAINT chk_unit_price CHECK (unit_price > 0);

-- Insert Branches (Branch 5 has no employees/orders yet to demonstrate OUTER JOINs)
INSERT INTO branches (branch_name, region, city) VALUES
('Kigali HQ Store', 'Kigali', 'Kigali'),
('Musanze Hub', 'Northern', 'Musanze'),
('Huye Center', 'Southern', 'Huye'),
('Rwamagana Outlet', 'Eastern', 'Rwamagana'),
('Rubavu Upcoming Branch', 'Western', 'Rubavu');

-- Insert Employees (Emp 1 & 2 are managers; Emp 6 has no branch assigned yet)
INSERT INTO employees (branch_id, manager_id, full_name, role, hire_date) VALUES
(1, NULL, 'Jean Paul Habimana', 'Regional Manager', '2023-01-15'),
(2, NULL, 'Claire Uwase', 'Regional Manager', '2023-03-10'),
(1, 1, 'Eric Niyonzima', 'Senior Sales Rep', '2024-02-01'),
(2, 2, 'Alice Mukamana', 'Sales Rep', '2024-04-12'),
(3, 1, 'David Mugisha', 'Sales Rep', '2024-05-20'),
(4, 2, 'Grace Ingabire', 'Sales Rep', '2024-06-01'),
(NULL, 1, 'Patrick Kayitare', 'Trainee Rep', '2026-10-01');

-- Insert Customers (Customer 8 has never placed an order to demonstrate LEFT JOIN)
INSERT INTO customers (full_name, region, email, join_date) VALUES
('Rwanda Tech Solutions', 'Kigali', 'procurement@rwandatech.rw', '2025-01-10'),
('Volcanoes Eco Lodge', 'Northern', 'orders@volcanoeslodge.rw', '2025-02-14'),
('Southern University Press', 'Southern', 'supply@supress.rw', '2025-03-05'),
('Akagera Agro Ltd', 'Eastern', 'finance@akageraagro.rw', '2025-04-18'),
('Kigali City Clinic', 'Kigali', 'admin@kigaliclinic.rw', '2025-05-22'),
('Northern Star Academy', 'Northern', 'bursar@northernstar.rw', '2025-06-30'),
('Huye Coffee Exporters', 'Southern', 'ops@huyecoffee.rw', '2025-07-11'),
('Nyungwe Safari Camp', 'Western', 'info@nyungwecamp.rw', '2026-09-01');

-- Insert Products (Product 8 has never been ordered to demonstrate RIGHT JOIN)
INSERT INTO products (product_name, category, unit_price) VALUES
('ProBook Laptop 15"', 'Electronics', 850.00),
('LaserJet Enterprise Printer', 'Office Supplies', 420.00),
('Ergonomic Mesh Chair', 'Furniture', 180.00),
('4K Conference Monitor', 'Electronics', 350.00),
('Solar Backup Inverter 3kW', 'Appliances', 600.00),
('Heavy Duty Paper Shredder', 'Office Supplies', 150.00),
('Executive Wooden Desk', 'Furniture', 320.00),
('Smart Biometric Safe', 'Security', 500.00);

-- Insert Orders across multiple months (Jan 2026 - Aug 2026)
INSERT INTO orders (customer_id, emp_id, order_date, status) VALUES
(1, 3, '2026-01-15', 'Completed'),
(2, 4, '2026-01-22', 'Completed'),
(3, 5, '2026-02-10', 'Completed'),
(1, 3, '2026-02-25', 'Completed'),
(4, 6, '2026-03-14', 'Completed'),
(5, 3, '2026-03-28', 'Completed'),
(2, 4, '2026-04-09', 'Completed'),
(6, 4, '2026-04-19', 'Completed'),
(7, 5, '2026-05-05', 'Completed'),
(1, 3, '2026-05-21', 'Completed'),
(3, 5, '2026-06-12', 'Completed'),
(5, 3, '2026-06-27', 'Completed'),
(4, 6, '2026-07-08', 'Completed'),
(6, 4, '2026-07-19', 'Completed'),
(2, 4, '2026-08-03', 'Completed'),
(7, 5, '2026-08-18', 'Pending');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, sold_price) VALUES
(1, 1, 3, 850.00), (1, 3, 5, 180.00),
(2, 5, 2, 600.00), (2, 2, 1, 420.00),
(3, 2, 4, 420.00), (3, 6, 3, 150.00),
(4, 4, 4, 350.00), (4, 1, 2, 850.00),
(5, 5, 3, 600.00), (5, 7, 2, 320.00),
(6, 1, 4, 850.00), (6, 4, 2, 350.00),
(7, 3, 6, 180.00), (7, 7, 3, 320.00),
(8, 2, 3, 420.00), (8, 6, 4, 150.00),
(9, 5, 2, 600.00), (9, 3, 4, 180.00),
(10, 1, 5, 850.00), (10, 2, 2, 420.00),
(11, 4, 3, 350.00), (11, 7, 2, 320.00),
(12, 5, 4, 600.00), (12, 6, 5, 150.00),
(13, 1, 2, 850.00), (13, 3, 4, 180.00),
(14, 4, 5, 350.00), (14, 2, 2, 420.00),
(15, 5, 3, 600.00), (15, 1, 2, 850.00),
(16, 7, 3, 320.00), (16, 6, 2, 150.00);

-- INNER JOIN: Retrieve all completed orders with customer, sales rep, branch, and total order value
SELECT 
    o.order_id,
    o.order_date,
    c.full_name AS customer_name,
    b.region,
    b.branch_name,
    e.full_name AS sales_rep,
    SUM(oi.quantity * oi.sold_price) AS order_total
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN employees e ON o.emp_id = e.emp_id
INNER JOIN branches b ON e.branch_id = b.branch_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.order_id, o.order_date, c.full_name, b.region, b.branch_name, e.full_name
ORDER BY o.order_date;

-- LEFT JOIN: Identify registered customers who have never placed an order
SELECT 
    c.customer_id,
    c.full_name AS customer_name,
    c.region,
    c.join_date,
    o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- RIGHT JOIN: Identify catalog products that have never been sold in any order
SELECT 
    oi.order_id,
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM order_items oi
RIGHT JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id IS NULL;

-- FULL OUTER JOIN: Audit all branches and all employees, including unassigned staff and empty branches
SELECT 
    b.branch_id,
    b.branch_name,
    b.region,
    e.emp_id,
    e.full_name AS employee_name,
    e.role
FROM branches b
FULL OUTER JOIN employees e ON b.branch_id = e.branch_id
ORDER BY b.branch_id NULLS LAST;

-- SELF JOIN: Compare employees with their direct reporting managers and compare customers in the same region
SELECT 
    e.emp_id,
    e.full_name AS employee_name,
    e.role AS employee_role,
    COALESCE(m.full_name, 'Executive Board (Top Level)') AS manager_name,
    m.role AS manager_role
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY manager_name, e.emp_id;

-- A. RANKING FUNCTIONS: ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK()
-- Practical Application: Rank products by revenue within each region & identify Top 3 customers per region

WITH regional_product_sales AS (
    SELECT 
        b.region,
        p.product_name,
        SUM(oi.quantity * oi.sold_price) AS total_revenue
    FROM order_items oi
    INNER JOIN orders o ON oi.order_id = o.order_id
    INNER JOIN employees e ON o.emp_id = e.emp_id
    INNER JOIN branches b ON e.branch_id = b.branch_id
    INNER JOIN products p ON oi.product_id = p.product_id
    GROUP BY b.region, p.product_name
)
SELECT 
    region,
    product_name,
    total_revenue,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS row_num,
    RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS sales_rank,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS dense_sales_rank,
    ROUND((PERCENT_RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC))::NUMERIC, 2) AS pct_rank
FROM regional_product_sales
ORDER BY region, sales_rank;

-- Top 3 Customers per Region using DENSE_RANK()
WITH customer_spending AS (
    SELECT 
        c.region,
        c.full_name AS customer_name,
        SUM(oi.quantity * oi.sold_price) AS total_spent
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.region, c.full_name
),
ranked_customers AS (
    SELECT 
        region,
        customer_name,
        total_spent,
        DENSE_RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS region_rank
    FROM customer_spending
)
SELECT * FROM ranked_customers WHERE region_rank <= 3;

-- B. AGGREGATE WINDOW FUNCTIONS: SUM(), AVG(), MIN(), MAX(), COUNT() OVER()
-- Demonstrates PARTITION BY, ORDER BY, ROWS BETWEEN, and RANGE BETWEEN

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
        SUM(oi.quantity * oi.sold_price) AS monthly_revenue,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT 
    sales_month,
    monthly_revenue,
    -- Cumulative running total using RANGE BETWEEN
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month 
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue_range,
    -- 3-Month Moving Average using ROWS BETWEEN
    ROUND(AVG(monthly_revenue) OVER (
        ORDER BY sales_month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS three_month_moving_avg,
    -- Overall Period Benchmarks
    MIN(monthly_revenue) OVER () AS lowest_month_rev,
    MAX(monthly_revenue) OVER () AS highest_month_rev,
    SUM(order_count) OVER () AS total_period_orders
FROM monthly_sales
ORDER BY sales_month;

-- C. NAVIGATION FUNCTIONS: LAG() and LEAD()
-- Practical Application: Month-over-Month (MoM) revenue comparison and next-month preview

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', o.order_date)::DATE AS sales_month,
        SUM(oi.quantity * oi.sold_price) AS monthly_revenue
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT 
    sales_month,
    monthly_revenue,
    LAG(monthly_revenue, 1) OVER (ORDER BY sales_month) AS prev_month_revenue,
    LEAD(monthly_revenue, 1) OVER (ORDER BY sales_month) AS next_month_revenue,
    monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY sales_month) AS mom_variance,
    ROUND(
        ((monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY sales_month)) 
        / NULLIF(LAG(monthly_revenue, 1) OVER (ORDER BY sales_month), 0)) * 100, 2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY sales_month;

-- D. DISTRIBUTION FUNCTIONS: NTILE(4) and CUME_DIST()
-- Practical Application: Segment customers into 4 spending quartiles and calculate cumulative distribution

WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.full_name AS customer_name,
        c.region,
        SUM(oi.quantity * oi.sold_price) AS total_spent
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.full_name, c.region
)
SELECT 
    customer_id,
    customer_name,
    region,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile,
    CASE NTILE(4) OVER (ORDER BY total_spent DESC)
        WHEN 1 THEN 'Tier 1: Platinum'
        WHEN 2 THEN 'Tier 2: Gold'
        WHEN 3 THEN 'Tier 3: Silver'
        WHEN 4 THEN 'Tier 4: Bronze'
    END AS loyalty_segment,
    ROUND((CUME_DIST() OVER (ORDER BY total_spent ASC))::NUMERIC, 2) AS cumulative_dist
FROM customer_totals
ORDER BY total_spent DESC;

