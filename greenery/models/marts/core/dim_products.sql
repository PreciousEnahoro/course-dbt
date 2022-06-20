{{
    config(
        materialized='table'
    )
}}

SELECT p.product_id
     , name
     , price
     , inventory as current_inventory
     , count(oi.order_id) as num_orders_containing_product
     , sum(oi.quantity) as total_quantity_of_product_sold
FROM {{ ref('stg_products') }} as p
left JOIN {{ ref('stg_order_items') }} as oi on oi.product_id= p.product_id
group by 1,2,3,4