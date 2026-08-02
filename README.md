# Snowflake Data Pipeline

Sales data pipeline on Snowflake using Medallion Architecture (Bronze → Silver → Gold) with two implementations: native SQL and dbt.

## Project Structure

```
snowflake-data-pipeline/
├── sql/
│   ├── bronze/     — Database setup, stages, tables (01-02), data loading (03)
│   ├── silver/     — Cleansed master tables (04-08)
│   ├── gold/       — Dimensions, facts, constraints, semantic model (09-16)
│   └── ops/        — Task automation (17)
├── dbt/
│   ├── models/
│   │   ├── staging/    — Source cleansing (stg_* models)
│   │   └── marts/      — dimensions/ and facts/
│   ├── dbt_project.yml
│   └── profiles.yml
├── data/           — CSV source files (initial + delta loads)
└── README.md
```

## SQL Scripts (run in order: 01 → 17)

| Layer | Scripts | What They Do |
|-------|---------|--------------|
| Bronze | 01 | Database, schemas, warehouse setup |
| Bronze | 02 | Internal stages, file formats, bronze table DDL |
| Bronze | **03** | **Initial data load** (COPY INTO) — run AFTER uploading CSVs |
| Silver | 04-08 | Country, product, store, customer, sales masters |
| Gold | 09-16 | SCD2 dimensions, fact tables, aggregations, PK/FK, semantic view |
| Ops | 17 | Snowflake Tasks for automated refresh |

## dbt Project (same pipeline as SQL, with testing & lineage)

| Layer | Models | What They Do |
|-------|--------|--------------|
| Staging | 12 stg_* models | Source cleansing with validation |
| Marts | 5 dimensions + 4 facts | Star schema with unique/not_null tests |

```bash
dbt build    # Run + test all models in dependency order
```

## Key Features

- **Dynamic Tables** with incremental refresh via `TARGET_LAG`
- **Star Schema** with hash-based surrogate keys and SCD Type 2
- **Cortex Analyst** semantic view (14 metrics, 8 verified queries)
- **Task Automation** for scheduled pipeline orchestration
- **dbt Testing** with source and model-level constraints

## Snowflake Objects

| Layer | Location |
|-------|----------|
| Bronze | `SALES_DEV.BRONZE` |
| Silver | `SALES_DEV.SILVER` |
| Gold / dbt target | `SALES_DEV.GOLD` |
| Semantic View | `SALES_DEV.GOLD.SALES_ANALYTICS` |

## Getting Started

### Phase 1: Infrastructure Setup
1. Run script `01` — creates database, schemas, warehouse
2. Run script `02` — creates internal stages, file formats, bronze tables

### Phase 2: Initial Full Load (end-to-end test)
3. Upload **initial CSV files** to `data/` folder → PUT into internal stages
4. Run script `03` — loads all CSVs into bronze tables
5. Run scripts `04-16` — Dynamic Tables auto-build silver → gold layers
6. Verify end-to-end: query `SALES_DEV.GOLD.SALES_ANALYTICS` via Cortex Analyst

### Phase 3: Delta / Incremental Load
7. Upload **new/changed CSV files** to stages (simulates production delta)
8. Run script `17` (Tasks) — triggers incremental refresh via streams + Dynamic Tables
9. Verify delta records flow through silver → gold automatically
