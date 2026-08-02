-- Semantic view deployment and Cortex Analyst setup for Sales Analytics
-- Co-authored with CoCo

-- =====================================================
-- Cortex Analyst Setup - Talk to Your Sales Data
-- Semantic View: SALES_DEV.GOLD.SALES_ANALYTICS
-- =====================================================

-- The semantic view SALES_DEV.GOLD.SALES_ANALYTICS has been deployed
-- with the following structure:
--
-- TABLES (7):
--   FACT_SALES_ITEM      - Line item grain, product-level analytics
--   FACT_SALES_HEADER    - Transaction grain, order-level analytics
--   DIM_CUSTOMER         - Customer demographics & loyalty
--   DIM_PRODUCT          - Product hierarchy (Category > Family > Model > SKU)
--   DIM_STORE            - Store location & operations
--   DIM_COUNTRY          - Geography, currency, tax
--   DIM_DATE             - Calendar & fiscal time attributes
--
-- RELATIONSHIPS (10):
--   FACT_SALES_HEADER -> DIM_CUSTOMER  (many_to_one via CUSTOMER_DIM_KEY)
--   FACT_SALES_HEADER -> DIM_STORE     (many_to_one via STORE_DIM_KEY)
--   FACT_SALES_HEADER -> DIM_COUNTRY   (many_to_one via COUNTRY_DIM_KEY)
--   FACT_SALES_HEADER -> DIM_DATE      (many_to_one via DATE_DIM_KEY)
--   FACT_SALES_ITEM   -> DIM_PRODUCT   (many_to_one via PRODUCT_DIM_KEY)
--   FACT_SALES_ITEM   -> FACT_SALES_HEADER (many_to_one via FACT_SALES_HEADER_KEY)
--   FACT_SALES_ITEM   -> DIM_CUSTOMER  (many_to_one via CUSTOMER_DIM_KEY)
--   FACT_SALES_ITEM   -> DIM_STORE     (many_to_one via STORE_DIM_KEY)
--   FACT_SALES_ITEM   -> DIM_COUNTRY   (many_to_one via COUNTRY_DIM_KEY)
--   FACT_SALES_ITEM   -> DIM_DATE      (many_to_one via DATE_DIM_KEY)
--
-- METRICS (14):
--   FACT_SALES_HEADER: TOTAL_REVENUE, TOTAL_GROSS_SALES, TOTAL_DISCOUNTS,
--                      TOTAL_TAX_COLLECTED, NUM_TRANSACTIONS, AVERAGE_ORDER_VALUE,
--                      UNIQUE_CUSTOMERS, DISCOUNT_RATE
--   FACT_SALES_ITEM:   TOTAL_UNITS_SOLD, TOTAL_LINE_REVENUE, TOTAL_LINE_DISCOUNT,
--                      AVERAGE_UNIT_PRICE, LINE_ITEM_COUNT, AVERAGE_BASKET_SIZE
--
-- VERIFIED QUERIES (8): Revenue, category breakdown, country sales,
--   monthly trends, loyalty tier, store performance, channel comparison, top products

-- =====================================================
-- Option 1: Stage-based approach (upload YAML to stage)
-- =====================================================

-- Create stage for semantic model YAML
CREATE OR REPLACE STAGE SALES_DEV.GOLD.SEMANTIC_MODELS
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Stage for Cortex Analyst semantic model files';

-- Upload the semantic model YAML file to the stage
COPY FILES INTO @SALES_DEV.GOLD.SEMANTIC_MODELS
FROM 'snow://workspace/USER$.PUBLIC.DEFAULT$/versions/live/'
FILES=('cortex_project/SALES_ANALYTICS.sv.yaml');

-- Verify the file is uploaded
LIST @SALES_DEV.GOLD.SEMANTIC_MODELS;

-- =====================================================
-- Option 2: Semantic View (already deployed)
-- =====================================================

-- Verify the semantic view exists
SHOW SEMANTIC VIEWS IN SALES_DEV.GOLD;

-- To use with Cortex Analyst via the semantic view:
-- Navigate to: Snowsight > AI & ML > Cortex Analyst
-- Select semantic view: SALES_DEV.GOLD.SALES_ANALYTICS