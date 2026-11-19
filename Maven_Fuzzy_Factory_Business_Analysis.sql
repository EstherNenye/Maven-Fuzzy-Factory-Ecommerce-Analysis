-- =====================================================
-- MAVEN FUZZY FACTORY
-- TASK 2: BUSINESS PERFORMANCE ANALYSIS
-- =====================================================

-- 1. TOTAL UNIQUE ORDERS
SELECT
    COUNT(DISTINCT order_id) AS total_unique_orders
FROM maven.orders_clean;

-- 2. TOTAL REVENUE
SELECT
    ROUND(SUM(price_usd), 2) AS total_revenue_usd
FROM maven.orders_clean;

-- 3. TOP PRODUCTS BY REVENUE

SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd), 2) AS total_revenue_usd
FROM maven.order_items_clean oi
JOIN maven.products_clean p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_revenue_usd DESC;


-- 4. PRODUCT CATEGORIES / TYPES

SELECT
    column_name
FROM information_schema.columns
WHERE table_schema = 'maven'
  AND table_name = 'products_clean';

  -- 5. MARKETING SOURCES WITH THE MOST SESSIONS

SELECT
    COALESCE(utm_source, 'Unknown') AS marketing_source,
    COUNT(DISTINCT website_session_id) AS total_sessions
FROM maven.website_sessions_clean
GROUP BY
    COALESCE(utm_source, 'Unknown')
ORDER BY
    total_sessions DESC;


-- 6. DEVICE TYPE WITH THE MOST TRAFFIC

SELECT
    device_type,
    COUNT(DISTINCT website_session_id) AS total_sessions
FROM maven.website_sessions_clean
GROUP BY
    device_type
ORDER BY
    total_sessions DESC;

	-- 7. WEBSITE SESSION-TO-ORDER CONVERSION RATE

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / NULLIF(COUNT(DISTINCT ws.website_session_id), 0) * 100,
        2
    ) AS conversion_rate_percentage
FROM maven.website_sessions_clean ws
LEFT JOIN maven.orders_clean o
    ON ws.website_session_id = o.website_session_id;


-- 8. TOTAL REFUNDS AND REFUND VALUE

SELECT
    COUNT(DISTINCT order_item_refund_id) AS total_refunds,
    ROUND(SUM(refund_amount_usd), 2) AS total_refund_amount_usd
FROM maven.order_item_refunds_clean;

-- 9. MONTHLY REVENUE ANALYSIS

SELECT
    TO_CHAR(DATE_TRUNC('month', created_at), 'YYYY-MM') AS revenue_month,
    ROUND(SUM(price_usd), 2) AS monthly_revenue_usd
FROM maven.orders_clean
GROUP BY
    DATE_TRUNC('month', created_at)
ORDER BY
    DATE_TRUNC('month', created_at);


-- 10. AVERAGE ORDER VALUE (AOV)

SELECT
    ROUND(AVG(price_usd), 2) AS average_order_value_usd
FROM maven.orders_clean;