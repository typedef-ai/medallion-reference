{{ config(materialized='semantic_view') }}

TABLES (
  SUPPORT AS {{ ref('fct_support_metrics_monthly') }}
    PRIMARY KEY (ACCOUNT_ID, MONTH)
    WITH SYNONYMS ('customer support', 'help desk metrics')
)
DIMENSIONS (
  SUPPORT.ACCOUNT_ID AS account_id,
  SUPPORT.ACCOUNT_NAME AS account_name,
  SUPPORT.COMPANY_TYPE AS company_type
    WITH SYNONYMS = ('segment'),
  SUPPORT.GEO AS geo,
  SUPPORT.MONTH AS month,
  SUPPORT.TIER AS tier
)
METRICS (
  SUPPORT.HIGH_PRIORITY_TICKETS AS SUM(high_priority_tickets)
    WITH SYNONYMS = ('urgent tickets'),
  SUPPORT.LOW_PRIORITY_TICKETS AS SUM(low_priority_tickets),
  SUPPORT.MEDIUM_PRIORITY_TICKETS AS SUM(medium_priority_tickets),
  SUPPORT.TOTAL_TICKETS AS SUM(total_tickets)
    WITH SYNONYMS = ('ticket volume'),
  SUPPORT.AVG_RESOLUTION_HOURS AS AVG(avg_resolution_hours)
    WITH SYNONYMS = ('resolution time'),
  SUPPORT.AVG_SATISFACTION_SCORE AS AVG(avg_satisfaction_score)
    WITH SYNONYMS = ('CSAT'),
  SUPPORT.BILLING_TICKETS AS SUM(billing_tickets),
  SUPPORT.BUG_TICKETS AS SUM(bug_tickets)
    WITH SYNONYMS = ('defect tickets'),
  SUPPORT.DISSATISFIED_TICKETS AS SUM(dissatisfied_tickets),
  SUPPORT.FEATURE_REQUEST_TICKETS AS SUM(feature_request_tickets)
    WITH SYNONYMS = ('enhancement requests'),
  SUPPORT.HIGH_PRIORITY_RATE_PCT AS AVG(high_priority_rate_pct),
  SUPPORT.SATISFACTION_RATE_PCT AS AVG(satisfaction_rate_pct),
  SUPPORT.SATISFIED_TICKETS AS SUM(satisfied_tickets),
  SUPPORT.TICKETS_PER_1K_ARR AS AVG(tickets_per_1k_arr)
    WITH SYNONYMS = ('ticket intensity'),
  SUPPORT.TRAINING_TICKETS AS SUM(training_tickets)
)
COMMENT='Support ticket metrics and customer satisfaction tracking'

