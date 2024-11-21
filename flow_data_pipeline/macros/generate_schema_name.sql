{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}
        {# This should never be done in a dev environment. Doing this in a controlled environment. #}
        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}