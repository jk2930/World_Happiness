## INTRODUCTION

## The purpose of this file is to demonstrate my independent study in SQL.  Following some
## coursework (Coursera), I wanted to apply and develop my skill with SQL.
## To do this, I first created a database, then wrote queries to provide insights from the
## complex data.

## The database created here, "Happy" is of the World Happiness Report data 
## for years 2015 - 2019.  I obtained the data through Kaggle.  I wish to acknowledge 
## that some of the more interesting insights would be better obtained through more complex
## analysis than SQL is suited for.  However, this is a useful set of data for SQL 
## demonstration, as some years offer different columns and different countries/regions
## from others.

## DATA OVERVIEW: 
## World Happiness Report asks thousands of survey participants in each country to rate their
## subjective wellbeing on a scale of 1 - 10.  The Score column is the average of these reports for each country.
## The six factors reported here (GDP per capita, social support, life expectancy, freedom, generosity, & trust in government)
## are used because they are supposed to both be a true factor in the experience of life, and they can be compared across any
## country.  The numbers in the data sets are NOT the measures of any of these factors.  Rather, they are adjusted values to
## indicate the EXTENT to which the factor contributes to the country's average happiness score.

##

CREATE DATABASE HAPPY;

USE happy;

DROP TABLE happy.h2019;

CREATE TABLE happy.h2019(
   overall_rank int,
   country char(200), -- original "Country or Region". regions like Northern Cyprus and Palestinian Territories
   score DECIMAL (4,3),
   gpd_per_cap DECIMAL (4,3),
   social_support DECIMAL (4,3),
   life_exp DECIMAL (4,3), -- "Healthy life expectancy"
   freedom DECIMAL (4,3), -- "Freedom to make life choices"
   generosity DECIMAL (4,3),
   trust_gov DECIMAL (4,3)) -- "Perceptions of corruption"
   ;

SELECT * FROM happy.h2019;

DROP TABLE happy.h2018;

CREATE TABLE happy.h2018(
   overall_rank int,
   country char(200), -- original "Country or Region". regions like Northern Cyprus and Palestinian Territories
   score DECIMAL (4,3),
   gpd_per_cap DECIMAL (4,3),
   social_support DECIMAL (4,3),
   life_exp DECIMAL (4,3), -- "Healthy life expectancy"
   freedom DECIMAL (4,3), -- "Freedom to make life choices"
   generosity DECIMAL (4,3),
   trust_gov DECIMAL (4,3)) -- "Perceptions of corruption"
   ;
   
   SELECT * FROM happy.h2018;
  
DROP TABLE h2017;  
  
CREATE TABLE happy.h2017(
   country char(200),
   overall_rank int,
   score DECIMAL (4,3),
   whisker_high DECIMAL (4,3),
   whisker_low DECIMAL (4,3),
   gdp_per_cap DECIMAL (4,3),
   social_support DECIMAL (4,3), -- "Family"
   life_exp DECIMAL (4,3), -- "Healthy life expectancy"
   freedom DECIMAL (4,3),
   generosity DECIMAL (4,3),
   trust_gov DECIMAL (4,3),
   dystopia_resid DECIMAL (4,3)) -- compare to 'dystopia' of lowest levels for all factors
   ;
   
SELECT * FROM h2017;
   
CREATE TABLE happy.h2016(
   country char(200),
   region char(200),  -- last year "region" is own column. eg. Western Europe, Southern Asia, etc.
   overall_rank int,
   score DECIMAL (4,3),
   whisker_low DECIMAL (4,3), -- lower confidence interval for score
   whisker_high DECIMAL (4,3), -- upper confidence interval
   gdp_per_cap DECIMAL (4,3),
   social_support DECIMAL (4,3), -- "Family"
   life_exp DECIMAL (4,3), -- or "Health"
   freedom DECIMAL (4,3),
   trust_gov DECIMAL (4,3),
   generosity DECIMAL (4,3),
   dystopia_resid DECIMAL (4,3)) -- compare to 'dystopia' of lowest levels for all factors
   ;

