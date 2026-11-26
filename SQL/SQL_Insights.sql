-- Supply Chain & Inventory Analytics
-- SQL_Insights.sql
-- MySQL 8.0+
--
-- Focused queries for validating the headline findings documented in README.md.
-- All delivery rates below are calculated over order-item rows, not unique
-- orders or physical shipments. Results can vary if the source table changes.

USE supply_chain_ops;

-- Insight 1: Overall late-delivery share
SELECT
    COUNT(*) AS total_order_item_rows,
    SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        AS late_order_item_rows,
    ROUND(
        100 * SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct
FROM dataco_cleaned;

-- Insight 2: Shipping mode with the highest late-delivery rate
SELECT
    `Shipping Mode`,
    COUNT(*) AS order_item_rows,
    ROUND(
        100 * SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct
FROM dataco_cleaned
GROUP BY `Shipping Mode`
ORDER BY late_delivery_rate_pct DESC;

-- Insight 3: Regions with the highest and lowest late-delivery rates
SELECT
    `Order Region`,
    ROUND(
        100 * SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct
FROM dataco_cleaned
GROUP BY `Order Region`
ORDER BY late_delivery_rate_pct DESC;

-- Insight 4: Share of sales contributed by each customer segment
SELECT
    `Customer Segment`,
    SUM(`Sales`) AS segment_sales,
    ROUND(
        100 * SUM(`Sales`) / NULLIF(
            (SELECT SUM(`Sales`) FROM dataco_cleaned), 0
        ),
        2
    ) AS sales_share_pct
FROM dataco_cleaned
GROUP BY `Customer Segment`
ORDER BY segment_sales DESC;

-- Insight 5: Highest and lowest category profit margins
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
ORDER BY profit_margin_pct DESC;

-- Insight 6: Profit margin by discount band
SELECT
    CASE
        WHEN `Order Item Discount Rate` < 0.05 THEN '0–5%'
        WHEN `Order Item Discount Rate` < 0.10 THEN '5–10%'
        WHEN `Order Item Discount Rate` < 0.15 THEN '10–15%'
        WHEN `Order Item Discount Rate` < 0.20 THEN '15–20%'
        ELSE '20–25%+'
    END AS discount_band,
    COUNT(*) AS order_item_rows,
    ROUND(
        100 * SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0),
        2
    ) AS profit_margin_pct
FROM dataco_cleaned
GROUP BY discount_band
ORDER BY MIN(`Order Item Discount Rate`);

-- Interpretation cautions:
-- * A higher late-delivery rate by shipping mode is an association, not proof
--   that the shipping mode caused the delay.
-- * Lower margins in higher discount bands do not establish causation.
-- * The 2018 data has limited coverage relative to earlier years; avoid
--   interpreting its lower totals as a business decline.
-- * Monetary currency code was not verified in the project source files.
