{{
    config(
        materialized='table'
    )
}}

-- Generate a date spine covering the full range needed for ARR calculations
-- From 2023-11-01 through 2026-03-31 to cover all contract dates in seeds

{% if target.type == 'snowflake' %}
    -- Snowflake version using TABLE generator
    WITH date_sequence AS (
        SELECT DATEADD(DAY, SEQ4(), '2023-11-01'::DATE) AS date_day
        FROM TABLE(GENERATOR(ROWCOUNT => 855))  -- 2023-11-01 to 2026-03-31 = 855 days
    )
    SELECT date_day
    FROM date_sequence
    WHERE date_day <= '2026-03-31'::DATE
{% elif target.type == 'duckdb' %}
    -- DuckDB version using generate_series
    select
        cast(date_day as date) as date_day
    from generate_series(date '2023-11-01', date '2026-03-31', interval 1 day) as t(date_day)
{% elif target.type == 'bigquery' %}
    -- BigQuery version using GENERATE_DATE_ARRAY. dbt_utils.date_spine's generic
    -- path runs a compile-time query (get_intervals_between) that does not
    -- resolve cleanly against the BigQuery adapter, so this warehouse gets its
    -- own branch like Snowflake and DuckDB above, instead of the dbt_utils path.
    -- DATE literals, not string literals: BigQuery's own docs specify
    -- GENERATE_DATE_ARRAY's bounds as DATE expressions, and an implicit
    -- string-to-DATE coercion is not guaranteed for every literal format.
    select date_day
    from unnest(generate_date_array(DATE '2023-11-01', DATE '2026-03-31', interval 1 day)) as date_day
{% else %}
    -- Other databases using dbt_utils
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2023-11-01' as date)",
        end_date="cast('2026-03-31' as date)"
       )
    }}
{% endif %}
