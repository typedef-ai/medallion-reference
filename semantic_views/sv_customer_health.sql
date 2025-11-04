create or replace semantic view sv_customer_health
	tables (
		HEALTH as MARTS.FCT_CUSTOMER_HEALTH_SCORE primary key (ACCOUNT_ID,MONTH) with synonyms=('customer success','account health','customer wellness')
	)
	dimensions (
		HEALTH.ACCOUNT_ID as account_id,
		HEALTH.ACCOUNT_NAME as account_name,
		HEALTH.COMPANY_TYPE as company_type with synonyms=('segment','customer type'),
		HEALTH.GEO as geo,
		HEALTH.HEALTH_TIER as health_tier with synonyms=('health status','risk level'),
		HEALTH.MONTH as month comment='Month of health score calculation',
		HEALTH.TIER as tier
	)
	metrics (
		HEALTH.FINANCIAL_HEALTH_SCORE as AVG(financial_health_score),
		HEALTH.TOTAL_HEALTH_SCORE as AVG(total_health_score) with synonyms=('health score'),
		HEALTH.USAGE_HEALTH_SCORE as AVG(usage_health_score),
		HEALTH.ACTIVE_USERS as SUM(active_users),
		HEALTH.ARR as SUM(arr),
		HEALTH.ARR_CHANGE as SUM(arr_change),
		HEALTH.AVG_SATISFACTION_SCORE as AVG(avg_satisfaction_score),
		HEALTH.DORMANT_USERS as SUM(dormant_users),
		HEALTH.ENGAGEMENT_RATE_30D_PCT as AVG(engagement_rate_30d_pct),
		HEALTH.SUPPORT_HEALTH_SCORE as AVG(support_health_score),
		HEALTH.TOTAL_EVENTS as SUM(total_events),
		HEALTH.TOTAL_TICKETS as SUM(total_tickets)
	)
	comment='Customer health metrics';