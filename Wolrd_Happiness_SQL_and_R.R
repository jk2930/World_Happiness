## World Happiness Report Analysis, accompanying SQL queries

# https://worldhappiness.report/faq/

library(dplyr)

library(readr)

allyears <- read_csv("C:/Users/jkjil/Downloads/happiness data csvs/allyears.csv")
View(allyears)

# all variables and score plotted against each other
pairs(allyears[,3:9]) 
# all show positive relationship with score
# generosity - score appears to be the weakest
# generosity - gdp also appears weak

cor(allyears$generosity, allyears$score) #0.1381325
plot(allyears$generosity, allyears$score)

cor(allyears$generosity, allyears$gdp_per_cap) # -0.01372633
plot(allyears$generosity, allyears$gdp_per_cap)
# generosity and gdp are slightly inversely related.  
# I wonder if the countries with high influences of generosity are 
# particularly happy.
high_generosity <- filter(allyears, generosity > 0.5) 
# highest happiness scores are UK, Malta, and Thailand, ranked in 20s and 30s
# also low ranks, Somaliland Region and Myanmar


#Trust in Government or Perception of Corruption?
plot(allyears$trust_gov, allyears$score)
# no apparent trend for trust_gov value <0.2; 
# 5 points stand out with trust_gov score >0.4 and overall score <4
# identify these 5 points in SQL:
# SELECT * FROM allyears WHERE trust_gov > 0.4 AND score <4;
# These 5 points are for Rwanda in each year
cor(allyears$trust_gov, allyears$score)# 0.3984526, lower than other factors & score
cor.test(allyears$trust_gov, allyears$score)
# analyze without Rwanda

woRwanda <- allyears %>% filter(country != "Rwanda")
plot(woRwanda$trust_gov, woRwanda$score)
cor(woRwanda$trust_gov, woRwanda$score) # removal of Rwanda bumps cor up to 0.4555532

plot(allyears$gdp_per_cap, allyears$score) 
cor(allyears$gdp_per_cap, allyears$score) # 0.7897241




plot(allyears$social_support, allyears$score) 
cor(allyears$social_support, allyears$score)# 0.6512672

plot(allyears$life_exp, allyears$score)
cor(allyears$life_exp, allyears$score)# 0.7428782


plot(allyears$generosity, allyears$score)
cor(allyears$generosity, allyears$score)#0.1381325

plot(allyears$year, allyears$score)
plot(allyears$score, allyears$year) # clearer visualization
cor(allyears$year, allyears$score)#0.1381325



allyears %>% group_by(year) %>% summarise(mean(score)) #mean scores are close
# 1  2015          5.38
# 2  2016          5.38
# 3  2017          5.35
# 4  2018          5.37
# 5  2019          5.41




rank_score <- read_csv("C:/Users/jkjil/Downloads/happiness data csvs/inner_join_country_rank_score_analysis.csv")
View(rank_score)
plot(rank_score$max_score, rank_score$score_range) 
cor(rank_score$max_score, rank_score$score_range) # -0.312165
# one apparent outlier near 7, 2.  Only point with score_range >2
max_range <- rank_score %>% filter(score_range > 2) # Venezuela
# rank 2015-2019: 23, 44, 82, 102, 108
# score: 6.8 (2015) - 4.7 (2019)


h2015 <- read_csv("C:/Users/jkjil/Downloads/happiness data csvs/2015.csv")
h2016 <- read_csv("C:/Users/jkjil/Downloads/happiness data csvs/2016.csv")
View(h2015)
View(h2016)

pairs(h2015[,c(4,6:12)])

plot(h2015$`Dystopia Residual`, h2015$`Happiness Score`)
cor(h2015$`Dystopia Residual`, h2015$`Happiness Score`) #0.5304735

plot(h2016$`Dystopia Residual`, h2016$`Happiness Score`)
cor(h2016$`Dystopia Residual`, h2016$`Happiness Score`) #0.5437376

 
