WITH first_purchase AS (
    SELECT o.customer_id,
           MIN(o.created_date) AS first_order_date
    FROM shopify_ruggable.mv_ruggable_shopify_orders_detailed o
    WHERE o.disc_equals_gross = 'include'
      AND o.customer_email IS NOT NULL
      AND o.return_date IS NULL
    GROUP BY 1
    HAVING first_order_date BETWEEN '2020-01-01' AND CURRENT_DATE-1
),
purchases AS (
    SELECT DISTINCT o.customer_id,
                    LOWER(REPLACE(REPLACE(COALESCE(o.size,o.variant_size),'"',''),'''','')) AS size,
                    LOWER(CASE
                        WHEN o.product_sub_type ILIKE '%cover%' OR o.variant_group = 'Cover'
                        THEN o.rug_name || ' - Cover Only'
                        ELSE o.rug_name
                        END) AS product_name
    FROM shopify_ruggable.mv_ruggable_shopify_orders_detailed o
    WHERE EXISTS (
        SELECT 1
        FROM first_purchase f
        WHERE o.customer_id = f.customer_id)
      AND o.disc_equals_gross = 'include'
      AND o.product_type = 'Rug' --IN ('Rug','Doormat')
      AND o.customer_email IS NOT NULL
      AND o.return_date IS NULL
      AND o.function = 'Indoor' --IN ('Indoor','Outdoor','Doormat')
)
SELECT customer_id,
       LISTAGG(size||' - '||product_name,', ') WITHIN GROUP (ORDER BY product_name) products_purchased
FROM purchases
GROUP BY 1
HAVING COUNT(*) >= 2