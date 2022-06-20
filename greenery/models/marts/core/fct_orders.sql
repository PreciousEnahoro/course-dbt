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

SELECT o.order_id
     , user_id
     , stg_addresses.state
     , created_at
     , order_cost
     , shipping_cost
     , promo_id
     , discounted
     , order_total
     , tracking_id
     , shipping_service
     , estimated_delivery_at
     , delivered_at
     , order_status
     , time_to_delivery
     , delivery_time_status
     , num_products_ordered
     
FROM {{ ref('int_orders_extended') }} as o
JOIN order_items as oi on oi.order_id= o.order_id
LEFT JOIN {{ ref('stg_addresses') }} on o.address_id = stg_addresses.address_id