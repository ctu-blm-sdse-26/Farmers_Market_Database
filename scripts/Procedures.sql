-- Create Procedure
 CREATE PROCEDURE GetAllAvailableProducts
AS 
BEGIN
	SELECT * FROM product_listings
	WHERE is_available = 1;
END;

-- EXEC GetAllAvailableProducts;
 --DROP PROCEDURE GetProductsByCategoryId;

CREATE PROCEDURE GetProductsByCategoryId 
@CategoryId INT --parameter
AS 
BEGIN
	SELECT product_listings.*, category_name 
	FROM product_listings  
	JOIN categories ON categories.category_id = product_listings.category_id
	WHERE product_listings.category_id = @CategoryId
END; 

EXEC GetProductsByCategoryId @CategoryId = 3;

/*
	Create a procedure to get all the products from a given 
	farmer using their id. 
	Query must return farmer_id, product_name, price & qty
	ordered by cheapest product 1st
*/


CREATE PROCEDURE GetFarmersProducts 
@FarmerID INT 
AS
BEGIN
	SELECT farmer_id, product_name, price_per_kg,quantity_kg
	FROM product_listings
	WHERE farmer_id = @FarmerID
	ORDER BY price_per_kg ASC;
END;

EXEC GetFarmersProducts @FarmerID = 110;


CREATE PROCEDURE usp_AddFarmer
@FullName NVARCHAR(255),
@Email NVARCHAR(255),
@PhoneNumber NVARCHAR(20),
@FarmName NVARCHAR(255),
@Location NVARCHAR(255),
@ProvinceId INT,
@Rating DECIMAL(3,2),
@IsVerified BIT
AS
BEGIN
	INSERT INTO farmers(full_name, email, phone_number, farm_name, location, province_id, rating, is_verified)
	VALUES (@FullName, @Email, @PhoneNumber, @FarmName, @Location, @ProvinceId, @Rating, @IsVerified);
	
	SELECT SCOPE_IDENTITY() as NewFarmerID; -- Return the ID of the newly inserted farmer
END;


EXEC usp_AddFarmer 
@FullName = 'Connie Maheswaran',
@Email = 'connie@gmail.com',
@PhoneNumber = '0741254587',
@FarmName = 'Universe Farm',
@Location = 'Beach City',
@ProvinceId = 1,
@Rating = 4.3,
@IsVerified = 1;

1.
Write A Procedure called usp_AddListing
Validate that the price is bigger than 0
Validate that the quantity is bigger than 0
*/

CREATE PROCEDURE usp_AddListing
	@farmer_id INT,
	@product_name VARCHAR(200),
	@category_id INT,
	@price_per_kg DECIMAL(10,2),
	@quantity_kg DECIMAL(10,2),
	@harvest_date DATE,
	@description VARCHAR(500)
AS
BEGIN
	IF(@quantity_kg < 1 OR @price_per_kg < 1)
	BEGIN
		PRINT 'Quanity And Price Cannot Be Less Than 1'
	END

	INSERT INTO product_listings 
	(farmer_id, product_name, category_id,price_per_kg,quantity_kg,harvest_date,description)
	VALUES
	(@farmer_id, @product_name, @category_id, @price_per_kg, @quantity_kg, @harvest_date, @description)
	SELECT SCOPE_IDENTITY() as NewProduceID; 
END;



/*
2. 
Create a View vw_AvailableListings
joins produceListing + Farmers + category
shows only the available products
*/

CREATE VIEW vw_availableProduce 
AS
SELECT p.listing_id, p.product_name, f.farm_name,
c.category_name, p.is_available, p.price_per_kg, p.description 
FROM product_listings p 
JOIN farmers f ON f.farmer_id = p.farmer_id
JOIN categories c ON c.category_id = p.category_id
WHERE p.is_available = 1;

