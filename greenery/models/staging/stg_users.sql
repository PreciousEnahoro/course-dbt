{{ config(materialized='table') }}
with all_fields as (
select user_id
     , first_name
     , last_name
     , email
     , phone_number
     , created_at
     , updated_at
     , address_id
from {{source('greenery', 'users')}}
)

select * from all_fields