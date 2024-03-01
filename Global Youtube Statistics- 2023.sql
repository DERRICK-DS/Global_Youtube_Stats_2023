-- 2023 GLOBAL YOUTUBE STATISTICS FOR THE TOP 961 YOUTUBE CHANNELS.

SELECT * FROM globalyoutubestats.youtube_statistics;

SELECT *
FROM youtube_statistics;

ALTER TABLE youtube_statistics
MODIFY COLUMN highest_yearly_earnings DECIMAL(12, 2);

-- ------------------1.SUBSCRIBER ANALYSIS-----------------------------------------
-- --------------------------------------------------------------------------------

-- 1a.Find channels gaining the most subscribers in the last 30 days.

SELECT
     Youtuber,
	 subscribers_for_last_30_days
FROM youtube_statistics
ORDER BY 2 DESC;

-- 1b.Calculate the average subscribers per channel.

SELECT
	ROUND(AVG(subscribers), 2) as Avg_subscribers_per_channel
FROM youtube_statistics;

-- ------------------------2.VIDEOS VIEWS INSIGHTS--------------------------------
-- -------------------------------------------------------------------------------

-- 2a.Identify  Youtube channels with the highest total views
-- First of all Renaming column name video_view to total_video_views

ALTER TABLE youtube_statistics
RENAME COLUMN video_view TO total_video_views;

SELECT
	Youtube_rank,
     Youtuber,
	 total_video_views
FROM youtube_statistics
ORDER BY 3 DESC;

-- 2b.Compare video views across different categories/countries.

-- --By category.

SELECT 
     categories,
    SUM(total_video_views)
FROM youtube_statistics
GROUP BY categories
ORDER BY 2 DESC;

-- --BY country

SELECT 
     Country,
     SUM(total_video_views)
FROM youtube_statistics
GROUP BY Country
ORDER BY 2 DESC;

-- --By Continent
-- -First is to add a column 'continent' on the table

SELECT 
     Country,
			CASE 
				WHEN Country IN ("United States", "Canada", "Mexico", "Cuba", "El Salvador", "Barbados") THEN "North America"
                WHEN Country IN ("Brazil", "Argentina", "Chile", "Colombia", "Ecuador", "Peru", "Venezuela") THEN "South America"
                WHEN Country IN ("India", "Indonesia", "China", "Thailand", "South Korea", "Pakistan", "Turkey", "Japan", "United Arab Emirates", "Philippines", "Vietnam", "Singapore", "Malaysia", "Saudi Arabia", "Iraq", "Afghanistan", "Bangladesh", "Jordan", "Kuwait") THEN "Asia"
                WHEN Country IN ("United Kingdom", "Germany", "France", "Spain", "Italy", "Russia", "Finland","Latvia", "Sweden", "Switzerland", "Ukraine", "Netherlands") THEN "Europe"
                WHEN Country IN ("Egypt", "Morocco") THEN "Africa"
                ELSE "Oceania"
			END as Continent
FROM youtube_statistics
ORDER BY 1 ASC;

ALTER TABLE youtube_statistics
ADD COLUMN Continent VARCHAR(30);

UPDATE youtube_statistics
SET Continent = 
               (CASE 
				WHEN Country IN ("United States", "Canada", "Mexico", "Cuba", "El Salvador", "Barbados") THEN "North America"
                WHEN Country IN ("Brazil", "Argentina", "Chile", "Colombia", "Ecuador", "Peru", "Venezuela") THEN "South America"
                WHEN Country IN ("India", "Indonesia", "China", "Thailand", "South Korea", "Pakistan", "Turkey", "Japan", "United Arab Emirates", "Philippines", "Vietnam", "Singapore", "Malaysia", "Saudi Arabia", "Iraq", "Afghanistan", "Bangladesh", "Jordan", "Kuwait") THEN "Asia"
                WHEN Country IN ("United Kingdom", "Germany", "France", "Spain", "Italy", "Russia", "Finland","Latvia", "Sweden", "Switzerland", "Ukraine", "Netherlands") THEN "Europe"
                WHEN Country IN ("Egypt", "Morocco") THEN "Africa"
                ELSE "Oceania"
			END );
            
SELECT *
FROM youtube_statistics;

-- Compare video views across diff continents

SELECT 
      SUM(total_video_views),
      Continent
FROM youtube_statistics
GROUP BY Continent
ORDER BY 1 DESC;

-- -----------------------3.EARNING QUERIES-------------------------------------
-- -----------------------------------------------------------------------------

-- 3a.Channels with the highest/Lowest monthly/Yearly earnings.

SELECT
     Youtuber,
     lowest_monthly_earnings,
     highest_monthly_earnings,
     lowest_yearly_earnings,
     highest_yearly_earnings
