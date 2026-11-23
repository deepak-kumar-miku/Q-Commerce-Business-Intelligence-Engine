CREATE DATABASE qcommerce_bi_engine;

USE qcommerce_bi_engine;

SELECT DATABASE();

CREATE TABLE stores (

    store_id INT PRIMARY KEY,

    store_name VARCHAR(100) NOT NULL,

    city VARCHAR(50) NOT NULL,

    area VARCHAR(100) NOT NULL,

    opening_date DATE,

    store_status VARCHAR(20) DEFAULT 'Active'

);

DESCRIBE stores;

SHOW TABLES;

CREATE TABLE products (

    product_id INT PRIMARY KEY,

    product_name VARCHAR(100) NOT NULL,

    category VARCHAR(50) NOT NULL,

    brand VARCHAR(50),

    selling_price DECIMAL(10,2) NOT NULL,

    unit_cost DECIMAL(10,2) NOT NULL,

    product_status VARCHAR(20) DEFAULT 'Active'

);

DESCRIBE products;

SHOW TABLES;

CREATE TABLE customers (

    customer_id INT PRIMARY KEY,

    customer_name VARCHAR(100) NOT NULL,

    city VARCHAR(50) NOT NULL,

    area VARCHAR(100),

    registration_date DATE NOT NULL,

    customer_status VARCHAR(20) DEFAULT 'Active'

);

DESCRIBE customers;

SHOW TABLES;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    store_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
);

DESCRIBE orders;

SHOW TABLES;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

DESCRIBE order_items;

SHOW TABLES;

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    stock_quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    last_updated DATETIME,

    FOREIGN KEY (store_id)
        REFERENCES stores(store_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

DESCRIBE inventory;

SHOW TABLES;

CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    rider_id INT,
    assigned_at DATETIME,
    picked_up_at DATETIME,
    delivered_at DATETIME,
    delivery_status VARCHAR(30) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

DESCRIBE deliveries;

SHOW TABLES;

CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY,
    promotion_name VARCHAR(100) NOT NULL,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    promotion_status VARCHAR(20) DEFAULT 'Active'
);

DESCRIBE promotions;

SHOW TABLES;

ALTER TABLE orders
ADD COLUMN promotion_id INT NULL,
ADD CONSTRAINT fk_orders_promotions
FOREIGN KEY (promotion_id)
REFERENCES promotions(promotion_id);

DESCRIBE orders;



INSERT INTO stores
(store_id, store_name, city, area, opening_date, store_status)
VALUES
(1, 'QuickKart Koramangala', 'Bengaluru', 'Koramangala', '2024-01-15', 'Active'),
(2, 'QuickKart HSR', 'Bengaluru', 'HSR Layout', '2024-03-10', 'Active'),
(3, 'QuickKart Whitefield', 'Bengaluru', 'Whitefield', '2024-06-20', 'Active'),

(4, 'QuickKart Gachibowli', 'Hyderabad', 'Gachibowli', '2024-02-12', 'Active'),
(5, 'QuickKart Madhapur', 'Hyderabad', 'Madhapur', '2024-04-18', 'Active'),
(6, 'QuickKart Kukatpally', 'Hyderabad', 'Kukatpally', '2024-07-05', 'Active'),

(7, 'QuickKart Andheri', 'Mumbai', 'Andheri', '2024-01-25', 'Active'),
(8, 'QuickKart Powai', 'Mumbai', 'Powai', '2024-05-14', 'Active'),
(9, 'QuickKart Thane', 'Mumbai', 'Thane', '2024-08-01', 'Active'),

(10, 'QuickKart Rohini', 'Delhi', 'Rohini', '2024-02-20', 'Active'),
(11, 'QuickKart Dwarka', 'Delhi', 'Dwarka', '2024-04-25', 'Active'),
(12, 'QuickKart Saket', 'Delhi', 'Saket', '2024-09-10', 'Active'),

(13, 'QuickKart Hinjewadi', 'Pune', 'Hinjewadi', '2024-03-15', 'Active'),
(14, 'QuickKart Wakad', 'Pune', 'Wakad', '2024-06-01', 'Active'),
(15, 'QuickKart Kothrud', 'Pune', 'Kothrud', '2024-10-05', 'Active');

