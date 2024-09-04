# Australia Car Market Analysis

## Table of Content
 - [SQL Queries and Analysis](#sql-queries-and-analysis)
 - [Tableau Visualization](#tableau-visualization)

## Introduction

Understanding consumer preferences and vehicle trends is becoming essential for car makers, dealerships, and buyers as the automotive market changes. This research attempts to analyze important cars market factors, with a particular emphasis on market availability, pricing trends, and car attributes. Through the examination of data trends, the analysis offers valuable insights that can assist in guiding strategic decisions, improving inventory management, and informing purchasing decisions within the automotive sector. The analysis makes use of a number of tools and methods, like as Tableau for interactive visualizations and SQL for data querying, to extract insightful information from the data. These insights provide a better knowledge of the market performance of various car segments and the variables influencing consumer behavior.

## Data

This project involves analyzing the [Australia_cars_dataset](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/Data/Australia_cars.csv) using SQL scripts. The dataset offers detailed information about a variety of vehicles, including attributes like brand, model, price, year of manufacture, and metrics such as kilometers driven. The project attempts to identify important trends and insights in the automotive sector using a series of SQL queries, assisting in a better understanding of car price, market availability, and consumer preferences. The investigation provides important insights into the automotive scene by examining a variety of topics, including pricing outlier identification, vehicle condition assessment, and the effects of fuel type and seating capacity on market dynamics.

In addition to SQL analysis, interactive visualizations will be created using Tableau to provide a more intuitive exploration of the data. These visualizations will help to further uncover patterns and trends, making it easier to interpret the insights derived from the dataset.

The dataset includes the following columns:
 - ID: Unique identifier for each vehicle listing.
 - Name: Full name of the car, including year, make, and model details.
 - Price: Listed price of the vehicle.
 - Brand: Manufacturer or brand of the vehicle.
 - Model: Model name of the vehicle.
 - Variant: Specific variant or trim level of the model.
 - Series: Series code or designation for the vehicle.
 - Year: Manufacturing year of the vehicle.
 - Kilometers: Total kilometers driven, representing the vehicle's usage.
 - Type: Body type of the vehicle.
 - Gearbox: Type of gearbox or transmission.
 - Fuel: Fuel type used by the vehicle.
 - Status: Condition and availability status of the vehicle.
 - CC: Engine displacement in cubic centimeters.
 - Color: Exterior color of the vehicle.
 - Seating Capacity: Number of seats available in the vehicle.


## SQL Queries and Analysis
### 1. Identify Price Outliers
The client wants to identify potential outliers in the pricing of the vehicles. 
```sql
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
```
![Query 1](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%201.png)

### 2. Inventory Age Analysis
The client wants to understand how the vehicle age affects pricing. Also, identify the oldest vehicle(s) in the inventory and provide their details.
2.1
```sql
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

```
![Query 2.1](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%202.1.png)
2.2
```sql
SELECT * FROM cars
WHERE year = (SELECT MIN(year) FROM cars)

```
![Query 2.2](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%202.2.png)

### 3. Sales Forecast Based on Fuel Type
The client suspects that fuel type might influence the likelihood of selling the vehicles quickly. 
```sql
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
```
![Query 3](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%203.png)

### 4. Luxury Vehicle Identification
The client wants to create a targeted marketing campaign for luxury vehicles. 
List all vehicles that should be considered luxury based on the following criteria:

 - Brand: Mercedes-Benz, BMW
 - Price: Above $50,000
 - Type: Sedan or Cabriolet 
```sql
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
```
![Query 4](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%204.png)

### 5. Inventory Distribution by Seating Capacity
The client is considering stocking more family-friendly vehicles. 
```sql
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
```
![Query 5](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%205.png)

### 6. Vehicle Type Analysis
The client is curious about how different Type of vehicles are priced. 
```sql
SELECT type, 
	ROUND(AVG(price),2) as average_price,
	COUNT(*) as count_of_type 
from cars
GROUP BY type
ORDER BY count_of_type DESC
```
![Query 6](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/SQL/SQL%20images/Query%206.png)



## Tableau Visualization
This dashboard provides insights into various aspects of the car market, including vehicle pricing trends, brand performance, and market availability. It examines key data such as average vehicle prices by brand and type, the distribution of vehicles based on age, and the relationship between fuel type and kilometers driven. Additionally, the dashboard analyzes the inventory distribution by seating capacity and identifies luxury vehicles based on price and type. Automotive professionals and marketers can leverage this visual representation to make informed decisions, optimize inventory management, and understand market dynamics better.

Feel free to check out the "Australia Car Market" dashboard on Tableau Public [here](https://public.tableau.com/app/profile/mark.jerome.cifra/viz/AustraliaCarMarketAnalysis/AustraliaCarMarketDashboard).
![Australia Car Market Tableau Visualizaation](https://github.com/markjeromecifra/portfolio/blob/main/Australia%20Car%20Market/Tableau/Australia%20Car%20Market%20Dashboard.png)
