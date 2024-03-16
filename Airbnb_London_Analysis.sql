
-- 1. Monthly Booking Trends
SELECT
    DATEPART(YEAR, c.date) AS year,
    DATEPART(MONTH, c.date) AS month,
    COUNT(*) AS total_bookings
FROM
    Calendar c
WHERE
    c.available = 0
GROUP BY
    DATEPART(YEAR, c.date),
    DATEPART(MONTH, c.date)
ORDER BY
    year, month;

-- 2. Current Bookings and Average Prices of listings in different neighborhoods
SELECT
    l.neighbourhood_cleansed AS neighbourhood,
    COUNT(c.listing_id) AS total_bookings,
    AVG(CAST(REPLACE(l.price, '$', '') AS DECIMAL)) AS average_price
FROM
    Listings l
LEFT JOIN
    Calendar c ON c.listing_id = l.id AND c.available = 0
GROUP BY
    l.neighbourhood_cleansed
ORDER BY
    total_bookings DESC;


-- 3. Categorizing listings based on their Price:
SELECT id, name, price,
    CASE
        WHEN CAST(REPLACE(price, '$', '') AS DECIMAL) < 50 THEN 'Budget'
        WHEN CAST(REPLACE(price, '$', '') AS DECIMAL) >= 50 AND CAST(REPLACE(price, '$', '') AS DECIMAL) < 100 THEN 'Mid-range'
        ELSE 'Luxury'
    END AS price_category
FROM Listings;

-- 4. Getting the Top 5 (highest-rated) neighbourhoods in London
SELECT TOP 5 * FROM (
    SELECT 
        neighbourhood_cleansed AS neighborhood,
        AVG(review_scores_rating) AS average_rating
    FROM 
        Listings
    GROUP BY 
        neighbourhood_cleansed
) AS top_rated_neighborhoods
ORDER BY 
    average_rating DESC;

-- 5. To get the Average price of listings in each neighborhood
SELECT neighbourhood_cleansed AS neighbourhood,
       AVG(CAST(REPLACE(price, '$', '') AS DECIMAL)) AS avg_price
FROM Listings
GROUP BY neighbourhood_cleansed;

-- 6. Fetching the most and least expensive listings:
WITH ExpensiveListings AS (
    SELECT TOP 1 name, price
    FROM Listings
    WHERE price IS NOT NULL
    ORDER BY CAST(REPLACE(price, '$', '') AS DECIMAL) DESC
),
CheapListings AS (
    SELECT TOP 1 name, price
    FROM Listings
    WHERE price IS NOT NULL
    ORDER BY CAST(REPLACE(price, '$', '') AS DECIMAL) ASC
)
SELECT name, price
FROM ExpensiveListings
UNION ALL
SELECT name, price
FROM CheapListings;

-- 7. Determining the percentage of available listings for each date:
SELECT date,
       COUNT(*) AS total_listings,
       SUM(CASE WHEN available = 1 THEN 1 ELSE 0 END) AS available_listings,
       (SUM(CASE WHEN available = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS availability_percentage
FROM Calendar
GROUP BY date
ORDER BY date;

-- 8. Analyzing trends in listing availability over time:
SELECT MONTH(date) AS month,
       YEAR(date) AS year,
       COUNT(*) AS total_listings,
       SUM(CASE WHEN available = 1 THEN 1 ELSE 0 END) AS available_listings
FROM Calendar
GROUP BY MONTH(date), YEAR(date)
ORDER BY year, month;