SELECT * FROM stores;

SELECT COUNT(*) AS total_stores
FROM stores;

SELECT
    city,
    COUNT(*) AS total_stores
FROM stores
GROUP BY city
ORDER BY total_stores DESC;

CREATE TABLE numbers (
    n INT PRIMARY KEY
);

INSERT INTO numbers (n)
WITH RECURSIVE number_generator AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM number_generator
    WHERE n < 150
)
SELECT n FROM number_generator;

INSERT INTO products
(product_id, product_name, category, brand,
 selling_price, unit_cost, product_status)

SELECT
    n,
    CONCAT('Product ', n),

    CASE
        WHEN n <= 25 THEN 'Dairy'
        WHEN n <= 50 THEN 'Snacks'
        WHEN n <= 75 THEN 'Beverages'
        WHEN n <= 100 THEN 'Fruits & Vegetables'
        WHEN n <= 125 THEN 'Personal Care'
        ELSE 'Household'
    END,

    CASE
        WHEN n % 3 = 0 THEN 'Brand A'
        WHEN n % 3 = 1 THEN 'Brand B'
        ELSE 'Brand C'
    END,

    ROUND(20 + (n % 30) * 5 + (n % 7) * 2, 2),

    ROUND(12 + (n % 25) * 3 + (n % 5), 2),

    'Active'

FROM numbers
WHERE n BETWEEN 1 AND 150;

SELECT COUNT(*) AS total_products
FROM products;

SELECT
    category,
    COUNT(*) AS total_products,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(unit_cost), 2) AS avg_unit_cost
FROM products
GROUP BY category;

INSERT INTO customers
(customer_id, customer_name, city, area,
 registration_date, customer_status)

SELECT
    customer_id,
    CONCAT('Customer ', customer_id),

    CASE
        WHEN customer_id % 5 = 1 THEN 'Bengaluru'
        WHEN customer_id % 5 = 2 THEN 'Hyderabad'
        WHEN customer_id % 5 = 3 THEN 'Mumbai'
        WHEN customer_id % 5 = 4 THEN 'Delhi'
        ELSE 'Pune'
    END,

    CONCAT('Area ', (customer_id % 3) + 1),

    DATE_ADD(
        '2024-01-01',
        INTERVAL (customer_id % 900) DAY
    ),

    CASE
        WHEN customer_id % 20 = 0 THEN 'Inactive'
        ELSE 'Active'
    END

FROM (
    SELECT
        ((a.n - 1) * 150 + b.n) AS customer_id
    FROM numbers a
    CROSS JOIN numbers b
    WHERE ((a.n - 1) * 150 + b.n) <= 2000
) AS generated_customers;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT
    city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

SELECT
    customer_status,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_status;

INSERT INTO promotions
(promotion_id, promotion_name, discount_type,
 discount_value, start_date, end_date, promotion_status)

SELECT
    n,
    CONCAT('Campaign ', n),

    CASE
        WHEN n % 2 = 0 THEN 'Percentage'
        ELSE 'Fixed'
    END,

    CASE
        WHEN n % 2 = 0 THEN 10 + (n % 4) * 5
        ELSE 20 + (n % 5) * 10
    END,

    DATE_ADD('2025-01-01', INTERVAL (n * 10) DAY),

    DATE_ADD('2025-01-01', INTERVAL (n * 10 + 20) DAY),

    CASE
        WHEN n % 4 = 0 THEN 'Inactive'
        ELSE 'Active'
    END

FROM numbers
WHERE n BETWEEN 1 AND 30;

SELECT COUNT(*) AS total_promotions
FROM promotions;

SELECT
    discount_type,
    COUNT(*) AS total_campaigns,
    ROUND(AVG(discount_value), 2) AS average_discount
FROM promotions
GROUP BY discount_type;

INSERT INTO orders
(order_id, customer_id, store_id, order_date,
 order_status, payment_method, promotion_id)

