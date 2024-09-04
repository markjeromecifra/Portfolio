CREATE TABLE IF NOT EXISTS cars (
	ID int,
	Name VARCHAR,
	Price int,
	Brand VARCHAR,
	Model VARCHAR,
	Variant VARCHAR,
	Series VARCHAR,
	Year int,
	Kilometer int,
	Type VARCHAR,
	Gear VARCHAR,
	Fuel VARCHAR,
	Status VARCHAR,
	CC int,
	Color VARCHAR,
	Seating_capacity int
)


/*Task 1: Identify Price Outliers
The client wants to identify potential outliers in the pricing of the vehicles. 
Calculate the average price of vehicles per brand and then list any vehicles priced above 1.5 times the 
standard deviation from the brand’s average price. For each outlier, provide the ID, Name, Brand, Price, 
and the difference from the average price.
*/


WITH BrandAverage AS (
	SELECT 
	brand, 
		AVG(price) as avg_price,
		STDDEV(price) as std_price
	FROM cars
	GROUP BY brand
	),

Outliers AS(
	SELECT
	c.id,
	c.name,
	c.brand,
	c.price,
	(c.price - b.avg_price) as price_difference
	FROM cars c
	JOIN BrandAverage b
	ON c.brand = b.brand
	WHERE c.price > b.avg_price + 1.5 * b.std_price
)
SELECT id,
	name,
	brand,
	price, 
	ROUND(price_difference,2)
FROM Outliers
GROUP BY id,name,brand,price,price_difference
ORDER BY price_difference DESC


/*Task 2: Inventory Age Analysis
The client wants to understand how the vehicle age affects pricing. 
Calculate the average price of vehicles grouped by their age (difference between the current year and the vehicle's Year).
Display the vehicle age, the number of vehicles in that age group, and the average price. 
Also, identify the oldest vehicle(s) in the inventory and provide their details.*/


WITH carAge AS
	(SELECT 
	ROUND(AVG(price),2) as avg_price, 
	(2024-year) AS car_age,
	COUNT(*) AS car_count
FROM cars
GROUP BY car_age)

Select car_age, car_count, avg_price
FROM carAge
ORDER BY car_age

	
SELECT * FROM cars
WHERE year = (SELECT MIN(year) FROM cars)

/*Task 3: Sales Forecast Based on Fuel Type
The client suspects that fuel type might influence the likelihood of selling the vehicles quickly. 
Group the vehicles by Fuel type and calculate the average Kilometers driven for each fuel type. 
Identify if there's a correlation between higher mileage and specific fuel types. 
Then, recommend which fuel types might require pricing adjustments based on the average kilometers.*/


WITH fuel_type AS (SELECT 
	fuel, 
	AVG(kilometer) as avg_kilometer 
FROM cars
GROUP BY fuel),

fuel_numeric AS (
	SELECT
	fuel,
	avg_kilometer,
	ROW_NUMBER() OVER(ORDER BY fuel) as fuel_code
	FROM fuel_type
)

SELECT CORR(fuel_code,avg_kilometer) FROM fuel_numeric

/*Task 4: Luxury Vehicle Identification
The client wants to create a targeted marketing campaign for luxury vehicles. 
List all vehicles that should be considered luxury based on the following criteria:

 - Brand: Mercedes-Benz, BMW
 - Price: Above $50,000
 - Type: Sedan or Cabriolet 
Provide the ID, Name, Brand, Price, Year, and Type for these vehicles*/

	
SELECT id,
	name,
	brand,
	price,
	year,
	type 
FROM cars
WHERE brand IN ('Mercedes-Benz','BMW')
	AND price > 50000 AND type IN ('Sedan','Cabriolet')
GROUP BY id,name,brand,price,year,type
ORDER BY brand,price DESC


/*Task 5: Inventory Distribution by Seating Capacity
The client is considering stocking more family-friendly vehicles. 
Provide an analysis of the inventory distribution based on Seating Capacity. 
Display the number of vehicles available for each seating capacity and the average price. 
Recommend whether the client should consider adjusting prices or stocking more vehicles with specific seating capacities.*/

WITH ave_price_seat AS 
	(SELECT seating_capacity, 
	COUNT(*) as car_count, 
	AVG(price) as ave_price 
	FROM cars
	GROUP BY seating_capacity)
	
SELECT seating_capacity,car_count,ave_price 
FROM ave_price_seat
GROUP BY seating_capacity,car_count,ave_price
ORDER BY ave_price DESC

/*Task 6: Vehicle Type Analysis
The client is curious about how different Type of vehicles are priced. 
Provide an analysis that shows the average price per vehicle type and the distribution of vehicles across different types. 
Additionally, identify which type of vehicle is most common in the inventory.*/

SELECT type, 
	ROUND(AVG(price),2) as average_price,
	COUNT(*) as count_of_type 
from cars
GROUP BY type
ORDER BY count_of_type DESC