FROM youtube_statistics;

SELECT
     Youtuber,
     lowest_monthly_earnings
FROM youtube_statistics
WHERE lowest_monthly_earnings = (
SELECT MIN(lowest_monthly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     lowest_monthly_earnings
FROM youtube_statistics
WHERE lowest_monthly_earnings = (
SELECT MAX(lowest_monthly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     highest_monthly_earnings
FROM youtube_statistics
WHERE highest_monthly_earnings = (
SELECT MIN(highest_monthly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     highest_monthly_earnings
FROM youtube_statistics
WHERE highest_monthly_earnings = (
SELECT MAX(highest_monthly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     lowest_yearly_earnings
FROM youtube_statistics
WHERE lowest_yearly_earnings = (
SELECT MAX(lowest_yearly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     highest_yearly_earnings
FROM youtube_statistics
WHERE highest_yearly_earnings = (
SELECT MAX(highest_yearly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     highest_yearly_earnings
FROM youtube_statistics
WHERE highest_yearly_earnings = (
SELECT MIN(highest_yearly_earnings)
FROM youtube_statistics);

SELECT
     Youtuber,
     lowest_yearly_earnings
FROM youtube_statistics
WHERE lowest_yearly_earnings = (
SELECT MIN(lowest_yearly_earnings)
FROM youtube_statistics);

-- -----------------------4.GEOSPATIAL QUERIES-------------------------------------
-- --------------------------------------------------------------------------------

-- --Retrieve channels originating from a specific country.

SELECT 
      Youtuber,
      Country
FROM youtube_statistics
WHERE Country = "India";

-- --------------------5.CATEGORY-BASED ANALYSIS-------------------------------------
-- ----------------------------------------------------------------------------------

-- -5a.Group channels by category (e.g., Music, Entertainment, Education).

SELECT
DISTINCT Categories
FROM youtube_statistics;


SELECT 
      categories,
      COUNT(Youtuber) as Youtube_channel_count
FROM youtube_statistics
GROUP BY categories
ORDER BY 2 DESC;

SELECT 
     Youtuber,
     categories
FROM youtube_statistics
WHERE categories = "Entertainment";

-- -5b.Calculate average subscribers and video views per category.

SELECT 
     categories,
     AVG(subscribers) as Avg_subscribers
FROM youtube_statistics
GROUP BY categories
ORDER BY 2;

SELECT 
     categories,
     AVG(total_video_views) as Avg_video_views
FROM youtube_statistics
GROUP BY categories
ORDER BY 2;

-- -5c.Popular categories

SELECT
	 categories,
     AVG(total_video_views) AS Avg_video_views
FROM youtube_statistics
GROUP BY categories
HAVING AVG(total_video_views) > (
  SELECT AVG(total_video_views)
  FROM youtube_statistics
);

-- ----------------------6. TEMPORAL TRENDS------------------------------------------
-- ----------------------------------------------------------------------------------

-- 6a.Analyze channel creation years.

SELECT 
	 COUNT(Youtuber),
     created_year
FROM youtube_statistics
GROUP BY created_year
ORDER BY 2;

-- 6b. Find channels created in a specific year.

SELECT 
	 Youtuber,
     created_year
FROM youtube_statistics
WHERE created_year = "2006";

-- ----------------------7.UNEMPLOYMENT RATE QUERIES------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- -7a. Retrieve channels from countries with low or high unemployment rates.

SELECT
     Unemployment_rate,
     CASE 
           WHEN Unemployment_rate < (SELECT
             AVG(Unemployment_rate)
             FROM youtube_statistics) THEN "Low"
           ELSE "High"
	 END as Unemployment_rate_rating
FROM youtube_statistics;


ALTER TABLE youtube_statistics
ADD COLUMN Unemployment_rate_rating VARCHAR(10);

UPDATE youtube_statistics
SET Unemployment_rate_rating = (
        CASE 
           WHEN Unemployment_rate < 9.9 THEN "Low"
           ELSE "High"
	   END);
       
SELECT 
	 Youtuber,
     Unemployment_rate_rating
FROM youtube_statistics
WHERE Unemployment_rate_rating = "Low";

--  7b.Explore how unemployment rates affect channel metrics.

SELECT 
     SUM(Total_video_views),
     Unemployment_rate_rating
FROM youtube_statistics
GROUP BY Unemployment_rate_rating
ORDER BY 2;

-- OPTIMIZING QUERY FOR POWER BI.
   
   ALTER TABLE youtube_statistics
   DROP COLUMN channel_type;
   
   SELECT *
   FROM youtube_statistics



    







   





    







   






    







   