SELECT
    10000 + seq,
    ((seq - 1) % 2000) + 1,
    ((seq - 1) % 15) + 1,

    DATE_ADD(
        '2025-01-01 08:00:00',
        INTERVAL (seq % 330) DAY
    ) + INTERVAL (seq % 600) MINUTE,

    CASE
        WHEN seq % 20 = 0 THEN 'Cancelled'
        WHEN seq % 20 = 1 THEN 'Returned'
        ELSE 'Delivered'
    END,

    CASE
        WHEN seq % 3 = 0 THEN 'UPI'
        WHEN seq % 3 = 1 THEN 'Card'
        ELSE 'Cash'
    END,

    CASE
        WHEN seq % 4 = 0 THEN NULL
        ELSE ((seq - 1) % 30) + 1
    END

FROM (
    SELECT
        ((a.n - 1) * 150 + b.n) AS seq
    FROM numbers a
    CROSS JOIN numbers b
    WHERE ((a.n - 1) * 150 + b.n) <= 8000
) AS generated_orders;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

SELECT
    payment_method,
    COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method;

INSERT INTO order_items
(order_item_id, order_id, product_id, quantity,
 unit_price, discount_amount)

SELECT
    ((o.order_id - 10000) * 3) + n.n,

    o.order_id,

    MOD(o.order_id + n.n * 7, 150) + 1,

    MOD(o.order_id + n.n, 4) + 1,

    p.selling_price,

    CASE
        WHEN promo.promotion_id IS NULL THEN 0

        WHEN promo.discount_type = 'Percentage'
            THEN ROUND(
                p.selling_price
                * (MOD(o.order_id + n.n, 4) + 1)
                * promo.discount_value / 100,
                2
            )

        ELSE ROUND(
            LEAST(
                p.selling_price * (MOD(o.order_id + n.n, 4) + 1),
                promo.discount_value / (2 + MOD(o.order_id, 2))
            ),
            2
        )
    END

FROM orders o

JOIN numbers n
    ON n.n <= 2 + MOD(o.order_id, 2)

JOIN products p
    ON p.product_id = MOD(o.order_id + n.n * 7, 150) + 1

LEFT JOIN promotions promo
    ON o.promotion_id = promo.promotion_id;
    
SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT
    COUNT(DISTINCT product_id) AS unique_products_sold
FROM order_items;

SELECT *
FROM order_items
LIMIT 15;

-- Calculating product level revenue and profit 

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,

    ROUND(
        SUM(oi.quantity * oi.unit_price),
        2
    ) AS gross_revenue,

    ROUND(
        SUM(
            (oi.quantity * oi.unit_price)
            - oi.discount_amount
            - (oi.quantity * p.unit_cost)
        ),
        2
    ) AS estimated_profit

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

GROUP BY p.product_id, p.product_name

ORDER BY estimated_profit DESC

LIMIT 10;

INSERT INTO inventory
(inventory_id, store_id, product_id,
 stock_quantity, reorder_level, last_updated)

SELECT
    ((s.store_id - 1) * 150) + p.product_id,

    s.store_id,

    p.product_id,

    CASE
        WHEN MOD(s.store_id + p.product_id, 13) = 0
            THEN 0
        WHEN MOD(s.store_id + p.product_id, 7) = 0
            THEN 5
        ELSE 20 + MOD(s.store_id * p.product_id, 80)
    END,

    10 + MOD(p.product_id, 15),

    '2025-11-20 10:00:00'

FROM stores s
CROSS JOIN products p;

SELECT COUNT(*) AS total_inventory_records
FROM inventory;

SELECT
    CASE
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity <= reorder_level THEN 'Low Stock'
        ELSE 'Healthy Stock'
    END AS inventory_status,

    COUNT(*) AS total_records

FROM inventory

GROUP BY inventory_status;

-- stores with highest number of stockouts 

SELECT
    s.store_name,
    s.city,
    COUNT(*) AS out_of_stock_products

FROM inventory i

JOIN stores s
    ON i.store_id = s.store_id

WHERE i.stock_quantity = 0

GROUP BY s.store_id, s.store_name, s.city

ORDER BY out_of_stock_products DESC;

INSERT INTO deliveries
(delivery_id, order_id, rider_id,
 assigned_at, picked_up_at, delivered_at, delivery_status)