CREATE TABLE happy.h2015(
  country char(200),
   region char(200),  -- "region" is own column. eg. Western Europe, Southern Asia, etc.
   overall_rank int,
   score DECIMAL (4,3),
   st_error DECIMAL (6,5), -- of score
   gdp_per_cap DECIMAL (4,3),
   social_support DECIMAL (4,3), -- "Family"
   life_exp DECIMAL (4,3), -- or "Health"
   freedom DECIMAL (4,3),
   trust_gov DECIMAL (4,3),
   generosity DECIMAL (4,3),
   dystopia_resid DECIMAL (4,3)) -- compare to 'dystopia' of lowest levels for all factors
   ;
   
   SELECT * FROM h2015;
   ## Data sets from Kaggle imported after creating the tables. 
   ## Checking the 5 data tables
   SELECT * FROM h2015;
   SELECT * FROM h2016;
   SELECT * FROM h2017;
   SELECT * FROM h2018;
   SELECT * FROM h2019;
   
   ## Add column for year to each table
ALTER TABLE h2015
ADD COLUMN year INT DEFAULT 2015 NOT NULL;

ALTER TABLE h2016
ADD COLUMN year INT DEFAULT 2016 NOT NULL;

ALTER TABLE h2017
ADD COLUMN year INT DEFAULT 2017 NOT NULL;

ALTER TABLE h2018
ADD COLUMN year INT DEFAULT 2018 NOT NULL;

ALTER TABLE h2019
ADD COLUMN year INT DEFAULT 2019 NOT NULL;

   SELECT * FROM h2015;
   SELECT * FROM h2016;
   SELECT * FROM h2017;
   SELECT * FROM h2018;
   SELECT * FROM h2019;

## This method produces no error, and also no 'year' column
#UPDATE h2016
#SET year = 2016;

## With the "year" column, data can now be combined into a single table.  
## This would be useful for applications including pivot-tables and other 
## inter-year analyses.

## troubleshooting errors
## This chunk gave error 1054 - for a column name not found in the h2015 table
#CREATE TABLE allyears
#(
	SELECT overall_rank , country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year 
	FROM h2015
	UNION
	SELECT overall_rank, country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year
	FROM h2019;
    #)
#;

## Solve the error - let's look at the column names!
SHOW columns FROM h2015;  
# looks like gdp_per_cap is there, so this is likely an issue with unprintable characters.  
# Solution: rename the the columumns

ALTER TABLE h2015 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
ALTER TABLE h2016 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
ALTER TABLE h2017 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
ALTER TABLE h2018 RENAME COLUMN gdp_per_cap TO gdp_per_cap; -- produced error
ALTER TABLE h2019 RENAME COLUMN gdp_per_cap TO gdp_per_cap;

SHOW columns FROM h2018; 
SHOW columns FROM h2019;  -- these ones have "gpd" in place of "gdp"

ALTER TABLE h2018 RENAME COLUMN gpd_per_cap TO gdp_per_cap; 
ALTER TABLE h2019 RENAME COLUMN gpd_per_cap TO gdp_per_cap;


## UNION FOR ALL YEARS OF DATA
# Now can create the table without error
DROP TABLE allyears;
CREATE TABLE allyears 
	(
	SELECT overall_rank , country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year 
	FROM h2015
	UNION
	SELECT overall_rank, country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year
	FROM h2016
    UNION
	SELECT overall_rank, country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year
	FROM h2017
    UNION
	SELECT overall_rank, country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year
	FROM h2018
    UNION
	SELECT overall_rank, country, score, gdp_per_cap, social_support, 
			life_exp, freedom, generosity, trust_gov, year
	FROM h2019
    );

SELECT * FROM allyears; -- looks good


## INVESTIGATIVE QUERIES

# When and who is the data from?
SELECT COUNT(year)  FROM allyears; -- 781 total entries over the 5 years

SELECT COUNT(year)  FROM allyears
GROUP BY year; -- 155 to 158 entries per year

# To look at how a country's report has changed over the years 2015 - 2019:
SELECT * FROM allyears
WHERE country = "United States";


## TRUST IN GOVERNMENT??
# To look at which countries' happiness is most influenced by the degree of trust in government:
SELECT overall_rank, country, trust_gov, year 
FROM allyears
ORDER BY trust_gov DESC 
LIMIT 30;  

