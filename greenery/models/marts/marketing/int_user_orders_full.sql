{{
    config(
        materialized='table'
    )
}}

WITH order_items AS (
    SELECT
        order_id
        , COUNT(DISTINCT product_id) as num_products_ordered
    FROM {{ ref('stg_order_items') }} 
    GROUP BY 1
)

SELECT u.user_id
     , first_name
     , last_name
     , email
     , phone_number
     , address
     , zipcode
     , state
     , country
     , o.order_id
     , o.created_at as order_created_at
     , order_cost
     , shipping_cost
     , p.promo_id
     , discount
     , CASE 
        WHEN discount > 0 
        THEN 1 
        ELSE 0 
        END AS discounted
     , order_total
     , tracking_id
     , shipping_service
     , estimated_delivery_at
     , delivered_at
     , order_status
     , time_to_delivery
     , delivery_time_status
     , num_products_ordered

FROM {{ ref('stg_users') }} as u
JOIN {{ ref('stg_addresses') }} as a on u.address_id= a.address_id     
JOIN {{ ref('int_orders_extended') }} as o on u.user_id = o.user_id
JOIN order_items as oi on oi.order_id= o.order_id
--JOIN {{ ref('stg_addresses') }} as a on a.address_id= o.address_id
LEFT JOIN {{ ref('stg_promos') }} as p on p.promo_id= o.promo_id