SELECT
    o.order_id - 10000,

    o.order_id,

    MOD(o.order_id, 200) + 1,

    DATE_ADD(o.order_date, INTERVAL 2 MINUTE),

    DATE_ADD(
        o.order_date,
        INTERVAL (7 + MOD(o.order_id, 10)) MINUTE
    ),

    DATE_ADD(
        o.order_date,
        INTERVAL (15 + MOD(o.order_id, 32)) MINUTE
    ),

    CASE
        WHEN 15 + MOD(o.order_id, 32) > 30
            THEN 'Delayed'
        ELSE 'On Time'
    END

FROM orders o

WHERE o.order_status = 'Delivered';

SELECT COUNT(*) AS total_deliveries
FROM deliveries;

SELECT
    delivery_status,
    COUNT(*) AS total_deliveries
FROM deliveries
GROUP BY delivery_status;

-- calculating average delivery time in minutes

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                assigned_at,
                delivered_at
            )
        ),
        2
    ) AS avg_delivery_time_minutes

FROM deliveries;

SELECT 'Stores' AS table_name, COUNT(*) AS total_records FROM stores
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Promotions', COUNT(*) FROM promotions
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'Deliveries', COUNT(*) FROM deliveries;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS invalid_customer_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_product_items
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

-- REVENUE AND PROFITABILITY ANALYSIS

SELECT
    s.city,

    ROUND(
        SUM(oi.quantity * oi.unit_price),
        2
    ) AS gross_revenue,

    ROUND(
        SUM(oi.discount_amount),
        2
    ) AS total_discount,

    ROUND(
        SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
        ),
        2
    ) AS net_revenue,

    ROUND(
        SUM(oi.quantity * p.unit_cost),
        2
    ) AS product_cost,

    ROUND(
        SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
            - oi.quantity * p.unit_cost
        ),
        2
    ) AS estimated_gross_profit,

    ROUND(
        100 * SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
            - oi.quantity * p.unit_cost
        )
        /
        NULLIF(
            SUM(
                oi.quantity * oi.unit_price
                - oi.discount_amount
            ),
            0
        ),
        2
    ) AS profit_margin_percentage

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

JOIN stores s
    ON o.store_id = s.store_id

WHERE o.order_status = 'Delivered'

GROUP BY s.city

ORDER BY estimated_gross_profit DESC;

-- INVENTORY LEAKAGE AND STOCKOUT ANALYSIS 

SELECT
    s.city,

    COUNT(*) AS total_products_tracked,

    SUM(
        CASE
            WHEN i.stock_quantity = 0 THEN 1
            ELSE 0
        END
    ) AS out_of_stock,

    SUM(
        CASE
            WHEN i.stock_quantity > 0
             AND i.stock_quantity <= i.reorder_level
            THEN 1
            ELSE 0
        END
    ) AS low_stock,

    SUM(
        CASE
            WHEN i.stock_quantity > i.reorder_level
            THEN 1
            ELSE 0
        END
    ) AS healthy_stock

FROM inventory i

JOIN stores s
    ON i.store_id = s.store_id

GROUP BY s.city

ORDER BY out_of_stock DESC;


SELECT
    p.product_id,
    p.product_name,
    p.category,

    COUNT(*) AS stores_tracking_product,

    SUM(
        CASE
            WHEN i.stock_quantity = 0 THEN 1
            ELSE 0
        END
    ) AS stockout_stores,

    SUM(
        CASE
            WHEN i.stock_quantity > 0
             AND i.stock_quantity <= i.reorder_level
            THEN 1
            ELSE 0
        END
    ) AS low_stock_stores

FROM inventory i

JOIN products p
    ON i.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category

HAVING
    stockout_stores > 0
    OR low_stock_stores > 0

ORDER BY
    stockout_stores DESC,
    low_stock_stores DESC

LIMIT 20;



SELECT
    s.store_name,
    p.product_name,
    i.stock_quantity,
    i.reorder_level,

    CASE
        WHEN i.stock_quantity = 0
            THEN 'URGENT: Restock Immediately'

        WHEN i.stock_quantity <= i.reorder_level
            THEN 'ACTION: Reorder Stock'

        ELSE 'Status: Healthy'
    END AS recommended_action

FROM inventory i

JOIN stores s
    ON i.store_id = s.store_id

JOIN products p
    ON i.product_id = p.product_id

WHERE i.stock_quantity <= i.reorder_level

ORDER BY
    i.stock_quantity ASC,
    i.reorder_level DESC

LIMIT 30;



