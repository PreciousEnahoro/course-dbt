{{
    config(
        materialized='table'
    )
}}

WITH orders_info as (
    SELECT user_id
    , min(order_created_at) as first_order
    , max(order_created_at) as last_order
    , count(order_id) as number_of_orders
    , sum(order_total) as total_spend
    from {{ref('int_user_orders_full')}}
    group by 1
),

user_products as (
    select o.user_id
    , p.name
    , sum(quantity) as number_of_products_bought
    , row_number() OVER (PARTITION BY user_id ORDER BY sum(quantity) desc)
                    AS row_number

from {{ref('stg_orders')}} as o
join {{ref('stg_order_items')}} as oi on oi.order_id=o.order_id
join {{ref('stg_products')}} as p on p.product_id=oi.product_id
group by 1,2 
order by 1
),

user_most_bought_product as (
    select user_id
    , name as user_most_bought_product
    FROM user_products
    WHERE row_number=1
),

discount_info as (
    select user_id
    , count(discounted) as number_of_discounted_orders
from {{ref('int_user_orders_full')}}
group by 1
)

SELECT distinct ft.user_id
     , first_order
     , last_order
     , total_spend
     , number_of_orders
     , case when number_of_orders > 1 then 1 else 0 end as repeat_customer
     , number_of_discounted_orders
     ,(total_spend/ number_of_orders)::int as avg_spend
     , user_most_bought_product

FROM {{ref('int_user_orders_full')}} as ft
left join orders_info on orders_info.user_id=ft.user_id
left join discount_info on discount_info.user_id=ft.user_id
left join user_most_bought_product on user_most_bought_product.user_id=ft.user_id