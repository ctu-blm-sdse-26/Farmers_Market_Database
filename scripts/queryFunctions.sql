  -- AVG | COUNT | MAX | MIN | SUM
  SELECT *
  FROM farmers
  WHERE rating = (SELECT (MIN(rating)) from farmers);

  SELECT COUNT(*)  FROM farmers
  WHERE rating > 4.0;

  SELECT SUM(rating) as total_Ratings FROM farmers;

  SELECT * from Farmers;

  -- STRING FUNCTIONS
  SELECT full_name, email, phone_number, farm_name
  FROM farmers;

  SELECT CONCAT(full_name, ' - ',farm_name) as FarmOwner, email, phone_number
  FROM farmers;

  SELECT SUBSTRING(full_name,1,1) as Initial ,full_name, email, phone_number, farm_name
  FROM farmers;

  SELECT SUBSTRING(full_name,1,1) as Initial ,full_name, email, LEN(phone_number), farm_name
  FROM farmers;

  SELECT SUBSTRING(full_name,1,1) as Initial ,full_name, email, 
  REPLACE(phone_number,SUBSTRING(phone_number,1,2),'07') as ZAR_Phone,
  farm_name
  FROM farmers;

  SELECT SUBSTRING(full_name,1,1) as Initial ,full_name, email, 
  stuff(phone_number, 1, 2, '07') as ZAR_PHONE,
  farm_name
  FROM farmers;