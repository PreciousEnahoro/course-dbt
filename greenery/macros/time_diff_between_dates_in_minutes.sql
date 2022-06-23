{% macro time_diff_between_dates_in_minutes(cte_name, end_date, start_date)%}

    (date_part('day', {{cte_name}}.{{end_date}} ::timestamp - {{cte_name}}.{{start_date}} ::timestamp) * 24 +
        date_part('hour', {{cte_name}}.{{end_date}} ::timestamp - {{cte_name}}.{{start_date}} ::timestamp) * 60 +
        date_part('minute',{{cte_name}}.{{end_date}} ::timestamp - {{cte_name}}.{{start_date}} ::timestamp)
    )

{% endmacro %}