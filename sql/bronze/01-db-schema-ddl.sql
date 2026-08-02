-- DDL for Snowflake medallion architecture: DEV (transient), QA (transient), PROD (7-day time travel)
-- Co-authored with CoCo

/*
=============================================================
  Snowflake Cloud Data Platform - Medallion Architecture DDL
  Databases: SALES_DEV, SALES_QA, SALES_PROD
  Schemas:   BRONZE, SILVER, GOLD, COMMON
=============================================================
*/

-- =========================================================
-- 1. SALES_DEV (Transient - no fail-safe, no time travel)
-- =========================================================
CREATE OR REPLACE TRANSIENT DATABASE SALES_DEV
    COMMENT = 'Development environment - transient, no fail-safe';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_DEV.BRONZE
    COMMENT = 'Raw/landing zone - source data ingested as-is';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_DEV.SILVER
    COMMENT = 'Cleansed & curated - deduplicated, conformed, SCD applied';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_DEV.GOLD
    COMMENT = 'Business-ready aggregations and reporting layer';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_DEV.COMMON
    COMMENT = 'Shared utilities, functions, and stored procedures';

-- =========================================================
-- 2. SALES_QA (Transient - no fail-safe, no time travel)
-- =========================================================
CREATE OR REPLACE TRANSIENT DATABASE SALES_QA
    COMMENT = 'QA/Testing environment - transient, no fail-safe';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_QA.BRONZE
    COMMENT = 'Raw/landing zone - source data ingested as-is';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_QA.SILVER
    COMMENT = 'Cleansed & curated - deduplicated, conformed, SCD applied';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_QA.GOLD
    COMMENT = 'Business-ready aggregations and reporting layer';

CREATE OR REPLACE TRANSIENT SCHEMA SALES_QA.COMMON
    COMMENT = 'Shared utilities, functions, and stored procedures';

-- =========================================================
-- 3. SALES_PROD (Permanent - 7 days time travel)
-- =========================================================
CREATE OR REPLACE DATABASE SALES_PROD
    DATA_RETENTION_TIME_IN_DAYS = 7
    COMMENT = 'Production environment - 7-day time travel for data recovery';

CREATE OR REPLACE SCHEMA SALES_PROD.BRONZE
    DATA_RETENTION_TIME_IN_DAYS = 7
    COMMENT = 'Raw/landing zone - source data ingested as-is';

CREATE OR REPLACE SCHEMA SALES_PROD.SILVER
    DATA_RETENTION_TIME_IN_DAYS = 7
    COMMENT = 'Cleansed & curated - deduplicated, conformed, SCD applied';

CREATE OR REPLACE SCHEMA SALES_PROD.GOLD
    DATA_RETENTION_TIME_IN_DAYS = 7
    COMMENT = 'Business-ready aggregations and reporting layer';

CREATE OR REPLACE SCHEMA SALES_PROD.COMMON
    DATA_RETENTION_TIME_IN_DAYS = 7
    COMMENT = 'Shared utilities, functions, and stored procedures';
