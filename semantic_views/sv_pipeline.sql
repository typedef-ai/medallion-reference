CREATE OR REPLACE SEMANTIC VIEW sv_pipeline
  TABLES (
    pipeline_facts AS MARTS.FCT_PIPELINE
      PRIMARY KEY (opportunity_id)
      WITH SYNONYMS ('sales pipeline', 'opportunities', 'deals')
  )
  DIMENSIONS (
    pipeline_facts.close_month AS close_month
      WITH SYNONYMS = ('close date', 'expected close')
      COMMENT = 'Expected close month for opportunity',
    pipeline_facts.stage_name AS stage_name
      WITH SYNONYMS = ('stage', 'pipeline stage', 'sales stage')
      COMMENT = 'Current sales stage of opportunity',
    pipeline_facts.forecast_category AS forecast_category
      WITH SYNONYMS = ('forecast')
      COMMENT = 'Forecast category (Commit, Best Case, Pipeline)',
    pipeline_facts.deal_type AS deal_type
      WITH SYNONYMS = ('opportunity type')
      COMMENT = 'Type of deal (New, Renewal, Expansion)'
  )
  METRICS (
    pipeline_facts.total_arr AS SUM(arr)
      WITH SYNONYMS = ('pipeline ARR', 'deal value')
      COMMENT = 'Total annual recurring revenue in pipeline',
    pipeline_facts.weighted_arr AS SUM(prob_weighted_arr)
      WITH SYNONYMS = ('weighted pipeline', 'expected ARR')
      COMMENT = 'Probability-weighted ARR based on stage',
    pipeline_facts.total_bookings AS SUM(bookings)
      WITH SYNONYMS = ('bookings')
      COMMENT = 'Total bookings value',
    pipeline_facts.deal_count AS COUNT(DISTINCT opportunity_id)
      WITH SYNONYMS = ('opportunity count', 'number of deals')
      COMMENT = 'Number of opportunities'
  );