# Some interesting takeaways from this query:
-- greatest trust level is 0.552 (Rwanda 2015)
-- some countries come up repeatedly
-- at first glance, scores look higher in 2015 and 2016
-- overall ranks are clustered around high and low numbers 
	-- does this mean the data is not reported the same in every country?
	-- No, this is likely an indication that some rated-happier countries are happy due to trust in government,
    -- and other rated-less-happy countries have lower scores due to a significant lack of trust in government.
    
## Finding the outliers on a scatter plot (produced in R) of trust_gov against score.
SELECT * FROM allyears
	WHERE trust_gov > 0.4 AND score <4; -- all from Rwanda
    
 # Let's look at all of the countries trust_gov's and ranks   

SELECT country, overall_rank,  trust_gov, year -- reordered columns to more easily compare rank and trust
		FROM allyears
		ORDER BY trust_gov DESC; 
# Indonesia, along with several Eastern European countries report zero to nearly zero influence of trust in government on
# happiness.  Years 2015 and 2016 include a region column, so we can continue to evaluate this by region in these years.

SELECT country, region, overall_rank,  trust_gov, year  -- 2015 and 2016 data 
		FROM h2015 
        UNION 
			SELECT country, region, overall_rank,  trust_gov, year
				FROM h2016
        ORDER BY trust_gov; 
 
 ## SUMMARISE (AVERAGE) ACROSS REGIONS
SELECT region, avg(trust_gov) as trust_gov
	FROM h2015 
        UNION 
			SELECT region, avg(trust_gov)
				FROM h2016
	GROUP BY region  -- Western Europe did not aggregate across the two years.  All others did
    ORDER BY trust_gov; 
## Influence of trust in government on happiness ranges among regions from 0.088 (Central & Eastern Europe) to
##  0.371 (Australia and New Zealand).  It is only above 2 for ANZ and North America, along with one value for Western Europe
## (though the average of the W Europe scores is less than 2).  Overall, this suggests that trust in government is not 
## the greatest predictor of resident happiness, and it poses the question of why it is of higher significance in North America and ANZ.

 
 
## DYSTOPIA RESIDUAL : how each country compares to "dystopia", the nonexistant country with the lowest score in all factors
## Dystopia Residual only included in 2015 and 2016 data sets
SELECT * FROM h2015
	WHERE dystopia_resid = 
		(SELECT MAX(dystopia_resid) FROM h2015); -- Mexico, rank 14
        
SELECT * FROM h2016
	WHERE dystopia_resid = 
		(SELECT MAX(dystopia_resid) FROM h2016); -- Somalia, rank 76
        

SELECT * FROM h2015
	WHERE dystopia_resid = 
		(SELECT MIN(dystopia_resid) FROM h2015); -- Syria, rank 156
        
SELECT * FROM h2016
	WHERE dystopia_resid = 
		(SELECT MIN(dystopia_resid) FROM h2016); -- Syria, rank 156
        
SELECT country, overall_rank, score, social_support, dystopia_resid
	FROM h2016
    ORDER BY dystopia_resid;
    
SELECT region, avg(dystopia_resid) as dystopia
	FROM h2015 
        UNION 
			SELECT region, avg(dystopia_resid)
				FROM h2016
	GROUP BY region  -- By region, all between 1.9 and 2.9
    ORDER BY dystopia; -- 


## MAKING SENSE OF gdp_per_cap IN THESE DATASETS
        
SELECT * FROM allyears
	WHERE gdp_per_cap = 0; -- one entry per year: Congo, Somalia, Central African Republic, Somalia, Somalia
    -- These are entries for which gdp per capita was not used to explain the country's overall happiness

SELECT * FROM allyears
	WHERE gdp_per_cap = 
		(SELECT MAX(gdp_per_cap) from allyears); -- Qatar, 2017, gdp_per_cap = 1.871
        
    
SELECT country, overall_rank, score, social_support
	FROM allyears
    ORDER BY overall_rank
    LIMIT 50
  ;
 
 
 ## YEAR-TO-YEAR COMPARISONS OF SCORE AND RANK
