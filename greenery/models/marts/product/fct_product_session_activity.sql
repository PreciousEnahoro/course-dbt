{{
    config(
        materialized='table'
    )
}}

with product_orders as (
    select product_id, count(order_id) as number_of_orders 
    from {{ref('stg_order_items')}}
    group by 1
), 

session_activity_by_product as (
    select product_id
        , count (case when page_view = 1 then user_id else null end) as total_product_page_views
        , count (case when add_to_cart = 1 then user_id else null end) as total_add_to_cart

from {{ref('int_session_events')}}
group by 1
)

select pva.product_id
, p.name as product_name
, total_product_page_views 
, total_add_to_cart
, number_of_orders 

from session_activity_by_product as pva
join {{ref('stg_products')}} as p on p.product_id=pva.product_id
join product_orders on product_orders.product_id=pva.product_id