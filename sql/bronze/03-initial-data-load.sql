-- Initial full load of CSV data into Bronze tables from internal stage
-- Co-authored with CoCo

-- =====================================================
-- Initial Data Load - Run AFTER uploading CSVs to stage
-- Prerequisites: 
--   1. Script 01 executed (database/schemas exist)
--   2. Script 02 executed (stages, file formats, tables exist)
--   3. CSV files uploaded to @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE
-- =====================================================

-- =====================================================
-- COUNTRY MASTERS
-- =====================================================
COPY INTO SALES_DEV.BRONZE.REGION_MASTER
FROM (
    SELECT 
        $1, $2, $3, $4, $5, $6, $7,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER,
        CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/country-master/region_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.CURRENCY_MASTER
FROM (
    SELECT 
        $1, $2, $3, $4, $5, $6, $7, $8, $9,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER,
        CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/country-master/currency_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.TAX_MASTER
FROM (
    SELECT 
        $1, $2, $3, $4, $5, $6, $7, $8, $9,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER,
        CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/country-master/tax_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.COUNTRY_MASTER
FROM (
    SELECT 
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER,
        CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/country-master/country_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

-- =====================================================
-- PRODUCT MASTERS
-- =====================================================
COPY INTO SALES_DEV.BRONZE.PRODUCT_CATEGORY_MASTER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/product-master/product_category_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.PRODUCT_FAMILY_MASTER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/product-master/product_family_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.PRODUCT_MODEL_MASTER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/product-master/product_model_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.PRODUCT_SKU_MASTER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/product-master/product_sku_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.PRODUCT_COUNTRY_AVAILABILITY
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/product-master/product_country_availability.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

-- =====================================================
-- STORE MASTER
-- =====================================================
COPY INTO SALES_DEV.BRONZE.STORE_MASTER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/store-master/store_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

-- =====================================================
-- CUSTOMER MASTER
-- =====================================================
COPY INTO SALES_DEV.BRONZE.CUSTOMER_MASTER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/customer-master/customer_master.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

-- =====================================================
-- SALES TRANSACTIONS
-- =====================================================
COPY INTO SALES_DEV.BRONZE.SALES_HEADER
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/sales-transaction/sales_header.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;

COPY INTO SALES_DEV.BRONZE.SALES_ITEM
FROM (
    SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9,
        METADATA$FILENAME, METADATA$FILE_ROW_NUMBER, CURRENT_TIMESTAMP()
    FROM @SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE/initial-load/sales-transaction/sales_item.csv
)
FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT;
