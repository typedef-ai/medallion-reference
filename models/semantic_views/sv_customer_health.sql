{{ config(materialized='semantic_view') }}

TABLES (
  HEALTH AS {{ ref('fct_customer_health_score') }}
    PRIMARY KEY (ACCOUNT_ID, MONTH)
    WITH SYNONYMS ('customer success', 'account health', 'customer wellness')
)
DIMENSIONS (
  HEALTH.ACCOUNT_ID AS account_id,
  HEALTH.ACCOUNT_NAME AS account_name,
  HEALTH.COMPANY_TYPE AS company_type
    WITH SYNONYMS = ('segment', 'customer type'),
  HEALTH.GEO AS geo,
  HEALTH.HEALTH_TIER AS health_tier
    WITH SYNONYMS = ('health status', 'risk level'),
  HEALTH.MONTH AS month
    COMMENT = 'Month of health score calculation',
  HEALTH.TIER AS tier
)
METRICS (
  HEALTH.FINANCIAL_HEALTH_SCORE AS AVG(financial_health_score),
  HEALTH.TOTAL_HEALTH_SCORE AS AVG(total_health_score)
    WITH SYNONYMS = ('health score'),
  HEALTH.USAGE_HEALTH_SCORE AS AVG(usage_health_score),
  HEALTH.ACTIVE_USERS AS SUM(active_users),
  HEALTH.ARR AS SUM(arr),
  HEALTH.ARR_CHANGE AS SUM(arr_change),
  HEALTH.AVG_SATISFACTION_SCORE AS AVG(avg_satisfaction_score),
  HEALTH.DORMANT_USERS AS SUM(dormant_users),
  HEALTH.ENGAGEMENT_RATE_30D_PCT AS AVG(engagement_rate_30d_pct),
  HEALTH.SUPPORT_HEALTH_SCORE AS AVG(support_health_score),
  HEALTH.TOTAL_EVENTS AS SUM(total_events),
  HEALTH.TOTAL_TICKETS AS SUM(total_tickets)
)
COMMENT='Customer health metrics'

