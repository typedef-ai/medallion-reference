create or replace semantic view sv_product_adoption
	tables (
		USAGE as FCT_PRODUCT_USAGE_MONTHLY primary key (ACCOUNT_ID,USAGE_MONTH) with synonyms=('product analytics','feature usage','adoption metrics')
	)
	dimensions (
		USAGE.ACCOUNT_ID as account_id,
		USAGE.ACCOUNT_NAME as account_name,
		USAGE.COMPANY_TYPE as company_type with synonyms=('segment'),
		USAGE.GEO as geo with synonyms=('region'),
		USAGE.LAST_ACTIVITY_DATE as last_activity_date,
		USAGE.TIER as tier,
		USAGE.USAGE_MONTH as usage_month with synonyms=('month','period')
	)
	metrics (
		USAGE.ACTIVE_USERS as SUM(active_users) with synonyms=('MAU'),
		USAGE.API_EVENTS as SUM(api_events) with synonyms=('API calls'),
		USAGE.FEATURES_WITH_EVENTS as AVG(features_with_events),
		USAGE.LOGIN_EVENTS as SUM(login_events) with synonyms=('logins'),
		USAGE.REPORT_EVENTS as SUM(report_events),
		USAGE.TOTAL_API_CALLS as SUM(total_api_calls),
		USAGE.TOTAL_EVENTS as SUM(total_events) with synonyms=('event count'),
		USAGE.TOTAL_FEATURE_EVENTS as SUM(total_feature_events),
		USAGE.TOTAL_GB_PROCESSED as SUM(total_gb_processed) with synonyms=('data processed'),
		USAGE.TOTAL_USER_SESSIONS as SUM(total_user_sessions) with synonyms=('sessions'),
		USAGE.UNIQUE_FEATURES_USED as AVG(unique_features_used) with synonyms=('feature breadth'),
		USAGE.AVG_DAYS_SINCE_LAST_LOGIN as AVG(avg_days_since_last_login),
		USAGE.DORMANT_USERS as SUM(dormant_users),
		USAGE.ENGAGEMENT_RATE_30D_PCT as AVG(engagement_rate_30d_pct) with synonyms=('engagement rate'),
		USAGE.USERS_ACTIVE_LAST_30D as SUM(users_active_last_30d)
	)
	comment='Monthly product usage metrics';
