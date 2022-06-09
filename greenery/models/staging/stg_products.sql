{{ config(materialized='table') }}
with all_fields as (
select product_id
     , name
     , price
     , inventory
from {{source('tutorial', 'products')}}
)

select * from all_fields