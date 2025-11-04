{% macro last_day(date_column) %}
  {{ return(adapter.dispatch('last_day', 'demo_finance')(date_column)) }}
{% endmacro %}

{% macro default__last_day(date_column) %}
  -- Default implementation (DuckDB, Postgres)
  last_day({{ date_column }})
{% endmacro %}

{% macro snowflake__last_day(date_column) %}
  -- Snowflake uses LAST_DAY
  LAST_DAY({{ date_column }})
{% endmacro %}


{% macro datediff(datepart, start_date, end_date) %}
  {{ return(adapter.dispatch('datediff', 'demo_finance')(datepart, start_date, end_date)) }}
{% endmacro %}

{% macro default__datediff(datepart, start_date, end_date) %}
  -- DuckDB/Postgres: datediff('day', start, end)
  datediff('{{ datepart }}', {{ start_date }}, {{ end_date }})
{% endmacro %}

{% macro snowflake__datediff(datepart, start_date, end_date) %}
  -- Snowflake: datediff(day, start, end) - no quotes around datepart
  datediff({{ datepart }}, {{ start_date }}, {{ end_date }})
{% endmacro %}


{% macro date_trunc(datepart, date_column) %}
  {{ return(adapter.dispatch('date_trunc', 'demo_finance')(datepart, date_column)) }}
{% endmacro %}

{% macro default__date_trunc(datepart, date_column) %}
  -- Standard SQL
  date_trunc('{{ datepart }}', {{ date_column }})
{% endmacro %}

{% macro snowflake__date_trunc(datepart, date_column) %}
  -- Snowflake
  date_trunc({{ datepart }}, {{ date_column }})
{% endmacro %}
