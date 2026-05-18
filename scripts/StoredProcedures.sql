CREATE PROCEDURE usp_UpdateProducePrice 
	@listing_id INT, 
	@new_price DECIMAL(8,2)
AS
BEGIN
	UPDATE product_listings
	SET price_per_kg = @new_price
	WHERE listing_id = @listing_id;
END;

CREATE PROCEDURE GetBuyerOrdersSummary
	@buyer_id INT
	AS
BEGIN
	SELECT os.status_name, 
	COUNT(o.order_id) AS TotalOrders,
	FORMAT(SUM(o.total_price), 'C', 'en-ZA') AS TotalRevenue
	FROM order_statuses os 
	LEFT JOIN orders o
	ON o.status_id = os.status_id
	WHERE o.buyer_id = @buyer_id
	GROUP BY os.status_name;
END;