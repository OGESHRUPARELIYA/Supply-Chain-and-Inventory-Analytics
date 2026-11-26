-- Supply Chain & Inventory Analytics
-- Business_Analysis.sql
-- MySQL 8.0+
--
-- Run against supply_chain_ops.dataco_cleaned.
-- Delivery-status counts are order-item rows, not unique physical shipments.

USE supply_chain_ops;

-- 1. Overall KPIs
SELECT
    COUNT(DISTINCT `Order Id`) AS total_orders,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    COUNT(DISTINCT `Customer Id`) AS total_customers,
    ROUND(
        100 * SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0),
        2
    ) AS profit_margin_pct
FROM dataco_cleaned;

-- 2. Sales and profit by customer segment
SELECT
    `Customer Segment`,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    ROUND(
        100 * SUM(`Sales`) /
        NULLIF((SELECT SUM(`Sales`) FROM dataco_cleaned), 0),
        2
    ) AS share_of_total_sales_pct
FROM dataco_cleaned
GROUP BY `Customer Segment`
ORDER BY total_sales DESC;

-- 3. Sales by order region
SELECT
    `Order Region`,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    ROUND(
        100 * SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0),
        2
    ) AS profit_margin_pct
FROM dataco_cleaned
GROUP BY `Order Region`
ORDER BY total_sales DESC;

-- 4. Top 10 products by sales
SELECT
    `Product Name`,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    SUM(`Order Item Quantity`) AS units_sold
FROM dataco_cleaned
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Top 10 products by profit
SELECT
    `Product Name`,
    SUM(`Order Profit Per Order`) AS total_profit,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Item Quantity`) AS units_sold
FROM dataco_cleaned
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 10;

-- 6. Delivery status distribution (order-item rows)
SELECT
    `Delivery Status`,
    COUNT(*) AS order_item_rows,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM dataco_cleaned), 2)
        AS share_of_rows_pct
FROM dataco_cleaned
GROUP BY `Delivery Status`
ORDER BY order_item_rows DESC;

-- 7. Late-delivery rate by shipping mode
SELECT
    `Shipping Mode`,
    COUNT(*) AS order_item_rows,
    SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        AS late_order_item_rows,
    ROUND(
        100 * SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct
FROM dataco_cleaned
GROUP BY `Shipping Mode`
ORDER BY late_delivery_rate_pct DESC;

-- 8. Average actual vs scheduled shipping days by shipping mode
SELECT
    `Shipping Mode`,
    ROUND(AVG(`Days for shipping (real)`), 2) AS avg_actual_shipping_days,
    ROUND(AVG(`Days for shipment (scheduled)`), 2) AS avg_scheduled_shipping_days
FROM dataco_cleaned
GROUP BY `Shipping Mode`
ORDER BY `Shipping Mode`;

-- 9. Profitability by product category
SELECT
    `Category Name`,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    ROUND(
        100 * SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0),
        2
    ) AS profit_margin_pct
FROM dataco_cleaned
GROUP BY `Category Name`
ORDER BY total_profit DESC;

-- 10. Discount-band analysis
SELECT
    CASE
        WHEN `Order Item Discount Rate` < 0.05 THEN '0–5%'
        WHEN `Order Item Discount Rate` < 0.10 THEN '5–10%'
        WHEN `Order Item Discount Rate` < 0.15 THEN '10–15%'
        WHEN `Order Item Discount Rate` < 0.20 THEN '15–20%'
        ELSE '20–25%+'
    END AS discount_band,
    COUNT(*) AS order_item_rows,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    ROUND(
        100 * SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0),
        2
    ) AS profit_margin_pct
FROM dataco_cleaned
GROUP BY discount_band
ORDER BY MIN(`Order Item Discount Rate`);

-- 11. Late-delivery rate by region
SELECT
    `Order Region`,
    COUNT(*) AS order_item_rows,
    SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        AS late_order_item_rows,
    ROUND(
        100 * SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct
FROM dataco_cleaned
GROUP BY `Order Region`
ORDER BY late_delivery_rate_pct DESC;

-- 12. Monthly sales and profit trend
SELECT
    DATE_FORMAT(`order date (DateOrders)`, '%Y-%m') AS order_month,
    SUM(`Sales`) AS total_sales,
    SUM(`Order Profit Per Order`) AS total_profit,
    COUNT(DISTINCT `Order Id`) AS total_orders
FROM dataco_cleaned
GROUP BY DATE_FORMAT(`order date (DateOrders)`, '%Y-%m')
ORDER BY order_month;
