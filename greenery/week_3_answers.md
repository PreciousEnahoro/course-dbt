# Answers to week three questions

## What is our overall conversion rate?

62.5%

```
SELECT sum(case when order_placed = 1 then 1 else 0 end)*100.0/count(distinct session_id)
FROM dbt_precious_e.fct_user_sessions
```

## What is our conversion rate by product?
*Showing the top 10 products*

| Product Name | Conversion Rate (%) |
| ----------- | ----------- |
| String of pearls | 60.0 |
| Arrow Head | 54.7 |
| Cactus | 54.5 |
| ZZ Plant | 52.3 |
| Bamboo | 52.2 |
| Monstera | 51.0 |
| Calathea Makoyana | 50.9 |
| Rubber Plant | 50.0 |
| Aloe Vera | 49.2 |
| Devil's Ivy | 48.9 |

```
SELECT product_name
, number_of_orders*100.0/total_product_page_views as orders

FROM dbt_precious_e.fct_product_session_activity
group by 1,number_of_orders,total_product_page_views
order by 2 desc
```