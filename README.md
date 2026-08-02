# Snowflake Data Pipeline

End-to-end sales data pipeline built on Snowflake using the Medallion Architecture (Bronze → Silver → Gold) with Dynamic Tables, Cortex Analyst, and automated scheduling.

## Architecture

```
Bronze (Raw)  →  Silver (Cleansed)  →  Gold (Dimensional Model)
   ↓                    ↓                       ↓
CSV Ingestion     Master Tables         Star Schema + Semantic View
via Stages        with Validation       for Analytics & Cortex Analyst
```

## Project Structure

```
snowflake-data-pipeline/
├── sql/
│   ├── bronze/         — Database setup, stages, and raw data loading
│   ├── silver/         — Cleansed master tables (country, product, store, customer, sales)
│   ├── gold/           — Dimensions, facts, aggregations, constraints, semantic model
│   └── ops/            — Task automation and scheduling
├── data/               — CSV source files for data loading
└── README.md
```

## SQL Scripts (Execution Order)

### Bronze Layer
| # | File | Description |
|---|------|-------------|
| 01 | `01-db-schema-ddl.sql` | Database, schemas, and warehouse setup |
| 02 | `02-stage-data-loading-ddl.sql` | Internal stages and raw data ingestion |

### Silver Layer
| # | File | Description |
|---|------|-------------|
| 03 | `03-country-master-silver.sql` | Country, region, currency, tax masters |
| 04 | `04-product-sku-master.sql` | Product hierarchy (Category → Family → Model → SKU) |
| 05 | `05-store-master.sql` | Store master with location attributes |
| 06 | `06-customer-master.sql` | Customer master with demographics |
| 07 | `07-sales-header-item.sql` | Sales transaction header and line items |

### Gold Layer
| # | File | Description |
|---|------|-------------|
| 08 | `08-country-dim.sql` | DIM_COUNTRY (SCD2) — geography, currency, tax |
| 09 | `09-product-dim.sql` | DIM_PRODUCT (SCD2) — full product hierarchy |
| 10 | `10-store-dim.sql` | DIM_STORE (SCD2) — location and operations |
| 11 | `11-customer-dim.sql` | DIM_CUSTOMER (SCD2) — demographics and loyalty |
| 12 | `12-sales-fact.sql` | FACT_SALES_HEADER + FACT_SALES_ITEM |
| 13 | `13-agg-fact.sql` | Aggregated facts (daily, weekly, monthly) |
| 14 | `14-fact-dim-relation.sql` | Primary key and foreign key constraints |
| 15 | `15-talk-to-your-data.sql` | Cortex Analyst semantic view deployment |

### Operations
| # | File | Description |
|---|------|-------------|
| 16 | `16-task-to-automate-data-loading.sql` | Snowflake Tasks for automated refresh |

## Key Features

- **Dynamic Tables** — Incremental refresh with `TARGET_LAG` for near real-time updates
- **Star Schema** — Fact and dimension tables with hash-based surrogate keys
- **SCD Type 2** — Historical tracking on all dimension tables
- **Cortex Analyst** — Semantic view with 14 metrics and 8 verified queries for natural language analytics
- **Task Automation** — Scheduled pipeline orchestration

## Snowflake Objects

| Layer | Database.Schema |
|-------|----------------|
| Bronze | `SALES_DEV.BRONZE` |
| Silver | `SALES_DEV.SILVER` |
| Gold | `SALES_DEV.GOLD` |
| Semantic View | `SALES_DEV.GOLD.SALES_ANALYTICS` |

## Getting Started

1. Run scripts in order (01 → 16)
2. Upload CSV files to the `data/` folder, then load via stages
3. Dynamic tables auto-refresh downstream once base tables are populated
4. Query your data with natural language via Cortex Analyst using the semantic view
