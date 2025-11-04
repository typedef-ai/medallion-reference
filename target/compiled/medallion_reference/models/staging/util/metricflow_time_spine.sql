

-- MetricFlow time spine - required for dbt semantic layer
-- Uses the same date range as util__dates
SELECT
    date_day as date_day
FROM DEMO_AGENTS_DAVID.staging.util__dates