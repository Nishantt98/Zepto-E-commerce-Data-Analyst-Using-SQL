drop table exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150),
	mrp NUMERIC(8,2),
	discountedPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOFStock BOOLEAN,
	quantity INTEGER
);

-----------data exploration-----------

--count of rows
SELECT * COUNT(*) FROM zepto;

--sample data  
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountedPercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOFStock IS NULL
OR
quantity IS NULL

--different product categories
SELECT DISTINCT category FROM zepto
ORDER BY category;

--product in stock and out of stock
SELECT outOFStock,COUNT(*) FROM zepto
GROUP BY outOFStock

--product names present multiple times
SELECT name,COUNT(sku_id) as "number of SKUS" FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


-----------data cleaning-------------------

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert into paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.00

SELECT mrp,discountedSellingPrice  FROM zepto

--------------------- Data Analysis--------------------


--Q! FInd the top 10 best value products based on the discount percentage?
SELECT DISTINCT name,mrp,discountedPercent 
FROM zepto
ORDER BY discountedPercent
LIMIT 10;

--Q2 What ar the Product with HIgh MRP but OUT OF stock?
SELECT DISTINCT name,mrp FROM zepto
WHERE outOFStock = TRUE and mrp > 300
ORDER BY mrp desc

--Q3 Calculate Estimated REvenue for each category?
SELECT category, SUM(discountedSellingPrice*availableQuantity) AS total_revenue FROM zepto
GROUP BY category
ORDER BY total_revenue;

--q4 Find all product where MRP is greater than 500 and discount is less than10%;
SELECT DISTINCT name,mrp,discountedPercent FROM zepto
WHERE mrp > 500 AND discountedPercent < 10
ORDER BY mrp desc,
discountedPercent desc;

--Q5 Identify the top 5 categories offering the highest average discount percentage
SELECT category,ROUND(AVG(discountedPercent),2) as avg_discount FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5

--Q6 Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,weightInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram DESC

--q7 Group the products into categories like low,medium and bulk.
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
	 WHEN weightInGms < 500 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;
ORDER BY weight_category 

--Q8 What is the total Inventory Weight per Category
SELECT category,
SUM(weightInGms * availableQuantity) as total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

