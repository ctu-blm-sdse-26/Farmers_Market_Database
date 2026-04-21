-- DROP TABLES IN CASE THEY EXIST
DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS buyers;
DROP TABLE IF EXISTS product_listings;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS farmers;
DROP TABLE IF EXISTS provinces

-- CREATE PROVINCES 
CREATE TABLE  provinces (
	province_id INT PRIMARY KEY IDENTITY(1,1),
	province_name VARCHAR(150) NOT NULL UNIQUE
);

-- CREATE CATEGORIES 
CREATE TABLE  categories (
	category_id INT PRIMARY KEY IDENTITY(1,1),
	category_name VARCHAR(100) NOT NULL UNIQUE
);

-- CREATE BUYER TYPES
CREATE TABLE  buyer_types (
	buyer_type_id INT PRIMARY KEY IDENTITY(1,1),
	type_name VARCHAR(100) NOT NULL UNIQUE
);

-- CREATE ORDER STATUSES
CREATE TABLE  order_statuses (
	status_id INT PRIMARY KEY IDENTITY(1,1),
	status_name VARCHAR(100) NOT NULL UNIQUE
);


-- CREATE FARMERS
CREATE TABLE farmers (
	farmer_id INT PRIMARY KEY IDENTITY(1,1),
	full_name VARCHAR(150) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	phone_number CHAR(10) NOT NULL,
	farm_name NVARCHAR(200) NOT NULL,
	location VARCHAR(200) NOT NULL,
	province_id INT NOT NULL REFERENCES provinces(province_id),
	rating DECIMAL(3,2) DEFAULT 0.00 CHECK (rating BETWEEN 0 AND 5),
	is_verified BIT DEFAULT 0,
	created_at DATETIME DEFAULT SYSUTCDATETIME()
);

-- CREATE PRODUCT LISTINGS
CREATE TABLE product_listings (
	listing_id INT PRIMARY KEY IDENTITY(1,1),
	farmer_id INT NOT NULL,
	product_name VARCHAR(200) NOT NULL CHECK (LEN(product_name) >= 3),
	category_id INT NOT NULL REFERENCES categories(category_id),
	price_per_kg DECIMAL(10,2) NOT NULL CHECK (price_per_kg > 0),
	quantity_kg DECIMAL(10,2) NOT NULL CHECK (quantity_kg > 0),
	is_available BIT DEFAULT 1,
	harvest_date DATE NOT NULL,
	date_listed DATETIME DEFAULT CURRENT_TIMESTAMP,
	description VARCHAR(500) NULL,
	CONSTRAINT FK_product_farmer 
	FOREIGN KEY (farmer_id) 
	REFERENCES farmers(farmer_id)
);

-- CREATE BUYERS
CREATE TABLE buyers (
	buyer_id INT PRIMARY KEY IDENTITY(1,1),
	full_name VARCHAR(150) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	phone_number CHAR(10) NOT NULL,
	buyer_type_id INT NOT NULL REFERENCES buyer_types(buyer_type_id),
	location VARCHAR(200) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CREATE ORDERS TABLE
CREATE TABLE orders (
	order_id INT PRIMARY KEY IDENTITY(1,1),
	buyer_id INT NOT NULL REFERENCES buyers(buyer_id),
	listing_id INT NOT NULL REFERENCES product_listings(listing_id),
	quantity_ordered DECIMAL(10,2) NOT NULL CHECK (quantity_ordered > 0),
	total_price DECIMAL(10,2) NOT NULL,
	status_id INT NOT NULL REFERENCES order_statuses(status_id),
	order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	collection_date DATETIME NULL,
	notes VARCHAR(500) NULL
);

-- CREATE REVIEWS
CREATE TABLE reviews(
	review_id INT PRIMARY KEY IDENTITY(1,1),
	buyer_id INT NOT NULL REFERENCES buyers(buyer_id),
	farmer_id INT NOT NULL REFERENCES farmers(farmer_id),
	order_id INT NOT NULL REFERENCES orders(order_id),
	rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
	comment VARCHAR(1000) NULL,
	date_posted DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CREATE PRICE HISTORY
CREATE TABLE price_history(
	history_id INT PRIMARY KEY IDENTITY(1,1),
	listing_id INT NOT NULL REFERENCES product_listings(listing_id),
	old_price DECIMAL(10,2) NOT NULL,
	new_price DECIMAL(10,2) NOT NULL,
	changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	changed_by VARCHAR(150)
);