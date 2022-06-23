{{ config(materialized='table') }}

SELECT
session_id
, created_at
, user_id
, product_id
, order_id
, event_id
, sum(case when event_type = 'page_view' then 1 else 0 end) as page_view 
, sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart 
, sum(case when event_type = 'checkout' then 1 else 0 end) as checkout
, sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped 

from{{ref('stg_events')}}

{{ dbt_utils.group_by(n=6) }}