/*
SELECT the category_id, category_name,
and product name
*/
SELECT c.category_id ,c.category_name, 
COUNT(p.listing_id) AS ProductCount,
MIN(p.price_per_kg) AS CheapestItemPrice,
MAX(p.price_per_kg) AS MostExpensiveItemPrice
FROM categories c 
JOIN product_listings p
ON c.category_id = p.category_id
-- where
WHERE p.is_available = 0
GROUP BY c.category_name, c.category_id;
-- having
