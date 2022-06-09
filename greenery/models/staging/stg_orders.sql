{{ config(materialized='table') }}
with all_fields as (
select order_id
     , user_id
     , promo_id
     , address_id
     , created_at
     , order_cost
     , shipping_cost
     , order_total
     , tracking_id
     
from {{source('tutorial', 'orders')}}
)

select * from all_fields