-- CUSTOMER BEHAVIOUR AND PURCHASING ANALYSIS

SELECT
    city,
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN customer_status = 'Active' THEN 1
            ELSE 0
        END
    ) AS active_customers,

    SUM(
        CASE
            WHEN customer_status = 'Inactive' THEN 1
            ELSE 0
        END
    ) AS inactive_customers

FROM customers

GROUP BY city

ORDER BY total_customers DESC;

SELECT
    c.customer_id,
    c.customer_name,
    c.city,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
        ),
        2
    ) AS total_revenue,

    ROUND(
        AVG(
            oi.quantity * oi.unit_price
            - oi.discount_amount
        ),
        2
    ) AS avg_item_net_value

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'Delivered'

GROUP BY
    c.customer_id,
    c.customer_name,
    c.city

ORDER BY total_revenue DESC

LIMIT 20;

SELECT
    c.customer_id,
    c.customer_name,
    c.city,

    COUNT(DISTINCT o.order_id) AS delivered_orders,

    CASE
        WHEN COUNT(DISTINCT o.order_id) >= 5
            THEN 'Loyal Customer'

        WHEN COUNT(DISTINCT o.order_id) >= 2
            THEN 'Repeat Customer'

        ELSE 'One-Time Customer'
    END AS customer_segment

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_status = 'Delivered'

GROUP BY
    c.customer_id,
    c.customer_name,
    c.city

ORDER BY delivered_orders DESC;

SELECT
    COUNT(*) AS total_customers_with_delivered_orders,

    SUM(
        CASE
            WHEN delivered_orders >= 2 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        100 * SUM(
            CASE
                WHEN delivered_orders >= 2 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_percentage

FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS delivered_orders

    FROM orders

    WHERE order_status = 'Delivered'

    GROUP BY customer_id
) AS customer_orders;


-- DELIVERY PERFORMANCE ANALYSIS 

SELECT
    COUNT(*) AS total_deliveries,

    SUM(
        CASE
            WHEN delivery_status = 'On Time' THEN 1
            ELSE 0
        END
    ) AS on_time_deliveries,

    SUM(
        CASE
            WHEN delivery_status = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_deliveries,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN delivery_status = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delayed_delivery_percentage

FROM deliveries;

SELECT
    s.city,

    COUNT(*) AS total_deliveries,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                o.order_date,
                d.delivered_at
            )
        ),
        2
    ) AS avg_total_delivery_minutes,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                d.picked_up_at,
                d.delivered_at
            )
        ),
        2
    ) AS avg_rider_travel_minutes,

    SUM(
        CASE
            WHEN d.delivery_status = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_deliveries

FROM deliveries d

JOIN orders o
    ON d.order_id = o.order_id

JOIN stores s
    ON o.store_id = s.store_id

GROUP BY s.city

ORDER BY avg_total_delivery_minutes DESC;

SELECT
    rider_id,

    COUNT(*) AS total_deliveries,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                assigned_at,
                delivered_at
            )
        ),
        2
    ) AS avg_delivery_minutes,

    SUM(
        CASE
            WHEN delivery_status = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_deliveries

FROM deliveries

GROUP BY rider_id

ORDER BY delayed_deliveries DESC;

SELECT
    s.store_name,
    s.city,

    COUNT(*) AS total_deliveries,

    SUM(
        CASE
            WHEN d.delivery_status = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_deliveries,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN d.delivery_status = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_percentage

FROM deliveries d

JOIN orders o
    ON d.order_id = o.order_id

JOIN stores s
    ON o.store_id = s.store_id

GROUP BY s.store_id, s.store_name, s.city

ORDER BY delay_percentage DESC;

-- PROMOTIONS EFFECTIVENESS

SELECT
    p.promotion_id,
    p.promotion_name,
    p.discount_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS gross_revenue,
    ROUND(SUM(oi.discount_amount), 2) AS total_discount,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS net_revenue
FROM promotions p
JOIN orders o
    ON p.promotion_id = o.promotion_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
    p.promotion_id,
    p.promotion_name,
    p.discount_type
HAVING COUNT(DISTINCT o.order_id) > 0
ORDER BY net_revenue DESC;

SELECT
    p.promotion_id,
    p.promotion_name,
    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS net_revenue,

    ROUND(
        SUM(oi.quantity * pdt.unit_cost),
        2
    ) AS product_cost,

    ROUND(
        SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
            - oi.quantity * pdt.unit_cost
        ),
        2
    ) AS estimated_gross_profit,

    ROUND(
        100 * SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
            - oi.quantity * pdt.unit_cost
        ) / NULLIF(
            SUM(oi.quantity * oi.unit_price - oi.discount_amount),
            0
        ),
        2
    ) AS profit_margin_percentage

