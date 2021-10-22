WITH converted_users AS (
    SELECT DISTINCT user_id
    FROM heap.shopify_confirmed_order
),
first_session AS (
    SELECT s.user_id,
           MIN(s.time::DATE) AS first_seen_date
    FROM heap.sessions s
    WHERE EXISTS (
        SELECT 1
        FROM converted_users c
        WHERE s.user_id = c.user_id)
    GROUP BY 1
    HAVING first_seen_date BETWEEN '2021-01-01' AND CURRENT_DATE-1
), product_views AS (
    SELECT p.user_id,
           REPLACE(SPLIT_PART(path,'/',3),'-rug','') AS pdp
    FROM heap.pageviews p
    WHERE EXISTS (
        SELECT 1
        FROM first_session f
        WHERE p.user_id = f.user_id)
      AND LEFT(p.path,10) = '/products/'
      AND p.time::DATE >= '2021-01-01'
    GROUP BY 1,2
    HAVING COUNT(*) >= 5 --filter to only PDPs that were viewed by user at least 3 times
)
SELECT user_id, LISTAGG(pdp,', ') WITHIN GROUP (ORDER BY pdp) AS products_viewed
FROM product_views
GROUP BY 1
HAVING COUNT(*)>=2 --filter to only users that have viewed at least 2 different PDPs, each greater than the specified number of times 
;