{{
    config(
        materialized='table'
    )
}}

SELECT o.order_id
     , o.user_id
     , o.address_id
     , o.created_at
     , o.order_cost
     , o.shipping_cost
     , o.promo_id
    -- , p.discount
     , CASE WHEN p.discount > 0  THEN 1 ELSE 0 END AS discounted
     , o.order_total
     , o.tracking_id
     , o.shipping_service
     , o.estimated_delivery_at
     , o.delivered_at
     , o.status as order_status
     , delivered_at - created_at as time_to_delivery
     , case when date(delivered_at) = date(estimated_delivery_at) then 'Delivered on time'
            when date(delivered_at) > date(estimated_delivery_at) then 'Delivered late'
            when date(delivered_at) < date(estimated_delivery_at) then 'Delivered early'
        end as delivery_time_status
    
FROM {{ ref('stg_orders') }} as o

LEFT JOIN {{ ref('stg_promos') }} as p on p.promo_id= o.promo_id
