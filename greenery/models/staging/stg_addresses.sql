{{ config(materialized='table') }}

with all_fields as (
select address_id
     , address
     , zipcode
     , state
     , country
from {{source('tutorial', 'addresses')}}
)

select * from all_fields