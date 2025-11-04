# Demo Finance - dbt Project

A dbt project for SaaS financial analytics, processing Salesforce and Stripe data to produce ARR reporting and sales pipeline analytics.

## Project Structure

```
demo_finance/
├── dbt_project.yml             # dbt configuration
├── packages.yml                # dbt dependencies
│
├── seeds/                      # Sample data (CSV files)
│   ├── sfdc_account.csv        # 20 Salesforce accounts
│   ├── sfdc_opportunity.csv    # 25 opportunities
│   ├── sfdc_opportunitylineitem.csv  # 30 line items
│   ├── stripe_subscriptions.csv      # 16 subscriptions
│   └── stripe_invoices.csv           # 40 invoices
│
├── models/                     # dbt transformation models
│   ├── staging/                # Data normalization layer
│   │   ├── sfdc/              # Salesforce staging models
│   │   ├── stripe/            # Stripe staging models
│   │   └── util/              # Utility tables (date spine)
│   │
│   ├── intermediate/           # Business logic layer
│   │   ├── arr/               # ARR calculations (daily expansion)
│   │   ├── pipeline/          # Pipeline transformations
│   │   └── billing/           # Billing aggregations
│   │
│   └── marts/                  # Analytics layer (final tables)
│       └── finance/
│           ├── fct_arr_reporting_monthly.sql  # Monthly ARR facts
│           ├── fct_pipeline.sql               # Pipeline facts
│           └── dim_account.sql                # Account dimension
│
├── macros/                     # Custom dbt macros
│   ├── cross_db_utils.sql      # Cross-database compatibility
│   └── generate_schema_name.sql # Schema naming conventions
│
├── semantic_views/             # Snowflake Semantic View DDL
│   ├── sv_arr_reporting.sql
│   └── sv_pipeline.sql
│
└── tests/                      # Data quality tests (21 tests)
```

## Setup

### Prerequisites

- Python 3.10+
- [uv](https://docs.astral.sh/uv/) package manager
- Snowflake account with JWT authentication configured

### Configuration

Configure Snowflake connection in `.env` at repository root:

```bash
SNOWFLAKE_USER=your_username
SNOWFLAKE_ACCOUNT=your_account_identifier
SNOWFLAKE_PRIVATE_KEY_PATH=/path/to/snowflake_key.p8
SNOWFLAKE_WAREHOUSE=TD_WH
SNOWFLAKE_ROLE=SYSADMIN
SNOWFLAKE_DATABASE=DEMO_AGENTS
SNOWFLAKE_SCHEMA=PUBLIC
```

### Regenerate Seed Data (Optional)

The project includes a synthetic data generation framework for creating realistic seed data. This is useful for:

- Refreshing data with updated date ranges
- Adjusting data volume or distribution
- Experimenting with different scenarios

**To regenerate all seed files:**

```bash
cd dbt_projects/medallion-reference
uv sync  # Ensure dependencies are installed
uv run python scripts/generate_seeds.py
```

This will regenerate all 10 seed files with data spanning:

- **Historical:** January 2022 - October 2025 (46 months of actual data)
- **Pipeline:** November 2025 - June 2026 (8 months forward-looking)

See `DATA_SUMMARY.md` for detailed information about the generated data.

**Configuration:**

To customize date ranges or data volumes, edit `scripts/generators/utils.py`:

- `START_DATE`, `END_DATE`, `PIPELINE_END_DATE` - Date range configuration
- Modify `generate_seeds.py` for account counts and growth parameters

### Load Data and Build Models

```bash
cd dbt_projects/medallion-reference
uv run dbt seed    # Load CSV data
uv run dbt run     # Build all models
uv run dbt test    # Run data quality tests
```

### Create Semantic Views

After building models, run the semantic view DDL scripts in `semantic_views/`:

```bash
# In Snowflake, execute:
# - semantic_views/sv_arr_reporting.sql
# - semantic_views/sv_pipeline.sql
```

## Running dbt Commands

Always use `uv run dbt` from the `demo_finance` directory:

```bash
# Run all models
uv run dbt run

# Run specific model
uv run dbt run --select fct_arr_reporting_monthly

# Run tests
uv run dbt test

# List models
uv run dbt ls --select path:models/

# Show dependencies
uv run dbt ls --select +fct_arr_reporting_monthly  # Upstream
uv run dbt ls --select fct_arr_reporting_monthly+  # Downstream
```

## Data Pipeline Layers

### Staging

Normalized raw data from Salesforce and Stripe with minimal transformations.

### Intermediate

Business logic including:

- Daily ARR calculations with expansion tracking
- Pipeline snapshots and stage transitions
- Billing aggregations

### Marts

Analytics-ready fact and dimension tables:

- `fct_arr_reporting_monthly` - Monthly ARR metrics by account
- `fct_pipeline` - Sales pipeline facts with stage history
- `dim_account` - Account dimension table

## Data Quality

21 automated tests covering:

- Primary key uniqueness
- Foreign key relationships
- Accepted values for categorical fields
- Not-null constraints on critical columns

## Resetting State

Clean up artifacts:

```bash
# Reset local artifacts only
./scripts/reset_demo.sh

# Full reset including Snowflake objects
./scripts/reset_demo.sh --full
```

## Results

- 16 dbt models
- 5+ Snowflake Semantic Views
- 21 data quality tests
- **383,000+ rows of synthetic data** spanning 46 months (Jan 2022 - Oct 2025)
  - 200 accounts
  - 670 opportunities (590 closed + 80 pipeline)
  - 438 subscriptions
  - 356K+ usage events
  - 21K+ user licenses
  - See `DATA_SUMMARY.md` for complete breakdown
