{{
    config(
        materialized='table'
    )
}}

SELECT user_id
     , first_name
     , last_name
     , email
     , phone_number
     , created_at
     , updated_at
     , address
     , zipcode
     , state
     , country
FROM {{ ref('stg_users') }} as u
JOIN {{ ref('stg_addresses') }} as a on u.address_id= a.address_id