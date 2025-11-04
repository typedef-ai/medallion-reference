create or replace semantic view sv_account_360
	tables (
		ACCOUNTS as DIM_ACCOUNT primary key (ACCOUNT_ID) with synonyms=('customers','accounts','clients')
	)
	dimensions (
		ACCOUNTS.ACCOUNT_ID as account_id,
		ACCOUNTS.ACCOUNT_NAME as account_name,
		ACCOUNTS.BILLING_COUNTRY as billing_country,
		ACCOUNTS.COMPANY_TYPE as company_type with synonyms=('segment'),
		ACCOUNTS.GEO as geo,
		ACCOUNTS.PARENT_ACCOUNT_ID as parent_account_id,
		ACCOUNTS.TIER as tier
	)
	comment='Account dimension for customer analysis';