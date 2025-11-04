# New Models Added to demo_finance

This document describes the new models added to enhance product analytics, customer success, and support capabilities.

## Overview

We've added comprehensive models across three key areas:

1. **Product Analytics** - Usage patterns, feature adoption, user engagement
2. **Support Metrics** - Ticket volumes, resolution times, satisfaction scores
3. **Customer Health** - Unified health scoring combining financial, usage, and support signals

## Data Sources (New Seeds)

- `product_usage_events.csv` - Detailed product usage events with features, users, and resource consumption
- `support_tickets.csv` - Support ticket data with resolution times and satisfaction scores
- `user_licenses.csv` - User license information with roles and activity dates

## Model Architecture

### Staging Layer

**Product Staging (`models/staging/product/`)**

- `stg_product__usage_events` - Cleaned usage events
- `stg_product__user_licenses` - Cleaned user license data

**Support Staging (`models/staging/support/`)**

- `stg_support__tickets` - Cleaned support ticket data

### Intermediate Layer

**Product Health (`models/intermediate/product/`)**

- `int_product__monthly_usage` - Monthly aggregated usage metrics by account
- `int_product__feature_adoption` - Feature-level adoption and penetration rates

**Customer Success (`models/intermediate/customer_success/`)**

- `int_cs__user_engagement` - User engagement metrics including dormancy and activity rates

**Support (`models/intermediate/support/`)**

- `int_support__monthly_metrics` - Monthly support ticket aggregations with satisfaction rates

### Marts Layer

**Product Marts (`models/marts/product/`)**

- `fct_product_usage_monthly` - **Fact table** for product usage analysis
  - **Grain**: One row per account per month
  - **Measures**: Event counts, GB processed, API calls, feature usage, engagement rates
  - **Dimensions**: Account, customer, month, industry, segment

- `dim_feature` - **Dimension table** for product features
  - **Grain**: One row per feature
  - **Attributes**: Feature category, tier, usage stats, adoption metrics

**Support Marts (`models/marts/support/`)**

- `fct_support_metrics_monthly` - **Fact table** for support analysis
  - **Grain**: One row per account per month
  - **Measures**: Ticket volumes by priority/category, resolution times, satisfaction scores
  - **Dimensions**: Account, customer, month, industry, segment
  - **Derived Metrics**: Tickets per $1K ARR, satisfaction rate %

**Customer Success Marts (`models/marts/customer_success/`)**

- `fct_customer_health_score` - **Fact table** for customer health monitoring
  - **Grain**: One row per account per month
  - **Scoring Model**:
    - Financial Health (30 points): Based on ARR growth
    - Usage Health (40 points): Based on engagement rate
    - Support Health (30 points): Based on satisfaction and ticket priority
  - **Health Tiers**:
    - Healthy: 80+ points
    - At Risk: 60-79 points
    - Critical: <60 points
  - **Measures**: Health scores, ARR metrics, usage metrics, support metrics
  - **Dimensions**: Account, customer, month, health tier, industry, segment

## Key Use Cases

### Product Analytics

```sql
-- Find most adopted features by enterprise accounts
SELECT
    feature_name,
    COUNT(DISTINCT account_id) as enterprise_accounts,
    SUM(total_events) as total_usage
FROM fct_product_usage_monthly u
JOIN dim_feature f USING (feature_name)
JOIN dim_account a USING (account_id)
WHERE a.segment = 'Enterprise'
GROUP BY 1
ORDER BY 2 DESC;
```

### Customer Health Monitoring

```sql
-- Identify at-risk customers with declining health
SELECT
    account_name,
    health_tier,
    total_health_score,
    arr_change,
    engagement_rate_30d_pct,
    avg_satisfaction_score
FROM fct_customer_health_score
WHERE health_tier IN ('At Risk', 'Critical')
    AND arr_change < 0
ORDER BY total_health_score ASC;
```

### Support Analysis

```sql
-- Find accounts with high support burden
SELECT
    account_name,
    current_arr,
    total_tickets,
    tickets_per_1k_arr,
    avg_satisfaction_score
FROM fct_support_metrics_monthly
WHERE tickets_per_1k_arr > 5
ORDER BY tickets_per_1k_arr DESC;
```

## Semantic Analysis Notes

These models are designed with clear business semantics:

- **Grain**: Explicitly defined for each fact table (account × month)
- **Measures**: Quantitative metrics that can be aggregated (counts, sums, averages, rates)
- **Dimensions**: Categorical attributes for filtering and grouping
- **Relationships**: Models join naturally via account_id, customer_id, and month/date fields

This makes them ideal for:

- BI tool integration
- Semantic layer definitions
- AI-powered analysis via the lineage agent
- Data quality monitoring

## Testing

All staging models include:

- Uniqueness tests on primary keys
- Not null tests on key fields
- Referential integrity via foreign keys

Run tests with:

```bash
just dbt-test
```
