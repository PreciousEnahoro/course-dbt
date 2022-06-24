{{ config(
    materialized = 'table'
    )
}}

{%
    set event_types = dbt_utils.get_query_results_as_dict(
        "select distinct quote_literal(event_type) as event_type, event_type as column_name from"
     ~ ref('stg_events')
    )
%}


WITH session_length AS (
    SELECT  
        session_id,
        MIN(created_at) AS first_event,
        MAX(created_at) AS last_event
    FROM {{ ref('stg_events') }}
    GROUP BY session_id
)

SELECT
    int_session_events.session_id
   , int_session_events.user_id
   , session_length.first_event              
   , session_length.last_event  
   , stg_users.first_name
   , stg_users.last_name
   {% for event_type in event_types['column_name']%}
     , count(case when {{event_type}} = 1 then event_id else null end) as "total_{{event_types['column_name'][loop.index0]}}" 

{% endfor %}
   , count(distinct int_session_events.product_id) as products_viewed
   , CASE WHEN MAX(order_id) is not null THEN 1
        ELSE 0 END as order_placed
   , {{time_diff_between_dates_in_minutes('session_length','last_event','first_event')}} as session_length_minutes
               
                              
FROM {{ ref('int_session_events') }}
LEFT JOIN session_length ON int_session_events.session_id = session_length.session_id
--LEFT JOIN {{ ref('stg_products')}} ON int_session_events.product_id = stg_products.product_id
LEFT JOIN {{ ref('stg_users') }} on stg_users.user_id = int_session_events.user_id

{{ dbt_utils.group_by(n=6) }}