## Inner join on all tables by country: How does each country compare year-to-year?  
SELECT h2015.country, h2015.overall_rank as 'rank_2015', h2016.overall_rank as 'rank_2016', 
	h2017.overall_rank as 'rank_2017', h2018.overall_rank as 'rank_2018', h2019.overall_rank as 'rank_2019',
	h2015.score as 'score_2015', h2016.score as 'score_2016', 
	h2017.score as 'score_2017', h2018.score as 'rank_2018', h2019.score as 'score_2019'
	FROM h2015
    INNER JOIN h2016 ON h2015.country = h2016.country
    INNER JOIN h2017 ON h2015.country = h2017.country
    INNER JOIN h2018 ON h2015.country = h2018.country
    INNER JOIN h2019 ON h2015.country = h2019.country; 

## Repeat col names
#SELECT avg(overall_rank) from (   
SELECT h2015.country, h2015.overall_rank , h2016.overall_rank, 
	h2017.overall_rank, h2018.overall_rank, h2019.overall_rank,
	h2015.score, h2016.score, 
	h2017.score, h2018.score, h2019.score
	FROM h2015
    INNER JOIN h2016 ON h2015.country = h2016.country
    INNER JOIN h2017 ON h2017.country = h2015.country
    INNER JOIN h2018 ON h2015.country = h2018.country
    INNER JOIN h2019 ON h2015.country = h2019.country
    #) as A
    ; 
    
    
    ## Inner join on all tables by country: How does each country compare year-to-year?  
			## With analysis of change of rank and score across years.  
            ## Some large differences across years suggest: Many coutries are either more stable, or have more reliable data reocording across years.
    
    SELECT h2015.country, h2015.overall_rank as 'rank_2015', h2016.overall_rank as 'rank_2016', 
	h2017.overall_rank as 'rank_2017', h2018.overall_rank as 'rank_2018', h2019.overall_rank as 'rank_2019',
    GREATEST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank)
			as 'max_rank',
    LEAST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank)
			as 'min_rank',
	GREATEST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank) 
			- LEAST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank) 
            as 'rank_range',
	h2015.score as 'score_2015', h2016.score as 'score_2016', 
	h2017.score as 'score_2017', h2018.score as 'score_2018', h2019.score as 'score_2019',
    GREATEST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score)
			as 'max_score',
    LEAST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score)
			as 'min_score',
	GREATEST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score) 
			- LEAST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score) 
            as 'score_range'
	FROM h2015
    INNER JOIN h2016 ON h2015.country = h2016.country
    INNER JOIN h2017 ON h2015.country = h2017.country
    INNER JOIN h2018 ON h2015.country = h2018.country
    INNER JOIN h2019 ON h2015.country = h2019.country
    ;   -- exporting to R for visualizing
    
## Which countries show the most change over these 5 years?
## SUMMARIZED TO SHOW CHANGE IN RANK AND SCORE ACROSS THE 5 YEARS
##  What does it mean if a country experienced more or less change in overall happiness?        
SELECT country, min_rank, max_rank, rank_range, min_score, max_score, score_range
	FROM
        (SELECT h2015.country, h2015.overall_rank as 'rank_2015', h2016.overall_rank as 'rank_2016', 
	h2017.overall_rank as 'rank_2017', h2018.overall_rank as 'rank_2018', h2019.overall_rank as 'rank_2019',
    GREATEST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank)
			as 'max_rank',
    LEAST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank)
			as 'min_rank',
	GREATEST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank) 
			- LEAST(h2015.overall_rank, h2016.overall_rank, h2017.overall_rank, h2018.overall_rank, h2019.overall_rank) 
            as 'rank_range',
	h2015.score as 'score_2015', h2016.score as 'score_2016', 
	h2017.score as 'score_2017', h2018.score as 'score_2018', h2019.score as 'score_2019',
    GREATEST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score)
			as 'max_score',
    LEAST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score)
			as 'min_score',
	GREATEST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score) 
			- LEAST(h2015.score, h2016.score, h2017.score, h2018.score, h2019.score) 
            as 'score_range'
	FROM h2015
    INNER JOIN h2016 ON h2015.country = h2016.country
    INNER JOIN h2017 ON h2015.country = h2017.country
    INNER JOIN h2018 ON h2015.country = h2018.country
    INNER JOIN h2019 ON h2015.country = h2019.country
    ) as A
    ORDER BY score_range DESC
    LIMIT 20
    ; 
    
