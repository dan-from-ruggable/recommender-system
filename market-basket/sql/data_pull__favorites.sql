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
),
add_to_fave_1 AS (
    SELECT user_id,
           REPLACE(REPLACE(REGEXP_SUBSTR(href,'products/[^?]*'),'products/',''),'-rug','') AS rug_name
    FROM heap.plp_collections_click_to_favorite_heart_a_rug
    UNION
    SELECT user_id,
           REPLACE(REPLACE(path,'/products/',''),'-rug','') AS rug_name
    FROM heap.pdp_main_click_to_favorite_heart_the_rug
),
add_to_fave_2 AS (
    SELECT DISTINCT a.user_id,
                    rug_name
    FROM add_to_fave_1 a
    WHERE EXISTS (
        SELECT 1
        FROM first_session f
        WHERE a.user_id = f.user_id)
)
SELECT user_id,
       LISTAGG(rug_name,', ') WITHIN GROUP (ORDER BY rug_name) AS products_favorited
FROM add_to_fave_2
GROUP BY 1
HAVING COUNT(*)>=2
;