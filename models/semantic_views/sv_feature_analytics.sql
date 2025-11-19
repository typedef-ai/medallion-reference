{{ config(materialized='semantic_view') }}

TABLES (
  FEATURES AS {{ ref('dim_feature') }}
    PRIMARY KEY (FEATURE_NAME)
    WITH SYNONYMS ('feature metrics', 'capability usage')
)
DIMENSIONS (
  FEATURES.DAYS_IN_USE AS days_in_use,
  FEATURES.FEATURE_CATEGORY AS feature_category
    WITH SYNONYMS = ('category'),
  FEATURES.FEATURE_NAME AS feature_name
    WITH SYNONYMS = ('feature'),
  FEATURES.FEATURE_TIER AS feature_tier
    WITH SYNONYMS = ('tier'),
  FEATURES.FIRST_USAGE_DATE AS first_usage_date,
  FEATURES.LAST_USAGE_DATE AS last_usage_date
)
METRICS (
  FEATURES.ACCOUNTS_USING_FEATURE AS SUM(accounts_using_feature)
    WITH SYNONYMS = ('account adoption'),
  FEATURES.CUSTOMERS_USING_FEATURE AS SUM(customers_using_feature),
  FEATURES.TOTAL_API_CALLS AS SUM(total_api_calls),
  FEATURES.TOTAL_EVENTS AS SUM(total_events)
    WITH SYNONYMS = ('usage count'),
  FEATURES.TOTAL_GB_PROCESSED AS SUM(total_gb_processed)
)
COMMENT='Feature-level analytics showing adoption rates'

