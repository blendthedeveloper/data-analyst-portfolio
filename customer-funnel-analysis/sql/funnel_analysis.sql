funnel_analysis.sql

-- ============================================
-- BUSINESS QUESTION
-- ============================================
-- How do users move through the funnel
-- (visit → add_to_cart → purchase),
-- and how does this impact revenue?

-- ============================================
-- DATA GRAIN
-- ============================================
-- events: event-level
-- orders: order-level
-- payments: payment attempt
-- user_mapping: user → customer
-- final: user-level

-- ============================================
-- FUNNEL CREATION
-- ============================================

WITH funnel AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'visit' THEN 1 ELSE 0 END) AS visit,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchase
    FROM events
    GROUP BY user_id
),

-- ============================================
-- DATA CLEANING
-- ============================================

orders_clean AS (
    SELECT *
    FROM orders
    WHERE TRY_CAST(order_date AS DATE) IS NOT NULL
      AND amount > 0
),

payments_clean AS (
    SELECT *
    FROM payments
    WHERE payment_status = 'Success'
),

-- ============================================
-- REVENUE CALCULATION
-- ============================================

user_revenue AS (
    SELECT 
        o.customer_id,
        SUM(o.amount) AS total_revenue
    FROM orders_clean o
    JOIN payments_clean p 
        ON o.order_id = p.order_id
    GROUP BY o.customer_id
),

-- ============================================
-- FINAL DATASET
-- ============================================

final AS (
    SELECT 
        f.user_id,
        f.visit,
        f.cart,
        f.purchase,
        CASE 
            WHEN f.cart = 1 THEN 'Active'
            WHEN f.visit = 1 AND f.cart = 0 THEN 'Passive'
            ELSE 'Other'
        END AS segment,
        COALESCE(ur.total_revenue, 0) AS revenue
    FROM funnel f
    LEFT JOIN user_mapping m 
        ON f.user_id = m.user_id
    LEFT JOIN user_revenue ur 
        ON m.customer_id = ur.customer_id
)

-- ============================================
-- FINAL OUTPUT
-- ============================================

SELECT 
    segment,
    COUNT(*) AS users,
    SUM(revenue) AS total_revenue,
    SUM(revenue) * 1.0 / COUNT(*) AS revenue_per_user
FROM final
GROUP BY segment
ORDER BY total_revenue DESC;