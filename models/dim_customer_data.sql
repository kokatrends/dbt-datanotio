{{
    config(materialized="table")
}}

WITH customers AS(
    SELECT * FROM {{ref('stg_customer_data')}}
),
orders AS(
    SELECT * FROM {{ref('stg_order_data')}}
),

customer_order AS(
    SELECT
        customer_id,
        MIN(order_dates) AS first_order_date,
        MAX(order_dates) AS most_recent_order_date,
        COUNT(order_id) AS num_of_order
    FROM
        orders
    GROUP BY
        1
),
customer_order_summary AS(
    SELECT
        c.customer_id,
        C.first_name,
        C.last_name,
        co.first_order_date,
        co.most_recent_order_date,
        COALESCE(co.num_of_order,0) as num_of_orders
    FROM
        customers C
    LEFT JOIN
        customer_order co
    USING(customer_id)
        
)
SELECT * FROM customer_order_summary