# Semantic Layer Query Guide

This guide explains how to query the semantic layer metrics defined in this project.

## Available Semantic Models

### 1. ARR Reporting (`arr_reporting`)

**Dimensions:**

- `metric_time` (time) - Month-end reporting date
- `arr_reporting_period__geo` (categorical) - Geographic region (North America, Europe, Asia Pacific)
- `arr_reporting_period__company_type` (categorical) - Company size (Enterprise, Mid-Market, SMB)
- `arr_reporting_period__tier` (categorical) - Account tier (Tier 1, Tier 2, Tier 3)

**Measures:**

- `ending_arr` - Total ARR at month end
- `net_new_arr` - Net change in ARR
- `new_arr` - ARR from new customers
- `expansion_arr` - ARR from customer growth
- `churn_arr` - ARR lost from churned customers
- `contraction_arr` - ARR lost from shrinking customers

### 2. Pipeline (`pipeline`)

**Dimensions:**

- `metric_time` (time) - Expected close month
- `opportunity__stage_name` (categorical) - Sales stage
- `opportunity__forecast_category` (categorical) - Forecast category
- `opportunity__deal_type` (categorical) - Type of deal

**Measures:**

- `arr` - Annual recurring revenue
- `prob_weighted_arr` - Probability-weighted ARR
- `bookings` - Total bookings value

### 3. Product Usage (`product_usage`)

**Dimensions:**

- `metric_time` (time) - Month of product usage
- `product_usage_period__last_activity_date` (time) - Most recent activity date
- `product_usage_period__account_name` (categorical) - Account name
- `product_usage_period__geo` (categorical) - Geographic region
- `product_usage_period__company_type` (categorical) - Company size
- `product_usage_period__tier` (categorical) - Account tier

**Measures:**

- `total_events` - Total product usage events
- `active_users` - Active users
- `unique_features_used` - Average number of unique features used
- `engagement_rate_30d_pct` - Average 30-day engagement rate
- `total_api_calls` - Total API calls
- `total_gb_processed` - Total gigabytes processed

### 4. Feature Analytics (`feature_analytics`)

**Dimensions:**

- `feature__feature_name` (categorical) - Product feature name
- `feature__feature_category` (categorical) - Product feature category
- `feature__feature_tier` (categorical) - Feature tier
- `feature__first_usage_date` (time) - First feature usage date
- `feature__last_usage_date` (time) - Most recent feature usage date

**Measures:**

- `accounts_using_feature` - Accounts using the feature
- `customers_using_feature` - Customers using the feature
- `feature_total_events` - Total feature usage events
- `feature_total_api_calls` - Total API calls associated with the feature
- `feature_total_gb_processed` - Total gigabytes processed by the feature

### 5. Support Experience (`support_experience`)

**Dimensions:**

- `metric_time` (time) - Month of support activity
- `support_period__account_name` (categorical) - Account name
- `support_period__geo` (categorical) - Geographic region
- `support_period__company_type` (categorical) - Company size
- `support_period__tier` (categorical) - Account tier

**Measures:**

- `total_tickets` - Total support tickets
- `high_priority_tickets` - High priority support tickets
- `avg_resolution_hours` - Average resolution time
- `avg_satisfaction_score` - Average customer satisfaction score
- `satisfaction_rate_pct` - Average satisfaction rate
- `tickets_per_1k_arr` - Average ticket intensity per $1,000 ARR

### 6. Customer Health (`customer_health`)

**Dimensions:**

- `metric_time` (time) - Month of health score calculation
- `customer_health_period__account_name` (categorical) - Account name
- `customer_health_period__geo` (categorical) - Geographic region
- `customer_health_period__company_type` (categorical) - Company size
- `customer_health_period__tier` (categorical) - Account tier
- `customer_health_period__health_tier` (categorical) - Health status

**Measures:**

