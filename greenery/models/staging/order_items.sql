{{ config(materialized='table') }}
select * from order_items