create or replace semantic view sv_feature_analytics
	tables (
		FEATURES as MARTS.DIM_FEATURE primary key (FEATURE_NAME) with synonyms=('feature metrics','capability usage')
	)
	dimensions (
		FEATURES.DAYS_IN_USE as days_in_use,
		FEATURES.FEATURE_CATEGORY as feature_category with synonyms=('category'),
		FEATURES.FEATURE_NAME as feature_name with synonyms=('feature'),
		FEATURES.FEATURE_TIER as feature_tier with synonyms=('tier'),
		FEATURES.FIRST_USAGE_DATE as first_usage_date,
		FEATURES.LAST_USAGE_DATE as last_usage_date
	)
	metrics (
		FEATURES.ACCOUNTS_USING_FEATURE as SUM(accounts_using_feature) with synonyms=('account adoption'),
		FEATURES.CUSTOMERS_USING_FEATURE as SUM(customers_using_feature),
		FEATURES.TOTAL_API_CALLS as SUM(total_api_calls),
		FEATURES.TOTAL_EVENTS as SUM(total_events) with synonyms=('usage count'),
		FEATURES.TOTAL_GB_PROCESSED as SUM(total_gb_processed)
	)
	comment='Feature-level analytics showing adoption rates';
