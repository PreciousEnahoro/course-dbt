{{ config(materialized='table') }}

with all_fields as (
select order_id
     , product_id
     , quantity
from {{source('greenery', 'order_items')}}
)

select * from all_fields