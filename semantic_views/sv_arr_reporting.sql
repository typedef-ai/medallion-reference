CREATE OR REPLACE SEMANTIC VIEW sv_arr_reporting
  TABLES (
    arr_facts AS MARTS.FCT_ARR_REPORTING_MONTHLY
      PRIMARY KEY (account_id, month_end)
      WITH SYNONYMS ('ARR metrics', 'revenue reporting', 'subscription metrics')
  )
  DIMENSIONS (
    arr_facts.month_end AS month_end
      COMMENT = 'Month end date for reporting period',
    arr_facts.geo AS geo
      WITH SYNONYMS = ('region', 'location', 'geography')
      COMMENT = 'Geographic region (North America, Europe, Asia Pacific)',
    arr_facts.company_type AS company_type
      WITH SYNONYMS = ('segment', 'customer type')
      COMMENT = 'Company segment (Enterprise, Mid-Market, SMB)',
    arr_facts.tier AS tier
      WITH SYNONYMS = ('tier level', 'customer tier')
      COMMENT = 'Customer tier classification (Tier 1, 2, 3)'
  )
  METRICS (
    arr_facts.ending_arr AS SUM(month_ending_arr)
      WITH SYNONYMS = ('total ARR', 'monthly ARR')
      COMMENT = 'Total ARR at month end',
    arr_facts.net_new_arr AS SUM(net_new_arr)
      WITH SYNONYMS = ('net new', 'ARR growth')
      COMMENT = 'Net change in ARR (new + expansion - churn - contraction)',
    arr_facts.new_arr AS SUM(new_arr)
      WITH SYNONYMS = ('new customer ARR', 'new logos')
      COMMENT = 'ARR from new customers',
    arr_facts.expansion_arr AS SUM(expansion_arr)
      WITH SYNONYMS = ('upsell ARR', 'growth ARR')
      COMMENT = 'ARR from customer growth and upsells',
    arr_facts.churn_arr AS SUM(churn_arr)
      WITH SYNONYMS = ('lost ARR', 'customer churn')
      COMMENT = 'ARR lost from churned customers',
    arr_facts.contraction_arr AS SUM(contraction_arr)
      WITH SYNONYMS = ('downsell ARR', 'downgrades')
      COMMENT = 'ARR lost from shrinking customers'
  );
