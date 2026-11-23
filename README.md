# Q-Commerce Business Intelligence Engine
### SQL-Based Business Analysis for Quick-Commerce Operations

**Tools:** MySQL 8.0+ · SQL · MySQL Workbench  
**Domain:** Quick Commerce · Retail Analytics · Business Intelligence  
**Dataset:** Original synthetic dataset generated using SQL

---

## 1. Project Overview

Quick-commerce businesses operate in a high-speed environment where profitability depends on much more than order volume.

A platform may generate strong revenue while facing problems such as:
- Products frequently going out of stock.
- High order volumes but weak product-level margins.
- Delivery delays across specific stores or locations.
- Promotions increasing order volume without improving profitability.
- Customer acquisition without sufficient repeat purchases.

The **Q-Commerce Business Intelligence Engine** is a SQL-based analytical project designed to examine these operational and commercial challenges.

The project simulates a quick-commerce business and uses relational data, business metrics, and analytical SQL queries to support better operational and management decisions.

It is designed around business scenarios relevant to companies such as Blinkit, Zepto, and Swiggy Instamart. It does not use their confidential or actual internal business data.

## 2. Business Problems Addressed

| Business area | Business question |
|---|---|
| Revenue and profitability | Which products, stores, and cities contribute to revenue and profit? |
| Inventory management | Which products have low stock or are out of stock? |
| Customer behaviour | Who are the most valuable and repeat customers? |
| Delivery operations | Which cities, stores, or riders have weaker delivery performance? |
| Promotion effectiveness | Are promotional orders generating meaningful revenue and profitability? |

The objective is to turn operational data into actionable business insights.

## 3. Database Architecture

The project uses eight interconnected relational tables.

| Table | Purpose |
|---|---|
| `stores` | Store information and location details |
| `products` | Product catalogue and pricing information |
| `customers` | Customer information |
| `orders` | Order-level transactions |
| `order_items` | Individual products within each order |
| `inventory` | Store-level product stock information |
| `deliveries` | Delivery performance information |
| `promotions` | Promotional campaign information |

### Entity Relationship Design

The database connects customers, stores, products, orders, inventory, deliveries, and promotions through primary and foreign keys.

The ER diagram is provided separately in Mermaid format in this repository.

### Simulated Dataset

The project generates its own data using SQL.

| Table | Target records |
|---|---:|
| Stores | 15 |
| Products | 150 |
| Customers | 2,000 |
| Promotions | 30 |
| Orders | 8,000 |
| Order Items | 20,000 |
| Inventory | 2,250 |
| Deliveries | 7,200 |

**Important:** These are synthetic records created for analytical practice. They represent a simulated business environment, not actual company transactions.

## 4. SQL Techniques Used

The project demonstrates practical SQL skills used in data analyst and business intelligence roles.

### Database design and data preparation
- Database and table creation.
- Primary key and foreign key relationships.
- Data types and constraints.
- `ALTER TABLE`.
- SQL-based synthetic data generation.

### Data quality checks
- Record count validation.
- Duplicate checks.
- Referential integrity checks.
- NULL value checks.

### Business analysis
- `SELECT`, `WHERE`, `ORDER BY`.
- Aggregate functions: `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`.
- `GROUP BY` and `HAVING`.
- Multi-table `INNER JOIN` and `LEFT JOIN`.
- Conditional logic using `CASE WHEN`.
- Subqueries and calculated metrics.

### Advanced SQL
- Common Table Expressions (CTEs).
- Window functions.
- `RANK()` for ranking stores.
- `LAG()` for month-over-month comparisons.
- Views for reusable business summaries.

## 5. Business Analysis Modules

### A. Revenue and Profitability Analysis

Examines:
- Product-level revenue and profitability.
- Revenue contribution across cities.
- Store-level business performance.
- Products with potentially weak margins.

**Business value:** Helps management distinguish between high sales volume and genuinely profitable business activity.

### B. Inventory Health and Replenishment

