{{ config(materialized='semantic_view') }}

TABLES (
  USAGE AS {{ ref('fct_product_usage_monthly') }}
    PRIMARY KEY (ACCOUNT_ID, USAGE_MONTH)
    WITH SYNONYMS ('product analytics', 'feature usage', 'adoption metrics')
)
DIMENSIONS (
  USAGE.ACCOUNT_ID AS account_id,
  USAGE.ACCOUNT_NAME AS account_name,
  USAGE.COMPANY_TYPE AS company_type
    WITH SYNONYMS = ('segment'),
  USAGE.GEO AS geo
    WITH SYNONYMS = ('region'),
  USAGE.LAST_ACTIVITY_DATE AS last_activity_date,
  USAGE.TIER AS tier,
  USAGE.USAGE_MONTH AS usage_month
    WITH SYNONYMS = ('month', 'period')
)
METRICS (
  USAGE.ACTIVE_USERS AS SUM(active_users)
    WITH SYNONYMS = ('MAU'),
  USAGE.API_EVENTS AS SUM(api_events)
    WITH SYNONYMS = ('API calls'),
  USAGE.FEATURES_WITH_EVENTS AS AVG(features_with_events),
  USAGE.LOGIN_EVENTS AS SUM(login_events)
    WITH SYNONYMS = ('logins'),
  USAGE.REPORT_EVENTS AS SUM(report_events),
  USAGE.TOTAL_API_CALLS AS SUM(total_api_calls),
  USAGE.TOTAL_EVENTS AS SUM(total_events)
    WITH SYNONYMS = ('event count'),
  USAGE.TOTAL_FEATURE_EVENTS AS SUM(total_feature_events),
  USAGE.TOTAL_GB_PROCESSED AS SUM(total_gb_processed)
    WITH SYNONYMS = ('data processed'),
  USAGE.TOTAL_USER_SESSIONS AS SUM(total_user_sessions)
    WITH SYNONYMS = ('sessions'),
  USAGE.UNIQUE_FEATURES_USED AS AVG(unique_features_used)
    WITH SYNONYMS = ('feature breadth'),
  USAGE.AVG_DAYS_SINCE_LAST_LOGIN AS AVG(avg_days_since_last_login),
  USAGE.DORMANT_USERS AS SUM(dormant_users),
  USAGE.ENGAGEMENT_RATE_30D_PCT AS AVG(engagement_rate_30d_pct)
    WITH SYNONYMS = ('engagement rate'),
  USAGE.USERS_ACTIVE_LAST_30D AS SUM(users_active_last_30d)
)
COMMENT='Monthly product usage metrics'

