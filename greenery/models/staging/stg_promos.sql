{{ config(materialized='table') }}
with all_fields as (
select promo_id
     , discount
     , status
from {{source('tutorial', 'promos')}}
)

select * from all_fields