- `total_health_score` - Average overall customer health score
- `financial_health_score` - Average financial health component
- `usage_health_score` - Average usage health component
- `support_health_score` - Average support health component
- `health_arr` - Total ARR for health-scored accounts
- `health_total_tickets` - Total support tickets for health-scored accounts

## Query Methods

### Method 1: MetricFlow CLI (Recommended for Development)

**Installation:**

```bash
pip install dbt-metricflow
```

**List available metrics:**

```bash
mf list metrics
```

**List dimensions for a metric:**

```bash
mf list dimensions --metrics ending_arr
```

**Query examples:**

```bash
# Total ending ARR by month
mf query --metrics ending_arr --group-by metric_time

# ARR metrics by geography
mf query --metrics ending_arr,new_arr,churn_arr --group-by arr_reporting_period__geo

# ARR trends with filtering
mf query --metrics ending_arr,net_new_arr \
  --group-by metric_time,arr_reporting_period__company_type \
  --where "{{ Dimension('arr_reporting_period__company_type') }} = 'Enterprise'" \
  --order metric_time

# Pipeline by stage
mf query --metrics prob_weighted_arr --group-by opportunity__stage_name

# Pipeline by close month and forecast category
mf query --metrics arr,prob_weighted_arr \
  --group-by metric_time,opportunity__forecast_category \
  --order metric_time

# Product engagement by month and geography
mf query --metrics total_events,active_users,engagement_rate_30d_pct \
  --group-by metric_time,product_usage_period__geo \
  --order metric_time

# Support burden by month and customer segment
mf query --metrics total_tickets,avg_satisfaction_score,tickets_per_1k_arr \
  --group-by metric_time,support_period__company_type \
  --order metric_time

# Customer health by tier
mf query --metrics total_health_score,health_arr \
  --group-by metric_time,customer_health_period__health_tier \
  --order metric_time
```

### Method 2: Direct SQL Queries

Query the underlying fact tables directly in DuckDB:

**ARR Queries:**

```sql
-- Monthly ARR trends
SELECT
    month_end,
    SUM(month_ending_arr) as total_arr,
    SUM(net_new_arr) as net_new,
    SUM(new_arr) as new,
    SUM(expansion_arr) as expansion,
    SUM(churn_arr) as churn
FROM main_marts.fct_arr_reporting_monthly
GROUP BY month_end
ORDER BY month_end;

-- ARR by geography
SELECT
    geo,
    SUM(month_ending_arr) as total_arr,
    SUM(new_arr) as new_arr,
    SUM(expansion_arr) as expansion_arr
FROM main_marts.fct_arr_reporting_monthly
WHERE month_end = (SELECT MAX(month_end) FROM main_marts.fct_arr_reporting_monthly)
GROUP BY geo;

-- Enterprise customer ARR trends
SELECT
    month_end,
    company_type,
    tier,
    SUM(month_ending_arr) as arr,
    SUM(net_new_arr) as net_new
FROM main_marts.fct_arr_reporting_monthly
WHERE company_type = 'Enterprise'
GROUP BY month_end, company_type, tier
ORDER BY month_end, tier;
```

**Pipeline Queries:**

```sql
-- Pipeline by stage
SELECT
    stage_name,
    COUNT(*) as deal_count,
    SUM(arr) as total_arr,
    SUM(prob_weighted_arr) as weighted_arr
FROM main_marts.fct_pipeline
GROUP BY stage_name;

-- Pipeline by forecast category and close month
SELECT
    close_month,
    forecast_category,
    SUM(prob_weighted_arr) as weighted_pipeline
FROM main_marts.fct_pipeline
WHERE close_month >= CURRENT_DATE
GROUP BY close_month, forecast_category
ORDER BY close_month;

-- Deal breakdown by type
SELECT
    deal_type,
    COUNT(*) as count,
    AVG(arr) as avg_arr,
    SUM(prob_weighted_arr) as total_weighted
FROM main_marts.fct_pipeline
GROUP BY deal_type;
```

