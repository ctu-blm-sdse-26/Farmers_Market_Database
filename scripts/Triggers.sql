USE [farmer_market_db]
GO
/*
	CREATE A TRIGGER TO RUN WHEN I DELETE A RECORD FROM THE PRODUCE_LISTINGS
	TO DELETE ALL RERALTED PRICE_HISTORY RECORDS

	TYPES				Meaning
	AFTETR INSERT		Run After an Insert
	AFTER UPDATE		Run After an Update
	AFTER DELETE		Run After a Delete	
	INSTEAD OF			Run Instead of the triggering action (insert/update/delete)
*/
-- TRIGGERS
CREATE TRIGGER SaySomething
ON Farmers
AFTER INSERT
AS
BEGIN
	PRINT 'NEW FARMER HAS BEEN ADDED. CHECK IT OUT'
END;

CREATE TRIGGER deletePriceHistory
ON product_listings
AFTER DELETE
AS
BEGIN
	DELETE FROM price_history
	WHERE listing_id IN (SELECT listing_id FROM deleted)
END;

/* CREATE TRIGGER FOR UPDATE */
CREATE TRIGGER updatePriceHistory
ON product_listings
AFTER UPDATE
AS
BEGIN
	INSERT INTO price_history(listing_id, old_price, new_price, changed_at)
	SELECT inserted.listing_id, deleted.price_per_kg, inserted.price_per_kg, GETDATE()
	FROM inserted
	JOIN deleted ON inserted.listing_id = deleted.listing_id;
END;