Examines:
- Products with low inventory.
- Out-of-stock products.
- Store-level inventory health.
- Replenishment priorities.

**Business value:** Helps operations teams identify stock risks and prioritize replenishment.

### C. Customer Behaviour Analysis

Examines:
- Customer distribution.
- Top customers.
- Repeat customer segmentation.
- Repeat customer percentage.

**Business value:** Helps identify valuable customer segments and understand customer retention patterns.

### D. Delivery Performance Analysis

Examines:
- Overall delivery performance.
- City-level performance.
- Rider-level performance.
- Store-level delivery performance.

**Business value:** Helps identify operational areas that may require delivery process improvements.

### E. Promotion Effectiveness

Examines:
- Revenue associated with promotional orders.
- Promotional order profitability.
- Average order value for promotional and non-promotional orders.

**Business value:** Helps evaluate whether discounts and campaigns are supporting commercially useful outcomes.

## 6. Key Analytical Outputs and Management Decisions

The SQL analysis is designed to support decisions such as:

| Analytical output | Possible management action |
|---|---|
| High-revenue, low-margin products | Review pricing, sourcing costs, or discount strategy |
| Low-stock products | Prioritize replenishment |
| Repeated stockout patterns in store-level data | Investigate inventory planning |
| Customers with repeat purchases | Develop retention strategies |
| Stores with weaker delivery performance | Review store-level fulfilment operations |
| Promotions with weak profitability | Reconsider discount structure |
| Cities with stronger profitability | Evaluate opportunities for operational expansion |

These are the types of decisions the project supports. Exact numerical findings should be added after validating the final query outputs.

## 7. Important Data Limitations

This project uses synthetic data and simplified operational assumptions.

- Inventory is a point-in-time snapshot, not a historical stock movement table. It cannot establish historical stockout duration or calculate actual lost sales.
- Delivery timestamps are simulated and should not be interpreted as real operational performance.
- Promotion results depend on the simulated campaign dates and order assignments.
- Business insights are illustrative and cannot be generalized to actual quick-commerce companies.

These limitations are important when interpreting the results.

## 8. Project Structure

```text
Q-Commerce-Business-Intelligence-Engine/
│
├── QCommerce_Business_Intelligence_Engine.sql
├── README.md
└── ER_Diagram/
    └── qcommerce_er_diagram.mmd
```

The SQL file contains the database setup, table creation, synthetic data generation, data validation, business analysis queries, advanced SQL analysis, and reusable views.

## 9. How to Run the Project

1. Install MySQL 8.0 or later.
2. Open MySQL Workbench.
3. Open `QCommerce_Business_Intelligence_Engine.sql`.
4. Review the database creation and table definitions.
5. Execute the script in the intended order.
6. Check the generated records using the validation queries.
7. Execute the business analysis queries.
8. Review the resulting tables and management insights.

**Note:** The script creates a database and tables. Before rerunning it, use a separate fresh database or carefully back up the existing one. Do not drop an existing database without confirming that you no longer need its data.

## 10. Skills Demonstrated

- Relational database design
- SQL data preparation
- Data validation
- Business analysis
- Revenue and profitability analysis
- Inventory analytics
- Customer segmentation
- Operational performance analysis
- Advanced SQL querying
- Translating business problems into analytical questions

## 11. Future Improvements

Possible extensions include:
- Historical inventory movement tracking.
- Actual lost-sales estimation using stockout and demand history.
- More detailed product and category profitability.
- Cohort-based customer retention analysis.
- Better promotion attribution.
- A Power BI dashboard connected to the SQL database.

## 12. Conclusion

The Q-Commerce Business Intelligence Engine demonstrates how SQL can be used beyond basic querying to examine business performance across multiple operational functions.

The central idea is simple:

**Revenue tells a business how much it sells. Business intelligence helps explain how well it operates and how much value it actually creates.**

This project is an independent portfolio project built using SQL and synthetic data.