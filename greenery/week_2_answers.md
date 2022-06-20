# Week 2

## Models

### What is our user repeat rate?
79.8%

```
with user_orders as (
SELECT
  user_id
  , COUNT (DISTINCT order_id) AS count_orders
FROM dbt.dbt_precious_e.stg_orders
GROUP BY 1
),
 
 repeat_customers as (
SELECT user_id
 , CASE WHEN count_orders >= 2 THEN 1 else 0 end as repeat_customer
FROM user_orders
)

select sum(repeat_customer)*1.0/count(user_id) as user_repeat_rate
from repeat_customers

```

### What are good indicators of a user who will likely purchase again? 
### What about indicators of users who are likely NOT to purchase again? 
### If you had more data, what features would you want to look into to answer this question?

Users who used a promotion, had an earlier or on-time delivery delivery times, buy a lot of products and order frequently would likely purchase again,
and vice-versa. 
I would also want to look into how they rate us, via surveys or customer service ratings, and see how often they refer us to other people.

### Explain the marts models you added. Why did you organize the models in the way you did?
#### Core

#### Marketing

#### Product


## Tests

### What assumptions are you making about each model? (i.e. why are you adding each test?)
For all the models, I made sure that at the bare minimum, the primary key of the table was not null and unique. I also made sure that important fields like
the user's first and last name were not nuull. I made sure prices, order and inventory related information were positive values.

### Did you find any “bad” data as you added and ran tests on your models? 
### How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
I didn't find bad data but I had to remove the unique test on user_id in my int table that combined orders and their users together, because some users 
had multiple orders.

### Your stakeholders at Greenery want to understand the state of the data each day. 
### Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
I would create a checker I guess to flag and alert the data team when one of the tests failed through an email, though I'm not sure how this would be done
in dbt.
If it affects a dashboard or data product, I would send a slack message or email to the relevant stakeholders that the data is currently not accurate,
or only accurate to a certain time point.

