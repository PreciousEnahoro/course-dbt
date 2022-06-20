{{ config(materialized='table') }}
with all_fields as (
select product_id
     , name
     , price
     , inventory
from {{source('greenery', 'products')}}
)

select * from all_fields