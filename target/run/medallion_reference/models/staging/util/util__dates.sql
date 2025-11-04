
  
    

create or replace transient table DEMO_AGENTS_DAVID.staging.util__dates
    
    
    
    as (

-- Generate a date spine covering the full range needed for ARR calculations
-- From 2023-11-01 through 2026-03-31 to cover all contract dates in seeds


    -- Snowflake version using TABLE generator
    WITH date_sequence AS (
        SELECT DATEADD(DAY, SEQ4(), '2023-11-01'::DATE) AS date_day
        FROM TABLE(GENERATOR(ROWCOUNT => 855))  -- 2023-11-01 to 2026-03-31 = 855 days
    )
    SELECT date_day
    FROM date_sequence
    WHERE date_day <= '2026-03-31'::DATE

    )
;


  