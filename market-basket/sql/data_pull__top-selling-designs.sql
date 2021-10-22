SELECT d.rug_name,
       SUM(rug_quantity) rugs_sold
FROM shopify_ruggable.mv_ruggable_shopify_orders_detailed d
WHERE d.created_date BETWEEN '2021-01-01' AND CURRENT_DATE-1
  AND d.disc_equals_gross = 'include'
  AND d.product_type = 'Rug'
  AND d.product_sub_type IN ('Classic System','Cushioned System')
  AND d.customer_email IS NOT NULL
  AND d.return_date IS NULL
  AND d.function = 'Indoor'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 200
