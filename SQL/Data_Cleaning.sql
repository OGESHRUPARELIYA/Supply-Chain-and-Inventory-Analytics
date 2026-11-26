-- Supply Chain & Inventory Analytics
-- Data_Cleaning.sql
-- MySQL 8.0+
--
-- Prerequisite:
-- 1. Import the original DataCo CSV into supply_chain_ops.dataco_raw.
-- 2. Keep the source column names as imported (including spaces and punctuation).
--
-- This script reproduces the documented column-removal step. It does not
-- overwrite or modify the raw table. Missing Customer Zipcode values are
-- retained as NULL; no rows are deleted by this script.

CREATE DATABASE IF NOT EXISTS supply_chain_ops;
USE supply_chain_ops;

DROP TABLE IF EXISTS dataco_cleaned;

CREATE TABLE dataco_cleaned AS
SELECT
    `Type`,
    `Days for shipping (real)`,
    `Days for shipment (scheduled)`,
    `Benefit per order`,
    `Sales per customer`,
    `Delivery Status`,
    `Late_delivery_risk`,
    `Category Id`,
    `Category Name`,
    `Customer City`,
    `Customer Country`,
    `Customer Id`,
    `Customer Segment`,
    `Customer State`,
    `Customer Zipcode`,
    `Department Id`,
    `Department Name`,
    `Latitude`,
    `Longitude`,
    `Market`,
    `Order City`,
    `Order Country`,
    `Order Customer Id`,
    `order date (DateOrders)`,
    `Order Id`,
    `Order Item Cardprod Id`,
    `Order Item Discount`,
    `Order Item Discount Rate`,
    `Order Item Id`,
    `Order Item Product Price`,
    `Order Item Profit Ratio`,
    `Order Item Quantity`,
    `Sales`,
    `Order Item Total`,
    `Order Profit Per Order`,
    `Order Region`,
    `Order State`,
    `Order Status`,
    `Order Zipcode`,
    `Product Card Id`,
    `Product Category Id`,
    `Product Name`,
    `Product Price`,
    `shipping date (DateOrders)`,
    `Shipping Mode`
FROM dataco_raw;

-- Basic validation checks
SELECT COUNT(*) AS cleaned_row_count
FROM dataco_cleaned;

SELECT COUNT(*) AS cleaned_column_count
FROM information_schema.columns
WHERE table_schema = DATABASE()
  AND table_name = 'dataco_cleaned';

SELECT COUNT(*) AS missing_customer_zipcodes
FROM dataco_cleaned
WHERE `Customer Zipcode` IS NULL;

-- Duplicate-row check across all retained columns.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT_WS(
        '¦',
        `Type`,
        `Days for shipping (real)`,
        `Days for shipment (scheduled)`,
        `Benefit per order`,
        `Sales per customer`,
        `Delivery Status`,
        `Late_delivery_risk`,
        `Category Id`,
        `Category Name`,
        `Customer City`,
        `Customer Country`,
        `Customer Id`,
        `Customer Segment`,
        `Customer State`,
        `Customer Zipcode`,
        `Department Id`,
        `Department Name`,
        `Latitude`,
        `Longitude`,
        `Market`,
        `Order City`,
        `Order Country`,
        `Order Customer Id`,
        `order date (DateOrders)`,
        `Order Id`,
        `Order Item Cardprod Id`,
        `Order Item Discount`,
        `Order Item Discount Rate`,
        `Order Item Id`,
        `Order Item Product Price`,
        `Order Item Profit Ratio`,
        `Order Item Quantity`,
        `Sales`,
        `Order Item Total`,
        `Order Profit Per Order`,
        `Order Region`,
        `Order State`,
        `Order Status`,
        `Order Zipcode`,
        `Product Card Id`,
        `Product Category Id`,
        `Product Name`,
        `Product Price`,
        `shipping date (DateOrders)`,
        `Shipping Mode`
    )) AS distinct_concatenated_rows
FROM dataco_cleaned;

-- Eight removed source fields:
-- Customer Email, Customer Fname, Customer Lname, Customer Password,
-- Customer Street, Product Description, Product Image, Product Status.
-- Note: CONCAT_WS is a practical check, not a collision-proof row hash.
