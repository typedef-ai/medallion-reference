create or replace semantic view sv_support_experience
	tables (
		SUPPORT as FCT_SUPPORT_METRICS_MONTHLY primary key (ACCOUNT_ID,MONTH) with synonyms=('customer support','help desk metrics')
	)
	dimensions (
		SUPPORT.ACCOUNT_ID as account_id,
		SUPPORT.ACCOUNT_NAME as account_name,
		SUPPORT.COMPANY_TYPE as company_type with synonyms=('segment'),
		SUPPORT.GEO as geo,
		SUPPORT.MONTH as month,
		SUPPORT.TIER as tier
	)
	metrics (
		SUPPORT.HIGH_PRIORITY_TICKETS as SUM(high_priority_tickets) with synonyms=('urgent tickets'),
		SUPPORT.LOW_PRIORITY_TICKETS as SUM(low_priority_tickets),
		SUPPORT.MEDIUM_PRIORITY_TICKETS as SUM(medium_priority_tickets),
		SUPPORT.TOTAL_TICKETS as SUM(total_tickets) with synonyms=('ticket volume'),
		SUPPORT.AVG_RESOLUTION_HOURS as AVG(avg_resolution_hours) with synonyms=('resolution time'),
		SUPPORT.AVG_SATISFACTION_SCORE as AVG(avg_satisfaction_score) with synonyms=('CSAT'),
		SUPPORT.BILLING_TICKETS as SUM(billing_tickets),
		SUPPORT.BUG_TICKETS as SUM(bug_tickets) with synonyms=('defect tickets'),
		SUPPORT.DISSATISFIED_TICKETS as SUM(dissatisfied_tickets),
		SUPPORT.FEATURE_REQUEST_TICKETS as SUM(feature_request_tickets) with synonyms=('enhancement requests'),
		SUPPORT.HIGH_PRIORITY_RATE_PCT as AVG(high_priority_rate_pct),
		SUPPORT.SATISFACTION_RATE_PCT as AVG(satisfaction_rate_pct),
		SUPPORT.SATISFIED_TICKETS as SUM(satisfied_tickets),
		SUPPORT.TICKETS_PER_1K_ARR as AVG(tickets_per_1k_arr) with synonyms=('ticket intensity'),
		SUPPORT.TRAINING_TICKETS as SUM(training_tickets)
	)
	comment='Support ticket metrics and customer satisfaction tracking';