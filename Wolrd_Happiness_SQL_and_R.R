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

##

# CREATE DATABASE HAPPY;
# 
# USE happy;
# 
# DROP TABLE happy.h2019;
# 
# CREATE TABLE happy.h2019(
#   overall_rank int,
#   country char(200), -- original "Country or Region". regions like Northern Cyprus and Palestinian Territories
#   score DECIMAL (4,3),
#   gpd_per_cap DECIMAL (4,3),
#   social_support DECIMAL (4,3),
#   life_exp DECIMAL (4,3), -- "Healthy life expectancy"
#   freedom DECIMAL (4,3), -- "Freedom to make life choices"
#   generosity DECIMAL (4,3),
#   trust_gov DECIMAL (4,3)) -- "Perceptions of corruption"
# ;
# 
# SELECT * FROM happy.h2019;
# 
# DROP TABLE happy.h2018;
# 
# CREATE TABLE happy.h2018(
#   overall_rank int,
#   country char(200), -- original "Country or Region". regions like Northern Cyprus and Palestinian Territories
#   score DECIMAL (4,3),
#   gpd_per_cap DECIMAL (4,3),
#   social_support DECIMAL (4,3),
#   life_exp DECIMAL (4,3), -- "Healthy life expectancy"
#   freedom DECIMAL (4,3), -- "Freedom to make life choices"
#   generosity DECIMAL (4,3),
#   trust_gov DECIMAL (4,3)) -- "Perceptions of corruption"
# ;
# 
# SELECT * FROM happy.h2018;
# 
# DROP TABLE h2017;  
# 
# CREATE TABLE happy.h2017(
#   country char(200),
#   overall_rank int,
#   score DECIMAL (4,3),
#   whisker_high DECIMAL (4,3),
#   whisker_low DECIMAL (4,3),
#   gdp_per_cap DECIMAL (4,3),
#   social_support DECIMAL (4,3), -- "Family"
#   life_exp DECIMAL (4,3), -- "Healthy life expectancy"
#   freedom DECIMAL (4,3),
#   generosity DECIMAL (4,3),
#   trust_gov DECIMAL (4,3),
#   dystopia_resid DECIMAL (4,3)) -- compare to 'dystopia' of lowest levels for all factors
# ;
# 
# SELECT * FROM h2017;
# 
# CREATE TABLE happy.h2016(
#   country char(200),
#   region char(200),  -- last year "region" is own column. eg. Western Europe, Southern Asia, etc.
#   overall_rank int,
#   score DECIMAL (4,3),
#   whisker_low DECIMAL (4,3), -- lower confidence interval for score
#   whisker_high DECIMAL (4,3), -- upper confidence interval
#   gdp_per_cap DECIMAL (4,3),
#   social_support DECIMAL (4,3), -- "Family"
#   life_exp DECIMAL (4,3), -- or "Health"
#   freedom DECIMAL (4,3),
#   trust_gov DECIMAL (4,3),
#   generosity DECIMAL (4,3),
#   dystopia_resid DECIMAL (4,3)) -- compare to 'dystopia' of lowest levels for all factors
# ;
# 
# CREATE TABLE happy.h2015(
#   country char(200),
#   region char(200),  -- "region" is own column. eg. Western Europe, Southern Asia, etc.
#   overall_rank int,
#   score DECIMAL (4,3),
#   st_error DECIMAL (6,5), -- of score
#   gdp_per_cap DECIMAL (4,3),
#   social_support DECIMAL (4,3), -- "Family"
#   life_exp DECIMAL (4,3), -- or "Health"
#   freedom DECIMAL (4,3),
#   trust_gov DECIMAL (4,3),
#   generosity DECIMAL (4,3),
#   dystopia_resid DECIMAL (4,3)) -- compare to 'dystopia' of lowest levels for all factors
# ;
# 
# SELECT * FROM h2015;
# ## Data sets from Kaggle imported after creating the tables. 
# ## Checking the 5 data tables
# SELECT * FROM h2015;
# SELECT * FROM h2016;
# SELECT * FROM h2017;
# SELECT * FROM h2018;
# SELECT * FROM h2019;
# 
# ## Add column for year to each table
# ALTER TABLE h2015
# ADD COLUMN year INT DEFAULT 2015 NOT NULL;
# 
# ALTER TABLE h2016
# ADD COLUMN year INT DEFAULT 2016 NOT NULL;
# 
# ALTER TABLE h2017
# ADD COLUMN year INT DEFAULT 2017 NOT NULL;
# 
# ALTER TABLE h2018
# ADD COLUMN year INT DEFAULT 2018 NOT NULL;
# 
# ALTER TABLE h2019
# ADD COLUMN year INT DEFAULT 2019 NOT NULL;
# 
# SELECT * FROM h2015;
# SELECT * FROM h2016;
# SELECT * FROM h2017;
# SELECT * FROM h2018;
# SELECT * FROM h2019;
# 
# ## This method produces no error, and also no 'year' column
# #UPDATE h2016
# #SET year = 2016;
# 
# ## With the "year" column, data can now be combined into a single table.  
# ## This would be useful for applications including pivot-tables and other 
# ## inter-year analyses.
# 
# ## troubleshooting errors
# ## This chunk gave error 1054 - for a column name not found in the h2015 table
# #CREATE TABLE allyears
# #(
# SELECT overall_rank , country, score, gdp_per_cap, social_support, 
# life_exp, freedom, generosity, trust_gov, year 
# FROM h2015
# UNION
# SELECT overall_rank, country, score, gdp_per_cap, social_support, 
# life_exp, freedom, generosity, trust_gov, year
# FROM h2019;
# #)
# #;
# 
# ## Solve the error - let's look at the column names!
# SHOW columns FROM h2015;  
# # looks like gdp_per_cap is there, so this is likely an issue with unprintable characters.  
# # Solution: rename the the columumns
# 
# ALTER TABLE h2015 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
# ALTER TABLE h2016 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
# ALTER TABLE h2017 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
# ALTER TABLE h2018 RENAME COLUMN gdp_per_cap TO gdp_per_cap; -- produced error
# ALTER TABLE h2019 RENAME COLUMN gdp_per_cap TO gdp_per_cap;
# 
# SHOW columns FROM h2018; 
# SHOW columns FROM h2019;  -- these ones have "gpd" in place of "gdp"
# 
# ALTER TABLE h2018 RENAME COLUMN gpd_per_cap TO gdp_per_cap; 
# ALTER TABLE h2019 RENAME COLUMN gpd_per_cap TO gdp_per_cap;
# 
# # Now can create the table without error
# DROP TABLE allyears;
# CREATE TABLE allyears
# (
#   SELECT overall_rank , country, score, gdp_per_cap, social_support, 
#   life_exp, freedom, generosity, trust_gov, year 
#   FROM h2015
#   UNION
#   SELECT overall_rank, country, score, gdp_per_cap, social_support, 
#   life_exp, freedom, generosity, trust_gov, year
#   FROM h2016
#   UNION
#   SELECT overall_rank, country, score, gdp_per_cap, social_support, 
#   life_exp, freedom, generosity, trust_gov, year
#   FROM h2017
#   UNION
#   SELECT overall_rank, country, score, gdp_per_cap, social_support, 
#   life_exp, freedom, generosity, trust_gov, year
#   FROM h2018
#   UNION
#   SELECT overall_rank, country, score, gdp_per_cap, social_support, 
#   life_exp, freedom, generosity, trust_gov, year
#   FROM h2019
# );
# 
# SELECT * FROM allyears; -- looks good
# 
# 
# ## Now some queries to look at the data:
# 
# # When and who is the data from?
# SELECT COUNT(year)  FROM allyears; -- 781 total entries over the 5 years
# 
# SELECT COUNT(year)  FROM allyears
# GROUP BY year; -- 155 to 158 entries per year
# 
# # To look at how a country's scores have changed over the years 2015 - 2019:
# SELECT * FROM allyears
# WHERE country = "United States";
# 
# # To look at which countries have the greatest trust in government, from most trust to least:
# SELECT overall_rank, country, trust_gov, year 
# FROM allyears
# ORDER BY trust_gov DESC 
# LIMIT 30;  
# 
# # Some interesting takeaways from this query:
# -- greatest trust is 0.552 (Rwanda 2015)
# -- some countries come up repeatedly
# -- at first glance, scores look higher in 2015 and 2016
# -- overall ranks are clustered around high and low numbers 
# -- does this mean the data is not reported the same in every country?
#   -- Would we expect Rwanda to have high trust in government with overall_rank of 154,
# -- while also in 2015, Denmark has a slightly lower trust in government (0.484) and an overall_rank of 3.
# 
# # Let's look at all of the countries trust_gov's and ranks   
# 
# SELECT country, overall_rank,  trust_gov, year -- reordered columns to more easily compare rank and trust
# FROM allyears
# ORDER BY trust_gov DESC; 
# 
# ## Key takeaways:  It seems to be that the trust variable was actually the perception of corruption variable.  
# ## There is no obvious association between the trust_gov variable and rank, nor a clear split between high and low
# ## trust and rank countries.  Without the metrics of how data was collected, I cannot alter the data to adjust for this.
# ## The trust_gov variable shall not be considered in the analysis.
# 
# SELECT * FROM allyears;  ## exporting to do exploratory data analysis with making graphs in R