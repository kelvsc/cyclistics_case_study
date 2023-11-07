# Cyclistics Case Study

## Intro

In this example case study, we analyze historical bike-share data to identify trends and insights in order to design effective marketing strategies and tactics.

Tools used in this case study include Google BigQuery for data analysis and Google Looker Studio for data visualization.

## Background & Business Task

Cyclistic is a bike-share company in Chicago. The company believes its future success depends on maximizing the number of annual memberships. Therefore, they want to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, the company will
design a new marketing strategy to convert casual riders into annual members.

*Member - customers who purchased an annual membership*

*Casual rider - customers who purchased a single-ride or full-day pass*

### Potential Analysis Questions

* How many total rides have members taken vs casual riders?
* What is the average length of ride for members vs casual riders?
* What are the busiest/slowest months for members vs casual riders?
* Are there differences in the daily number of rides for members vs casual riders?
* What time of the day during the week/weekend is the busiest for members vs casual riders?
* How do the types of bikes used differ between members vs casuals?
* What is the average length of ride for regular and electric bikes for members and casual riders?
* Which stations are the most popular starting and ending points for annual members vs casual riders?
* Are there specific routes or connections between stations that are more popular among members vs casual riders?

## Prepare

Historical bike-share data has been provided by Cyclistic under a [data license agreement](https://divvybikes.com/data-license-agreement)  and can be downloaded [here](https://divvy-tripdata.s3.amazonaws.com/index.html).

For the purposes of this case study, we will be using data from September 2022 to October 2023. Each table (a total of 12) was downloaded to a local machine and then subsequently uploaded into Google BigQuery.

However, because we need to do an analysis on data spanning one full year, we merge all 12 tables into one table.
```
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2022_11_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2022_12_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_01_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_02_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_03_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_04_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_05_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_06_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_07_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_08_data
UNION ALL
SELECT * FROM cs-bike-share-analysis.Trip_Data.2023_09_data
```

We see that all data is already structured into 5,674,399 rows and 13 columns.