### Method 3: Using Python with DuckDB

```python
import duckdb

# Connect to the database
conn = duckdb.connect('demo.duckdb')

# Query ARR metrics
arr_query = """
SELECT
    month_end,
    geo,
    SUM(month_ending_arr) as total_arr,
    SUM(net_new_arr) as net_new_arr
FROM main_marts.fct_arr_reporting_monthly
GROUP BY month_end, geo
ORDER BY month_end, geo
"""
df = conn.execute(arr_query).fetchdf()
print(df)

# Query pipeline metrics
pipeline_query = """
SELECT
    stage_name,
    forecast_category,
    SUM(prob_weighted_arr) as weighted_pipeline
FROM main_marts.fct_pipeline
GROUP BY stage_name, forecast_category
"""
df_pipeline = conn.execute(pipeline_query).fetchdf()
print(df_pipeline)

conn.close()
```

### Method 4: Integration with BI Tools (Production)

For production use, the semantic layer can integrate with:

1. **dbt Cloud Semantic Layer** - Enterprise feature that exposes metrics via API
2. **BI Tool Direct Connection** - Connect Tableau, Power BI, Looker, etc. directly to DuckDB
3. **Reverse ETL** - Sync metrics to operational tools

Example BI tool connection:

- **Connection Type:** DuckDB
- **Database Path:** `/path/to/demo_finance/demo.duckdb`
- **Schema:** `main_marts`
- **Tables:** `fct_arr_reporting_monthly`, `fct_pipeline`

## Common Query Patterns

### Year-over-Year ARR Growth

```sql
WITH current_month AS (
    SELECT SUM(month_ending_arr) as arr
    FROM main_marts.fct_arr_reporting_monthly
    WHERE month_end = '2024-12-31'
),
previous_year AS (
    SELECT SUM(month_ending_arr) as arr
    FROM main_marts.fct_arr_reporting_monthly
    WHERE month_end = '2023-12-31'
)
SELECT
    current_month.arr as current_arr,
    previous_year.arr as previous_arr,
    (current_month.arr - previous_year.arr) / previous_year.arr * 100 as yoy_growth_pct
FROM current_month, previous_year;
```

### ARR Retention Rate

```sql
WITH monthly_cohorts AS (
    SELECT
        month_end,
        SUM(month_ending_arr) as total_arr,
        SUM(churn_arr) as churned_arr,
        SUM(contraction_arr) as contracted_arr
    FROM main_marts.fct_arr_reporting_monthly
    GROUP BY month_end
)
SELECT
    month_end,
    total_arr,
    (total_arr + churned_arr + contracted_arr) / total_arr * 100 as retention_rate_pct
FROM monthly_cohorts
ORDER BY month_end;
```

### Pipeline Coverage

```sql
SELECT
    close_month,
    SUM(CASE WHEN forecast_category = 'Commit' THEN prob_weighted_arr ELSE 0 END) as commit,
    SUM(CASE WHEN forecast_category = 'Best Case' THEN prob_weighted_arr ELSE 0 END) as best_case,
    SUM(CASE WHEN forecast_category = 'Pipeline' THEN prob_weighted_arr ELSE 0 END) as pipeline,
    SUM(prob_weighted_arr) as total_pipeline
FROM main_marts.fct_pipeline
GROUP BY close_month
ORDER BY close_month;
```

## Troubleshooting

**MetricFlow CLI not finding profile:**

- Ensure `~/.dbt/profiles.yml` exists with the `demo_finance` profile
- Try running from the `demo_finance/` directory
- Check that dbt can find the profile: `dbt debug`

**Empty results:**

- Verify data was loaded: `dbt run`
- Check the date ranges in your queries match the seed data (2024-2026)
- Ensure you're querying the correct schema: `main_marts`

**Performance issues:**

- The ARR intermediate tables are materialized for performance
- Consider adding indexes on date columns for large datasets
- Use `LIMIT` for exploratory queries
