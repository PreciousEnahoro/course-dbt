--Question 1
select count(distinct user_id) from dbt.dbt_precious_e.stg_users

--Question 2
SELECT AVG(b.count_orders) 
from
(SELECT date_trunc('hour', created_at) AS time
, COUNT (DISTINCT order_id) AS count_orders
FROM dbt.dbt_precious_e.stg_orders
group by 1
) b

--Question 3

SELECT AVG(b.time_difference) AS average_time 
from (
SELECT
  order_id
  , delivered_at - created_at AS time_difference
FROM dbt.dbt_precious_e.stg_orders
) b


--Question 4
SELECT
  CASE WHEN b.count_orders >= 3 THEN '3+'
    WHEN b.count_orders = 2 THEN '2'
    WHEN b.count_orders = 1 THEN '1'
    ELSE '0'
    END AS purchases
  , COUNT(b.user_id) AS count_users
FROM (
SELECT
  user_id
  , COUNT (DISTINCT order_id) AS count_orders
FROM dbt.dbt_precious_e.stg_orders
GROUP BY 1
) as b
GROUP BY 1

--Question 5
select avg(b.sessions)
from 
(select date_trunc('hr', created_at) as hr, count(distinct session_id) as sessions
from dbt.dbt_precious_e.stg_events
group by 1) as b