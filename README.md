# Kigali Prime Retail Ltd. — SQL JOINs & Window Functions Analytics Project

## 1. Project Title
**Regional Retail Sales Performance & Customer Segmentation Analysis Using PostgreSQL**

## 2. Group Members
| # | Full Name | Student ID |
| :--- | :--- | :--- | :--- |
| 1 | ZEINAB SHAKER MOHAMED | 202511094 | 
| 2 | MURAM MAGDI HUSSAIN | 202512031 |
| 3 | LENA ABDELRAHMAN MAHMOUD | 202510416 |
| 4 | MALAZ NAJI BALAL | 202510547 |
| 5 | DOUAA ABDULRHMAN | 202511431 | 

## 3. Business Background
Kigali Prime Retail Ltd. operates regional retail branches across Kigali, Northern, Southern, Eastern, and Western provinces in Rwanda, supplying electronics, office equipment, and solar appliances to institutional and individual buyers.

## 4. Problem Statement
Without structured relational analytics, management cannot accurately rank regional product demand, track cumulative revenue growth, evaluate month-over-month sales volatility, or identify inactive customers and unstaffed branches.

## 5. Project Objectives
1. Rank top-performing products per region using `RANK()` and `DENSE_RANK()`.
2. Track cumulative year-to-date sales using `SUM() OVER()` with `RANGE` frames.
3. Measure month-over-month revenue changes using `LAG()` and `LEAD()`.
4. Segment customers into four spending quartiles using `NTILE(4)` and `CUME_DIST()`.
5. Smooth revenue trends with a 3-month moving average using `AVG() OVER()` and `ROWS` frames.

## 6. Database Schema & Table Descriptions
* `branches`: Stores regional store locations (`branch_id`, `branch_name`, `region`, `city`).
* `employees`: Stores staff details and self-referencing management hierarchy (`emp_id`, `branch_id`, `manager_id`, `full_name`, `role`, `hire_date`).
* `customers`: Stores client profiles and registration dates (`customer_id`, `full_name`, `region`, `email`, `join_date`).
* `products`: Stores product catalog and unit pricing (`product_id`, `product_name`, `category`, `unit_price`).
* `orders`: Stores transaction headers (`order_id`, `customer_id`, `emp_id`, `order_date`, `status`).
* `order_items`: Stores line-item quantities and historical prices (`item_id`, `order_id`, `product_id`, `quantity`, `sold_price`).

## 7. Entity-Relationship Diagram (ERD)
![ERD](documentation/ERD.png)

## 8. SQL Implementations Overview
* **Part A — SQL JOINs (`queries/01_inner_join.sql` to `05_self_join.sql`):** Demonstrates `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`, and `SELF JOIN` to analyze completed orders, inactive customers, unsold inventory, unassigned staff, and management hierarchy.
* **Part B — Window Functions (`queries/06_ranking_functions.sql` to `09_distribution_functions.sql`):** Implements Ranking (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `PERCENT_RANK`), Aggregate (`SUM`, `AVG`, `MIN`, `MAX`, `COUNT` with `ROWS` and `RANGE` frames), Navigation (`LAG`, `LEAD`), and Distribution (`NTILE(4)`, `CUME_DIST`) functions.

## 9. Key Analytical Findings
* **Descriptive:** Total cumulative revenue reached $32,370 across 16 orders, led by Kigali HQ Store, *ProBook Laptop 15"*, and *Solar Backup Inverter 3kW*.
* **Diagnostic:** Bulk B2B orders drove revenue spikes in March and May, while lack of local staffing in the Western region left *Rubavu Upcoming Branch* and *Nyungwe Safari Camp* inactive.
* **Prescriptive:** Reallocate Trainee Rep *Patrick Kayitare* to Rubavu, optimize regional warehouse stock based on product rankings, and enroll Quartile 1 (`NTILE(4) = 1`) customers into a VIP retention program.

## 10. Instructions for Executing the SQL Scripts
1. Open **pgAdmin 4** and create a new database named `ulk_retail_analytics`.
2. Execute `database/01_create_tables.sql` to create the six relational tables.
3. Execute `database/03_constraints.sql` to apply primary keys, foreign keys, and check constraints.
4. Execute `database/02_insert_data.sql` to populate the database with sample records.
5. Run scripts `queries/01_inner_join.sql` through `queries/09_distribution_functions.sql` sequentially to view the analytical results.

## 11. References
* PostgreSQL Global Development Group. (2026). *PostgreSQL 16 Documentation: Window Functions*. https://www.postgresql.org/docs/current/tutorial-window.html
* Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). *Database System Concepts* (7th ed.). McGraw-Hill.

## 12. Academic Integrity Statement
All sources were properly cited. The SQL implementations and analysis represent the group's original work. No AI-generated content was copied and presented as original work.