FROM promotions p
JOIN orders o
    ON p.promotion_id = o.promotion_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products pdt
    ON oi.product_id = pdt.product_id

WHERE o.order_status = 'Delivered'

GROUP BY
    p.promotion_id,
    p.promotion_name

ORDER BY estimated_gross_profit DESC;

SELECT
    CASE
        WHEN o.promotion_id IS NULL THEN 'Non-Promotional'
        ELSE 'Promotional'
    END AS order_type,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS net_revenue,

    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value,

    ROUND(
        SUM(oi.discount_amount)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_discount_per_order

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'Delivered'

GROUP BY order_type
ORDER BY net_revenue DESC;

-- Identifying Most Profitbale Cities

WITH city_profit AS (
    SELECT
        s.city,

        ROUND(
            SUM(oi.quantity * oi.unit_price - oi.discount_amount),
            2
        ) AS net_revenue,

        ROUND(
            SUM(oi.quantity * p.unit_cost),
            2
        ) AS product_cost,

        ROUND(
            SUM(
                oi.quantity * oi.unit_price
                - oi.discount_amount
                - oi.quantity * p.unit_cost
            ),
            2
        ) AS gross_profit

    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    JOIN stores s
        ON o.store_id = s.store_id

    WHERE o.order_status = 'Delivered'

    GROUP BY s.city
)

SELECT
    city,
    net_revenue,
    product_cost,
    gross_profit,

    ROUND(
        100 * gross_profit / NULLIF(net_revenue, 0),
        2
    ) AS profit_margin_percentage

FROM city_profit
ORDER BY profit_margin_percentage DESC;

-- Identifying high value customers 

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,

        COUNT(DISTINCT o.order_id) AS total_orders,

        ROUND(
            SUM(
                oi.quantity * oi.unit_price
                - oi.discount_amount
            ),
            2
        ) AS total_revenue

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Delivered'

    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city
)

SELECT
    customer_id,
    customer_name,
    city,
    total_orders,
    total_revenue,

    CASE
        WHEN total_revenue > 10000 THEN 'VIP'
        WHEN total_revenue >= 5000 THEN 'Valuable'
        ELSE 'Regular'
    END AS customer_segment

FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 20;

-- Ranking Stores 

WITH store_revenue AS (
    SELECT
        s.store_id,
        s.store_name,
        s.city,
        ROUND(
            SUM(oi.quantity * oi.unit_price - oi.discount_amount),
            2
        ) AS total_revenue

    FROM stores s
    JOIN orders o
        ON s.store_id = o.store_id
    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Delivered'

    GROUP BY s.store_id, s.store_name, s.city
)

SELECT
    store_id,
    store_name,
    city,
    total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM store_revenue;

-- Month over Month Revenue 

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        SUM(
            oi.quantity * oi.unit_price - oi.discount_amount
        ) AS revenue

    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'Delivered'

    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),

revenue_comparison AS (
    SELECT
        order_month,
        revenue,

        LAG(revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue

    FROM monthly_revenue
)

SELECT
    order_month,
    ROUND(revenue, 2) AS current_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        100 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage

FROM revenue_comparison
ORDER BY order_month;

-- Revenue Performance View 

CREATE VIEW city_revenue_summary AS
SELECT
    s.city,

    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS net_revenue,

    ROUND(
        SUM(oi.quantity * p.unit_cost),
        2
    ) AS product_cost,

    ROUND(
        SUM(
            oi.quantity * oi.unit_price
            - oi.discount_amount
            - oi.quantity * p.unit_cost
        ),
        2
    ) AS estimated_gross_profit

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN stores s
    ON o.store_id = s.store_id

WHERE o.order_status = 'Delivered'

GROUP BY s.city;

SELECT *
FROM city_revenue_summary;















