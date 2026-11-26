# Data Dictionary — Supply Chain & Inventory Analytics

## Dataset overview

- **Source dataset:** DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS
- **Original dataset size:** 180,519 rows × 53 columns.
- **Cleaned project dataset size:** 180,519 rows × 45 columns.
- **Row-level interpretation:** The dataset contains order-item-level records. A row count should not automatically be interpreted as a count of unique orders or physical shipments.
- **Source definitions:** Field descriptions are based on the supplied `Description.csv`, with wording clarified where needed for readability.

## Fields retained in the cleaned dataset

| # | Field name | Description |
|---:|---|---|
| 1 | `Type` | Type of transaction made. |
| 2 | `Days for shipping (real)` | Actual number of shipping days for the purchased product. |
| 3 | `Days for shipment (scheduled)` | Scheduled number of delivery days for the purchased product. |
| 4 | `Benefit per order` | Earnings/benefit recorded per order. |
| 5 | `Sales per customer` | Total sales per customer, as described in the source data dictionary. |
| 6 | `Delivery Status` | Delivery status: Advance shipping, Late delivery, Shipping canceled, or Shipping on time. |
| 7 | `Late_delivery_risk` | Indicator: 1 means the shipment is late; 0 means it is not late. |
| 8 | `Category Id` | Product category code. |
| 9 | `Category Name` | Description/name of the product category. |
| 10 | `Customer City` | City where the customer made the purchase. |
| 11 | `Customer Country` | Country where the customer made the purchase. |
| 12 | `Customer Id` | Customer identifier. |
| 13 | `Customer Segment` | Customer type: Consumer, Corporate, or Home Office. |
| 14 | `Customer State` | State associated with the customer location (source description refers to the store where the purchase is registered). |
| 15 | `Customer Zipcode` | Postal/ZIP code associated with the customer location. |
| 16 | `Department Id` | Department identifier. |
| 17 | `Department Name` | Department name. |
| 18 | `Latitude` | Latitude coordinate associated with the customer/store location, as described in the source data dictionary. |
| 19 | `Longitude` | Longitude coordinate associated with the customer/store location, as described in the source data dictionary. |
| 20 | `Market` | Market to which the order is delivered. |
| 21 | `Order City` | Destination city of the order. |
| 22 | `Order Country` | Destination country of the order. |
| 23 | `Order Customer Id` | Customer identifier associated with the order. |
| 24 | `order date (DateOrders)` | Date and time on which the order was made. |
| 25 | `Order Id` | Order identifier. |
| 26 | `Order Item Cardprod Id` | Product code associated with the order item, generated through the RFID reader (source description). |
| 27 | `Order Item Discount` | Discount value applied to the order item. |
| 28 | `Order Item Discount Rate` | Discount percentage applied to the order item. |
| 29 | `Order Item Id` | Order-item identifier. |
| 30 | `Order Item Product Price` | Product price before the item discount (source description). |
| 31 | `Order Item Profit Ratio` | Profit ratio recorded for the order item. |
| 32 | `Order Item Quantity` | Number of product units in the order item. |
| 33 | `Sales` | Sales value recorded for the order item. |
| 34 | `Order Item Total` | Total amount recorded for the order item. |
| 35 | `Order Profit Per Order` | Profit amount recorded for the order. |
| 36 | `Order Region` | World region to which the order is delivered. |
| 37 | `Order State` | State or administrative area associated with the order destination. |
| 38 | `Order Status` | Order status, such as COMPLETE, PENDING, CLOSED, CANCELED, PROCESSING, or other source values. |
| 39 | `Order Zipcode` | Postal/ZIP code associated with the order destination. |
| 40 | `Product Card Id` | Product identifier. |
| 41 | `Product Category Id` | Product category identifier. |
| 42 | `Product Name` | Product Name |
| 43 | `Product Price` | Product price recorded in the product data. |
| 44 | `shipping date (DateOrders)` | Date and time on which the order was shipped. |
| 45 | `Shipping Mode` | Shipping service/mode: Standard Class, First Class, Second Class, or Same Day. |

## Fields removed during project cleaning

The following eight fields were excluded from the cleaned project dataset:

| Removed field | Reason for exclusion |
|---|---|
| `Customer Email` | Personal/customer contact information; not required for the dashboard analysis. |
| `Customer Fname` | Personal/customer name; not required for the dashboard analysis. |
| `Customer Lname` | Personal/customer name; not required for the dashboard analysis. |
| `Customer Password` | Sensitive credential-like field; excluded from analytical use. |
| `Customer Street` | Detailed customer address; not required for the dashboard analysis. |
| `Product Description` | Descriptive text not used in the dashboard measures or visuals. |
| `Product Image` | Image URL not used in the dashboard measures or visuals. |
| `Product Status` | Not used in the dashboard analysis. |

## Interpretation notes

- **Order vs. order item:** `Order Id` identifies an order, while `Order Item Id` identifies an order-item record. Use distinct `Order Id` when calculating orders.
- **Delivery metrics:** Delivery status and shipping-duration analysis in this project count order-item rows unless a measure explicitly uses a distinct order identifier. They should not be described as unique physical shipments.
- **Sales and profit:** `Sales`, `Order Item Total`, `Order Profit Per Order`, and `Benefit per order` are separate source fields. Do not assume they are interchangeable.
- **Dates:** `order date (DateOrders)` is the order date/time; `shipping date (DateOrders)` is the shipment date/time.
- **Late-delivery indicator:** `Late_delivery_risk` is coded 1 for late and 0 for not late according to the source dictionary. `Delivery Status` provides the categorical delivery outcome.
- **Geography:** Customer location fields and order-destination fields describe different locations; use the appropriate group for the analysis.
- **Currency:** The source files provided for this project do not establish a verified currency code. Monetary values are therefore not labelled USD in this documentation.

## Data quality notes

- The project cleaning notes report three missing `Customer Zipcode` values retained as null.
- The project cleaning notes report no duplicate rows in the cleaned dataset.
- The cleaned dataset retains 45 columns after removing eight fields from the 53-column source.
