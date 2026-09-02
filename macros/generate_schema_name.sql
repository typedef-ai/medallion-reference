{#
  Adapted from the dbt Labs custom-schema documentation example at commit
  5f4c034142aeee770cfaf72044e3eccff2d24c08. Licensed under Apache-2.0;
  see ../LICENSES/Apache-2.0.txt. Modified by Typedef by removing the
  upstream explanatory warning comment and reformatting the example.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
