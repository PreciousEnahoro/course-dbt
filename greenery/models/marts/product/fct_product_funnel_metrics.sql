{{ config(
    materialized = 'table'
    )
}}

WITH product_funnel_levels AS (
    SELECT  
        session_id
       , first_event
       , case when total_page_view > 0 then 1 else 0 end AS page_view_event_flag
       , case when total_add_to_cart > 0 then 1 else 0 end AS add_to_cart_event_flag
       , case when total_checkout > 0 then 1 else 0 end AS checkout_event_flag
    FROM {{ ref('fct_user_sessions') }}
   
),

product_daily_metrics_counts as (
SELECT date_trunc('day', first_event) as session_start_day
   , date_part('hour', first_event) as hour
   , count(distinct(case when page_view_event_flag = 1 then session_id end)) as total_sessions
   , count(distinct(case when add_to_cart_event_flag = 1 then session_id end)) as add_to_cart_events
   , count(distinct(case when checkout_event_flag = 1 then session_id end)) as checkout_events

from product_funnel_levels
group by 1,2
)

SELECT session_start_day
     , hour
     , total_sessions
     , round(add_to_cart_events/total_sessions :: numeric * 100, 2) || '%' as add_to_cart_rate
     , round(checkout_events/total_sessions :: numeric * 100, 2) || '%' as checkout_rate

from product_daily_metrics_counts


