{{ config(materialized='table') }}

with all_fields as (
select event_id
     , session_id
     , user_id
     , page_url
     , created_at
     , event_type
     , order_id
     , product_id
     
from {{source('greenery', 'events')}}
)

select * from all_fields