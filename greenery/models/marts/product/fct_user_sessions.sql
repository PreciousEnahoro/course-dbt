{{ config(
    materialized = 'table'
    )
}}

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
   , count(case when int_session_events.page_view = 1 then event_id else null end) as total_page_views
   , count(case when int_session_events.add_to_cart = 1 then event_id else null end) as total_add_to_cart_events
   , count(case when int_session_events.checkout = 1 then event_id else null end) as total_check_outs
   , count(case when int_session_events.package_shipped = 1 then event_id else null end) as total_package_shipped
   , count(distinct int_session_events.product_id) as products_viewed
   , CASE WHEN MAX(order_id) is not null THEN 1
        ELSE 0 END as order_placed
               
   , (date_part('day', session_length.last_event::timestamp - session_length.first_event::timestamp) * 24 +
        date_part('hour', session_length.last_event::timestamp - session_length.first_event::timestamp) * 60 +
        date_part('minute', session_length.last_event::timestamp - session_length.first_event::timestamp)
    ) as session_length_minutes

                              
FROM {{ ref('int_session_events') }}
LEFT JOIN session_length ON int_session_events.session_id = session_length.session_id
--LEFT JOIN {{ ref('stg_products')}} ON int_session_events.product_id = stg_products.product_id
LEFT JOIN {{ ref('stg_users') }} on stg_users.user_id = int_session_events.user_id

group by 1,2,3,4,5,6