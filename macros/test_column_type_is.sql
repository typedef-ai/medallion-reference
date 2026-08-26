{% test column_type_is(model, column_name, expected_type) %}
    {% set observed = namespace(data_type=none) %}
    {% if execute %}
        {% for column in adapter.get_columns_in_relation(model) %}
            {% if column.name | lower == column_name | lower %}
                {% set observed.data_type = column.data_type | upper %}
            {% endif %}
        {% endfor %}
    {% endif %}

    select
        '{{ model }}' as relation_name,
        '{{ column_name }}' as column_name,
        '{{ observed.data_type or "missing" }}' as actual_type,
        '{{ expected_type | upper }}' as expected_type
    -- BigQuery does not allow a FROM-less SELECT to carry a WHERE clause
    -- (Snowflake and DuckDB both tolerate it); this one-row subquery is a
    -- portable FROM source across all three.
    from (select 1 as dummy_col) as _dummy
    where {{ observed.data_type != expected_type | upper }}
{% endtest %}
