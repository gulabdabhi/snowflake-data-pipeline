-- =====================================================
-- Sales Data Platform - Stage and Data Loading DDL
-- Internal stage for CSV file uploads in Bronze layer
-- =====================================================

CREATE OR REPLACE STAGE SALES_DEV.BRONZE.SALES_ANALYTICS_STAGE
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Internal stage for uploading sales analytics CSV files';

-- File Format for CSV files with header row
CREATE OR REPLACE FILE FORMAT SALES_DEV.COMMON.CSV_FORMAT
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    COMMENT = 'CSV file format with header row support';

-- =====================================================
-- REGION_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.REGION_MASTER (
    REGION_CODE             VARCHAR(10)     COMMENT 'Unique region identifier code',
    REGION_NAME             VARCHAR(100)    COMMENT 'Full name of the region',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    EFFECTIVE_START_DATE    DATE            COMMENT 'Date when region became active',
    EFFECTIVE_END_DATE      DATE            COMMENT 'Date when region becomes inactive',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer region master data containing geographic region definitions';

-- =====================================================
-- CURRENCY_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.CURRENCY_MASTER (
    CURRENCY_CODE           VARCHAR(3)      COMMENT 'ISO 4217 currency code',
    CURRENCY_NAME           VARCHAR(100)    COMMENT 'Full currency name',
    CURRENCY_SYMBOL         VARCHAR(5)      COMMENT 'Currency display symbol',
    MINOR_UNIT              NUMBER(1)       COMMENT 'Number of decimal places',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    EFFECTIVE_START_DATE    DATE            COMMENT 'Date when currency became active',
    EFFECTIVE_END_DATE      DATE            COMMENT 'Date when currency becomes inactive',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer currency master data with exchange rate reference information';

-- =====================================================
-- TAX_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.TAX_MASTER (
    TAX_CODE                VARCHAR(20)     COMMENT 'Unique tax configuration code',
    TAX_TYPE                VARCHAR(20)     COMMENT 'Type of tax (VAT, SALES_TAX, etc.)',
    TAX_RATE                NUMBER(5,4)     COMMENT 'Tax rate as decimal (e.g., 0.07 for 7%)',
    TAX_INCLUSIVE_FLAG      VARCHAR(1)      COMMENT 'Whether prices include tax (Y/N)',
    EFFECTIVE_START_DATE    DATE            COMMENT 'Date when tax rate became effective',
    EFFECTIVE_END_DATE      DATE            COMMENT 'Date when tax rate expires',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer tax master data containing tax rates and configurations by region';

-- =====================================================
-- COUNTRY_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.COUNTRY_MASTER (
    COUNTRY_CODE            VARCHAR(3)      COMMENT 'ISO 3166-1 alpha-2 country code',
    COUNTRY_NAME            VARCHAR(100)    COMMENT 'Full country name',
    REGION_CODE             VARCHAR(10)     COMMENT 'Reference to parent region',
    CURRENCY_CODE           VARCHAR(3)      COMMENT 'Default currency for the country',
    TAX_CODE                VARCHAR(20)     COMMENT 'Default tax configuration code',
    PRIMARY_LANGUAGE        VARCHAR(50)     COMMENT 'Primary language spoken',
    TIMEZONE                VARCHAR(50)     COMMENT 'Primary timezone identifier',
    ECOMMERCE_SUPPORTED     VARCHAR(1)      COMMENT 'E-commerce availability flag (Y/N)',
    RETAIL_STORE_SUPPORTED  VARCHAR(1)      COMMENT 'Physical store availability flag (Y/N)',
    MARKET_TIER             VARCHAR(10)     COMMENT 'Market classification tier',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer country master data with market and operational attributes';

-- =====================================================
-- PRODUCT_CATEGORY_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.PRODUCT_CATEGORY_MASTER (
    CATEGORY_CODE           VARCHAR(10)     COMMENT 'Unique product category identifier',
    CATEGORY_NAME           VARCHAR(100)    COMMENT 'Full category name',
    REPORTING_SEGMENT       VARCHAR(50)     COMMENT 'Financial reporting segment classification',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    EFFECTIVE_START_DATE    DATE            COMMENT 'Date when category became active',
    EFFECTIVE_END_DATE      DATE            COMMENT 'Date when category becomes inactive',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer product category master defining top-level product classifications';

-- =====================================================
-- PRODUCT_FAMILY_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.PRODUCT_FAMILY_MASTER (
    FAMILY_CODE             VARCHAR(20)     COMMENT 'Unique product family identifier',
    FAMILY_NAME             VARCHAR(100)    COMMENT 'Full product family name',
    CATEGORY_CODE           VARCHAR(10)     COMMENT 'Parent category reference',
    LAUNCH_YEAR             NUMBER(4)       COMMENT 'Year when family was launched',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    LIFECYCLE_STATUS        VARCHAR(20)     COMMENT 'Current product lifecycle stage',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer product family master grouping related product models by generation';

-- =====================================================
-- PRODUCT_MODEL_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.PRODUCT_MODEL_MASTER (
    MODEL_CODE              VARCHAR(20)     COMMENT 'Unique product model identifier',
    MODEL_NAME              VARCHAR(100)    COMMENT 'Full product model name',
    FAMILY_CODE             VARCHAR(20)     COMMENT 'Parent product family reference',
    LAUNCH_DATE             DATE            COMMENT 'Global launch date',
    DISCONTINUE_DATE        DATE            COMMENT 'Date when model was discontinued',
    LIFECYCLE_STATUS        VARCHAR(20)     COMMENT 'Current product lifecycle stage',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer product model master containing specific product model definitions';

-- =====================================================
-- PRODUCT_SKU_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.PRODUCT_SKU_MASTER (
    SKU_CODE                VARCHAR(30)     COMMENT 'Unique stock keeping unit identifier',
    MODEL_CODE              VARCHAR(20)     COMMENT 'Parent product model reference',
    VARIANT                 VARCHAR(50)     COMMENT 'SKU variant description (storage/color)',
    PRICE_TIER              VARCHAR(20)     COMMENT 'Pricing tier classification',
    GLOBAL_LAUNCH_DATE      DATE            COMMENT 'Global SKU launch date',
    IS_ACTIVE               VARCHAR(1)      COMMENT 'Active status flag (Y/N)',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer product SKU master with sellable item variants and pricing tiers';

-- =====================================================
-- PRODUCT_COUNTRY_AVAILABILITY Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.PRODUCT_COUNTRY_AVAILABILITY (
    SKU_CODE                VARCHAR(30)     COMMENT 'Reference to product SKU',
    COUNTRY_CODE            VARCHAR(3)      COMMENT 'Country where SKU is available',
    LOCAL_LAUNCH_DATE       DATE            COMMENT 'Country-specific launch date',
    LOCAL_DISCONTINUE_DATE  DATE            COMMENT 'Country-specific discontinue date',
    IS_AVAILABLE            VARCHAR(1)      COMMENT 'Availability status flag (Y/N)',
    CREATED_AT              TIMESTAMP_NTZ   COMMENT 'Record creation timestamp from source',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer product availability by country with local launch dates';


-- =====================================================
-- CUSTOMER_MASTER Table
-- =====================================================
CREATE OR REPLACE TABLE SALES_DEV.BRONZE.CUSTOMER_MASTER (
    CUSTOMER_ID             VARCHAR(50)     COMMENT 'Unique customer UUID identifier',
    CUSTOMER_NUMBER         VARCHAR(20)     COMMENT 'Business customer reference number',
    FIRST_NAME              VARCHAR(100)    COMMENT 'Customer first name',
    LAST_NAME               VARCHAR(100)    COMMENT 'Customer last name',
    FULL_NAME               VARCHAR(200)    COMMENT 'Customer full name',
    GENDER                  VARCHAR(20)     COMMENT 'Customer gender',
    DATE_OF_BIRTH           DATE            COMMENT 'Customer date of birth',
    EMAIL                   VARCHAR(200)    COMMENT 'Customer email address',
    PHONE_NUMBER            VARCHAR(50)     COMMENT 'Customer phone number',
    STREET_ADDRESS          VARCHAR(300)    COMMENT 'Customer street address',
    CITY                    VARCHAR(100)    COMMENT 'Customer city',
    STATE_PROVINCE          VARCHAR(100)    COMMENT 'Customer state or province',
    POSTAL_CODE             VARCHAR(20)     COMMENT 'Customer postal code',
    COUNTRY_CODE            VARCHAR(3)      COMMENT 'Customer country code',
    COUNTRY_NAME            VARCHAR(100)    COMMENT 'Customer country name',
    REGION                  VARCHAR(10)     COMMENT 'Geographic region reference',
    PREFERRED_LANGUAGE      VARCHAR(50)     COMMENT 'Customer preferred language',
    CUSTOMER_SEGMENT        VARCHAR(50)     COMMENT 'Customer segment classification',
    LOYALTY_TIER            VARCHAR(20)     COMMENT 'Customer loyalty program tier',
    REGISTRATION_DATE       DATE            COMMENT 'Date customer registered',
    IS_ACTIVE               BOOLEAN         COMMENT 'Active customer flag',
    SOURCE_SYSTEM           VARCHAR(50)     COMMENT 'Originating source system name',
    RECORD_SOURCE           VARCHAR(50)     COMMENT 'Channel where record originated',
    CREATED_AT              DATE            COMMENT 'Record creation date from source',
    UPDATED_AT              TIMESTAMP_NTZ   COMMENT 'Record last update timestamp',
    __FILE_NAME             VARCHAR(500)    COMMENT 'Source file name from stage',
    __ROW_NUMBER            NUMBER          COMMENT 'Row number within source file',
    __LOAD_TS               TIMESTAMP_NTZ   COMMENT 'Timestamp when record was loaded'
) COMMENT = 'Bronze layer customer master data with demographic and loyalty attributes';


-- =====================================================
-- Data Loading - SALES_ITEM
-- =====================================================-- =====================================================
-- Silver Layer - REGION_MASTER Dynamic Table
-- Deduplication, data quality checks, incremental refresh
-- =====================================================

CREATE OR REPLACE DYNAMIC TABLE SALES_DEV.SILVER.REGION_MASTER
    TARGET_LAG = DOWNSTREAM
    WAREHOUSE = COMPUTE_WH
    REFRESH_MODE = INCREMENTAL
    INITIALIZE = ON_CREATE
    COMMENT = 'Silver layer region master with deduplication and data quality validation'
AS
SELECT
    REGION_CODE,
    REGION_NAME,
    IS_ACTIVE,
    EFFECTIVE_START_DATE,
    EFFECTIVE_END_DATE,
    CREATED_AT,
    SOURCE_SYSTEM,
    
    -- Data Quality Flags
    CASE 
        WHEN REGION_CODE IS NULL THEN FALSE
        WHEN REGION_NAME IS NULL OR TRIM(REGION_NAME) = '' THEN FALSE
        WHEN IS_ACTIVE NOT IN ('Y', 'N') THEN FALSE
        WHEN EFFECTIVE_START_DATE IS NULL THEN FALSE
        WHEN EFFECTIVE_END_DATE < EFFECTIVE_START_DATE THEN FALSE
        ELSE TRUE
    END AS IS_VALID_RECORD,
    
    -- Audit Columns
    __FILE_NAME,
    __ROW_NUMBER AS __SOURCE_ROW_NUMBER,
    __LOAD_TS AS __BRONZE_LOAD_TS

FROM SALES_DEV.BRONZE.REGION_MASTER

-- Deduplication: Keep latest record per REGION_CODE based on load timestamp
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY REGION_CODE 
    ORDER BY __LOAD_TS DESC, __ROW_NUMBER DESC
) = 1;

-- =====================================================
-- Silver Layer - COUNTRY_MASTER Dynamic Table
-- Deduplication, data quality checks, incremental refresh
-- =====================================================

CREATE OR REPLACE DYNAMIC TABLE SALES_DEV.SILVER.COUNTRY_MASTER
    TARGET_LAG = DOWNSTREAM
    WAREHOUSE = COMPUTE_WH
    REFRESH_MODE = INCREMENTAL
    INITIALIZE = ON_CREATE
    COMMENT = 'Silver layer country master with deduplication and data quality validation'
AS
SELECT
    COUNTRY_CODE,
    COUNTRY_NAME,
    REGION_CODE,
    CURRENCY_CODE,
    TAX_CODE,
    PRIMARY_LANGUAGE,
    TIMEZONE,
    ECOMMERCE_SUPPORTED,
    RETAIL_STORE_SUPPORTED,
    MARKET_TIER,
    
    -- Data Quality Flag
    CASE 
        WHEN COUNTRY_CODE IS NULL THEN FALSE
        WHEN COUNTRY_NAME IS NULL OR TRIM(COUNTRY_NAME) = '' THEN FALSE
        WHEN REGION_CODE IS NULL THEN FALSE
        WHEN CURRENCY_CODE IS NULL THEN FALSE
        WHEN ECOMMERCE_SUPPORTED NOT IN ('Y', 'N') THEN FALSE
        WHEN RETAIL_STORE_SUPPORTED NOT IN ('Y', 'N') THEN FALSE
        ELSE TRUE
    END AS IS_VALID_RECORD,
    
    -- Audit Columns
    __FILE_NAME,
    __ROW_NUMBER AS __SOURCE_ROW_NUMBER,
    __LOAD_TS AS __BRONZE_LOAD_TS

FROM SALES_DEV.BRONZE.COUNTRY_MASTER

-- Deduplication: Keep latest record per COUNTRY_CODE
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY COUNTRY_CODE 
    ORDER BY __LOAD_TS DESC, __ROW_NUMBER DESC
) = 1;

-- =====================================================
-- Silver Layer - CURRENCY_MASTER Dynamic Table
-- Deduplication, data quality checks, incremental refresh
-- =====================================================

CREATE OR REPLACE DYNAMIC TABLE SALES_DEV.SILVER.CURRENCY_MASTER
    TARGET_LAG = DOWNSTREAM
    WAREHOUSE = COMPUTE_WH
    REFRESH_MODE = INCREMENTAL
    INITIALIZE = ON_CREATE
    COMMENT = 'Silver layer currency master with deduplication and data quality validation'
AS
SELECT
    CURRENCY_CODE,
    CURRENCY_NAME,
    CURRENCY_SYMBOL,
    MINOR_UNIT,
    IS_ACTIVE,
    EFFECTIVE_START_DATE,
    EFFECTIVE_END_DATE,
    CREATED_AT,
    SOURCE_SYSTEM,
    
    -- Data Quality Flag
    CASE 
        WHEN CURRENCY_CODE IS NULL THEN FALSE
        WHEN CURRENCY_NAME IS NULL OR TRIM(CURRENCY_NAME) = '' THEN FALSE
        WHEN IS_ACTIVE NOT IN ('Y', 'N') THEN FALSE
        WHEN EFFECTIVE_START_DATE IS NULL THEN FALSE
        WHEN EFFECTIVE_END_DATE < EFFECTIVE_START_DATE THEN FALSE
        ELSE TRUE
    END AS IS_VALID_RECORD,
    
    -- Audit Columns
    __FILE_NAME,
    __ROW_NUMBER AS __SOURCE_ROW_NUMBER,
    __LOAD_TS AS __BRONZE_LOAD_TS

FROM SALES_DEV.BRONZE.CURRENCY_MASTER

-- Deduplication: Keep latest record per CURRENCY_CODE
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY CURRENCY_CODE 
    ORDER BY __LOAD_TS DESC, __ROW_NUMBER DESC
) = 1;

-- =====================================================
-- Silver Layer - TAX_MASTER Dynamic Table
-- Deduplication, data quality checks, incremental refresh
-- =====================================================

CREATE OR REPLACE DYNAMIC TABLE SALES_DEV.SILVER.TAX_MASTER
    TARGET_LAG = DOWNSTREAM
    WAREHOUSE = COMPUTE_WH
    REFRESH_MODE = INCREMENTAL
    INITIALIZE = ON_CREATE
    COMMENT = 'Silver layer tax master with deduplication and data quality validation'
AS
SELECT
    TAX_CODE,
    TAX_TYPE,
    TAX_RATE,
    TAX_INCLUSIVE_FLAG,
    EFFECTIVE_START_DATE,
    EFFECTIVE_END_DATE,
    IS_ACTIVE,
    CREATED_AT,
    SOURCE_SYSTEM,
    
    -- Data Quality Flag
    CASE 
        WHEN TAX_CODE IS NULL THEN FALSE
        WHEN TAX_TYPE IS NULL OR TRIM(TAX_TYPE) = '' THEN FALSE
        WHEN TAX_RATE IS NULL OR TAX_RATE < 0 OR TAX_RATE > 1 THEN FALSE
        WHEN TAX_INCLUSIVE_FLAG NOT IN ('Y', 'N') THEN FALSE
        WHEN IS_ACTIVE NOT IN ('Y', 'N') THEN FALSE
        WHEN EFFECTIVE_START_DATE IS NULL THEN FALSE
        WHEN EFFECTIVE_END_DATE < EFFECTIVE_START_DATE THEN FALSE
        ELSE TRUE
    END AS IS_VALID_RECORD,
    
    -- Audit Columns
    __FILE_NAME,
    __ROW_NUMBER AS __SOURCE_ROW_NUMBER,
    __LOAD_TS AS __BRONZE_LOAD_TS

FROM SALES_DEV.BRONZE.TAX_MASTER

-- Deduplication: Keep latest record per TAX_CODE
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY TAX_CODE 
    ORDER BY __LOAD_TS DESC, __ROW_NUMBER DESC
) = 1;