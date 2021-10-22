WITH rug_names AS (
    SELECT DISTINCT d.rug_name
    FROM shopify_ruggable.mv_ruggable_shopify_orders_detailed d
    WHERE d.created_date BETWEEN CURRENT_DATE-29 AND CURRENT_DATE-1
      AND d.disc_equals_gross = 'include'
      AND d.product_sub_type IN ('Classic System','Cushioned System')
      AND d.customer_email IS NOT NULL
      AND d.return_date IS NULL
),
rug_image_urls AS (
    SELECT DISTINCT p.image__src,
                    p.handle,
                    p.title
    FROM shopify_ruggable.products p
),
rug_urls AS (
    SELECT h.path
    FROM heap.pageviews h
    WHERE h.time::DATE BETWEEN CURRENT_DATE-29 AND CURRENT_DATE-1
      AND LEFT(h.path,10) = '/products/'
)
SELECT d.rug_name,
       MIN(p.image__src) image__src,
       MIN(p.handle) handle,
       MIN('https://ruggable.com'||h.path||'?size=5x7') url
FROM rug_names d
INNER JOIN rug_image_urls p
    ON d.rug_name = p.title
INNER JOIN rug_urls h
    ON p.handle = SUBSTRING(h.path,11,999999)
GROUP BY 1
