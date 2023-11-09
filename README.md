# Cyclistics Case Study

## Intro

In this example case study, we analyze historical bike-share data to identify trends and insights in order to design effective marketing strategies and tactics.

Tools used in this case study include Google BigQuery for data analysis with SQL, and Google Looker Studio for data visualization.

<br>

## Quick Links

* [Background & Business Task](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#background--business-task)
* [Data Preparation](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#data-preparation)
* [Data Processsing](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#data-processing)
* [Data Analysis](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#data-analysis)
* [Data Visualization](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#data-visualization)
* [Summary](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#summary-of-differences-between-customer-type)
* [Recommendations](https://github.com/kelvsc/data-analysis/tree/cyclistics-case-study#recommendations)

<br>

## Background & Business Task

Cyclistic is a bike-share company in Chicago. The company believes its future success depends on maximizing the number of annual memberships. Therefore, they want to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, the company will
design a new marketing strategy to convert casual riders into annual members.

*Member - customers who purchased an annual membership*

*Casual rider - customers who purchased a single-ride or full-day pass*

<br>

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

<br>

## Data Preparation

Historical bike-share data has been provided by Cyclistic under a [data license agreement](https://divvybikes.com/data-license-agreement)  and can be downloaded [here](https://divvy-tripdata.s3.amazonaws.com/index.html).

For the purposes of this case study, we will be using data from September 2022 to October 2023. Each table (a total of 12) was downloaded to a local machine and then subsequently uploaded into Google BigQuery.

However, because we need to do an analysis of data spanning one full year, we merge all 12 tables into one table using the following SQL query.
```
SELECT * FROM cs-bike-share-analysis.Trip_Data.2022_10_data
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

| FIELDNAME | TYPE | DESCRIPTION
| -------- | ------- | ------
| ride_id  | STRING | Primary key that identifies a unique ride
| rideable_type | STRING | Type of bike: classic, electric, docked
| started_at | TIMESTAMP | Date and time the trip began
| ended_at | TIMESTAMP | Date and time the trip stopped
| start_station_name | STRING | Name of the station the trip started from
| start_station_id | STRING | Foreign key that identifies the ID of the station the trip started from
| end_station_name | STRING | Name of the station the trip ended at
| end_station_id | STRING | Foreign key that identifies the ID of the station the trip ended at
| start_lat | FLOAT | Latitude the trip started from
| start_lng | FLOAT | Longitude the trip started from
| end_lat | FLOAT | Latitude the trip ended at
| end_lng | FLOAT | Longitude the trip ended at
| member_casual | STRING | Customer type: member or casual

<br>

## Data Processing

**Let's start cleaning the table by checking if there are any nulls.**
```
SELECT
  COUNTIF(ride_id IS NULL) AS ride_id_null,
  COUNTIF(rideable_type IS NULL) AS rideable_type_null,
  COUNTIF(started_at IS NULL) AS started_at_null,
  COUNTIF(ended_at IS NULL) AS ended_at_null,
  COUNTIF(start_station_name IS NULL) AS start_station_name_null,
  COUNTIF(start_station_id IS NULL) AS start_station_id_null,
  COUNTIF(start_lat IS NULL) AS start_lat_null,
  COUNTIF(start_lng IS NULL) AS start_lng_null,
  COUNTIF(end_station_name IS NULL) AS end_station_name_null,
  COUNTIF(end_station_id IS NULL) AS end_station_id_null,
  COUNTIF(end_lat IS NULL) AS end_lat_null,
  COUNTIF(end_lng IS NULL) AS end_lng_null,
  COUNTIF(member_casual IS NULL) AS member_casual_null
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
```

<img src="https://raw.githubusercontent.com/kelvsc/data-analysis/02-process/02-process-01.png" width ="1000">

We see that there are nulls only for start_station_name, start_station_id, end_station_name, end_station_id, end_lat, and end_lng. We will need to remove these nulls from our analysis.

<br>

**Let's check if there are any duplicates.**
```
SELECT
  COUNT (DISTINCT ride_id) AS num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
```

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/3a0f6795-84ea-4160-9573-2e05866f4842" width = "150">

This matches up with the number of rows (5,674,399) which tells us there should be no duplicates in this table.

<br>

**Since we need days, months and trip length for some of our questions, let’s doublecheck if the data looks correct. Starting with how many days are in day_of_week.**
```
SELECT
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  day_of_week
ORDER BY
  day_of_week
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/baba6f24-c602-4af6-8770-11d86d73b5a3" width="250">

Looks correct.

<br>
<br>

**Now let's doublecheck that we have exactly 12 months.**
```
SELECT
  EXTRACT(MONTH FROM started_at) AS months
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  months
ORDER BY
  months
```

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/95801b54-e158-41f1-a72b-a2a3fc38879d" width="150">

Looks correct.

<br>
<br>

**Finally, let's doublecheck trip duration.**
```
SELECT
  ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS avg_trip_length_min,
  ROUND(MIN(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS min_trip_length_min,
  ROUND(MAX(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS max_trip_length_min,
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
```

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/2902cd88-fd18-4f58-a2d7-536d2f845dac" width="400">

<br>

Hmm, well this doesn't look right. We have a minimum trip length of -168 minutes and a max trip length of 98,489 minutes.

<br>
<br>

**Let's take a closer look at each observation.**
```
SELECT
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
ORDER BY
  trip_length_min
LIMIT 500
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/459757f9-4afd-4fe0-9c6e-286e3a9dddea" width="150"> <img src="https://github.com/kelvsc/data-analysis/assets/150187892/affa4c4a-87b4-4f85-b622-3863cd36bdcd" width="150">

Yikes. Not only are there trips with negative minutes, but also a bunch of 0s!

<br>
<br>

**What about the other end?**
```
SELECT
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
ORDER BY
  trip_length_min DESC
LIMIT 500
```

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/0203bcf4-a577-4dd2-abdf-47170c7d7c42" width="150"> <img src="https://github.com/kelvsc/data-analysis/assets/150187892/78b80c7c-1bea-4974-934d-1dd881755dab" width="150">

It looks like there is an issue with the upper-end as well. We'll need to remove these invalid rows.

<br>
<br>

**But first, let's see if this has anything to do with customer type.**
```
SELECT
  member_casual,
  ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS avg_trip_length_min,
  ROUND(MIN(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS min_trip_length_min,
  ROUND(MAX(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS max_trip_length_min,
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  member_casual
```

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/be69ed80-edf7-4e54-9ee4-51934c8a23a4" width="500">

It appears not specific to customer type.

<br>
<br>

**What about bike type?**
```
SELECT
  rideable_type,
  ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS avg_trip_length_min,
  ROUND(MIN(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS min_trip_length_min,
  ROUND(MAX(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS max_trip_length_min,
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  rideable_type
```

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/6709ea97-b77f-49c7-bd82-ba03c6ec1520" width="450">

It looks like docked_bikes have seemingly the most incorrect data. When we ask around, we find out that docked bikes are bikes that have been taken out of circulation for quality control and thus should not be included in our analysis.

<br>
<br>

**Alright, let's clean this up by creating a new table to remove docked bikes, nulls, and where trip length is less than 0 or greater than 1440 minutes (24 hours). At the same time, let's also doublecheck for nulls again.**
```
WITH cleaned AS (SELECT
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  CASE EXTRACT(MONTH FROM started_at) -- Extract the month from started_at and make it easier to read
    WHEN 1 THEN "January"
    WHEN 2 THEN "February"
    WHEN 3 THEN "March"
    WHEN 4 THEN "April"
    WHEN 5 THEN "May"
    WHEN 6 THEN "June"
    WHEN 7 THEN "July"
    WHEN 8 THEN "August"
    WHEN 9 THEN "September"
    WHEN 10 THEN "October"
    WHEN 11 THEN "November"
    WHEN 12 THEN "December"
    END AS month,
  CASE EXTRACT(DAYOFWEEK FROM started_at) -- Extract the day from start_at and make it easier to read
    WHEN 1 THEN "Sunday"
    WHEN 2 THEN "Monday"
    WHEN 3 THEN "Tuesday"
    WHEN 4 THEN "Wednesday"
    WHEN 5 THEN "Thursday"
    WHEN 6 THEN "Friday"
    WHEN 7 THEN "Saturday"
    END AS day_of_week,
  EXTRACT(HOUR from started_at) AS hour_of_day, -- extract the hour the trip started at
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS trip_length_min, -- calculate the trip length in minutes
  start_station_name,
  start_lat,
  start_lng,
  end_station_name,
  end_lat,
  end_lng,
  CONCAT(start_station_name, " to ", end_station_name) AS route, -- make a new column to determine routes taken
  member_casual
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
WHERE -- discard the observations that will mess up our analysis
  start_station_name IS NOT NULL AND
  end_station_name IS NOT NULL AND
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) BETWEEN 1 AND 1440 AND
  rideable_type != "docked_bike"
)


SELECT
  COUNTIF(ride_id IS NULL) AS ride_id_null,
  COUNTIF(rideable_type IS NULL) AS rideable_type_null,
  COUNTIF(started_at IS NULL) AS started_at_null,
  COUNTIF(ended_at IS NULL) AS ended_at_null,
  COUNTIF(month IS NULL) AS month_null,
  COUNTIF(day_of_week IS NULL) AS day_of_week_null,
  COUNTIF(hour_of_day IS NULL) AS hour_of_day_null,
  COUNTIF(trip_length_min IS NULL) AS trip_length_min_null,
  COUNTIF(start_station_name IS NULL) AS start_station_name_null,
  COUNTIF(start_lat IS NULL) AS start_lat_null,
  COUNTIF(start_lng IS NULL) AS start_lng_null,
  COUNTIF(end_station_name IS NULL) AS end_station_name_null,
  COUNTIF(end_lat IS NULL) AS end_lat_null,
  COUNTIF(end_lng IS NULL) AS end_lng_null,
  COUNTIF(route IS NULL) AS route_null,
  COUNTIF(member_casual IS NULL) AS member_casual_null
FROM
  cleaned
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/c8dbbd25-73a7-4aaa-a00c-1f5c01caa971" width="1000">

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/b1ffdb6f-fc5d-44ab-9381-c581a31b1302" width="1000">

We are left with 4,107,945 observations(rows) from our original 5,674,399 rows. There are also no more nulls. We have a clean table now, so let's remove the temporary table function (WITH...) and the section that checks for NULLs, and then save the query result as a new table.

<br>

## Data Analysis

Now that we have a new clean table, we can start our analysis. 

**Let's take a look at the breakdown of rides between members and casual riders**
```
SELECT
  member_casual,
  COUNT(*) AS num_of_rides,
  (ROUND((COUNT(*) / (SELECT COUNT(*) FROM cs-bike-share-analysis.Trip_Data.clean_table)) * 100)) AS ride_percentage
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  member_casual
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/630966c9-1e6c-4ca4-85b8-0d68cabfe655" width="400">

We see that 2/3 of the rides are made up of members and 1/3 are made up of casual riders.

<br>
<br>

**What are the busiest/slowest months for rides?**
```
SELECT
  member_casual,
  month,
  COUNT(*) AS num_of_rides
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member" -- change to "casual" to apply casual condition
GROUP BY
  member_casual, month
ORDER BY
  num_of_rides DESC
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/285ac567-443b-4c21-8051-74aa8c60a37a" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/4792063a-3d3e-44cc-aa8b-96ee7db17627" width="350">

The busiest and slowest half of the year are the same for both members and casual riders; there are more rides in the warmer months and less rides in the colder months. The difference in order of most busiest and slowest month for both customer types are negligible.

<br>
<br>

**How long does a trip last on average?**
```
SELECT
  member_casual,
  ROUND(AVG(trip_length_min), 2) as avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  member_casual
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/5cbbdd1c-5075-464e-b915-b5c5393724a5" width="350">

Casual riders ride almost twice as long as members on average.

<br>
<br>

**What months are trips the longest/shortest?**
```
SELECT
  member_casual,
  month,
  ROUND(AVG(trip_length_min), 2) as avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member" -- change to "casual" to apply casual condition
GROUP BY
  member_casual, month
ORDER BY
  avg_trip_length_min DESC
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/9ccd4d1a-8dee-4866-a531-25f69e4f6b0f" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/1086b206-507d-4690-90f7-e4713d327c68" width="350">

Similar to the trend identified above, customers ride longer during the warmer months and shorter during the colder months. Members are more consistent in average trip length month over month compared to casual riders. Members have a high of 13.12 minutes and a low of 9.71 minutes, while casual riders have a high of 23.29 minutes and a low of 13.11 minutes.

<br>
<br>

**What days of the week are trips the longest/shortest?**
```
SELECT
  member_casual,
  day_of_week,
  ROUND(AVG(trip_length_min), 2) as avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member" -- change to "casual" to apply casual filter
GROUP BY
  member_casual, day_of_week
ORDER BY
  avg_trip_length_min DESC
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/90218315-6c5a-46d1-9e42-9618bbac387f" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/46911a77-f023-4437-be69-bf4db4ba2cd7" width="350">

Customers ride the longest during the weekends and shorter during the weekdays. Similar to above, members are once again more consistent day over day in average trip length compared to casual riders. The slowest day for members is Monday, and for casual riders, Wednesday.

<br>
<br>

**What are the busiest/slowest days of the week?**
```
SELECT
  member_casual,
  day_of_week,
  COUNT(*) AS num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member" -- change to "casual" to apply casual filter
GROUP BY
  member_casual, day_of_week
ORDER BY
  num_of_trips DESC
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/73c7118d-96d0-4e07-9aaa-7cde2ee2bc5f" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/969d3b68-d5ac-4684-8a91-85875fcb74a4" width="350">

This is interesting. Members ride more often during the weekdays (Thursday being the busiest) and less during the weekend. On the other hand, casual riders are the opposite. They ride the most on the weekends and less during the weekdays.

<br>
<br>

**Are classic bikes or electric bikes more popular?**
```
SELECT
  member_casual,
  rideable_type,
  COUNT(*) AS num_of_trips,
  ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 2) AS trip_percentage
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  member_casual, rideable_type
ORDER BY
  member_casual, num_of_trips DESC
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/278a028b-5198-4722-8410-59859fb7d83c" width="450">

The classic bike is the most popular for both groups. That said, the ratio of classic bikes to electric bikes ridden for members is nearly 2:1, and for casual riders, approximately 3:2.

<br>
<br>

**How long does a trip last on each type of bike?**
```
SELECT
  member_casual,
  rideable_type,
  ROUND(AVG(trip_length_min), 2) AS avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  member_casual, rideable_type
ORDER BY
  member_casual, avg_trip_length_min DESC
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/0976e608-5470-4805-b088-a094bede8f50" width="450">

No matter the bike type, casual riders ride longer than members. This difference is largest when comparing trip length on classic bikes for both customer types.

<br>
<br>

**What are the most popular starting stations?**
```
SELECT
  member_casual,
  start_station_name, -- switch with "end_station_name" to get ending stations
  COUNT(*) as num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member" -- switch with "casual" to apply casual filter
GROUP BY
  member_casual, start_station_name -- switch with "end_station_name"
ORDER BY
  num_of_trips DESC
LIMIT 10
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/90e737e8-fa2c-4c29-b182-70777309e481" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/dfc6a22d-9d24-412f-8470-46ffc542b210" width="350">

<br>
<br>

**What are the most popular ending stations?**

Changing the query above with "end_station_name" we get the following result.

<img src="https://github.com/kelvsc/data-analysis/assets/150187892/689f7f91-8506-4938-8032-c80e0efee9ed" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/99aed18d-17a1-4750-b64b-82b34a01798a" width="350">

Both customer types have different top 10 lists compared to one another. However, they have the same top 10 starting stations as their top 10 ending stations, albeit in slightly different order. The difference in the number of trips between first place and last place for both lists is much larger for casual riders compared to members. i.e. The popular stations for casual riders are very popular, whereas the popular stations for members are more evenly spread out.

<br>
<br>

**What are the most popular routes?**
```
SELECT
  member_casual,
  route,
  COUNT(*) AS num_of_trips,
  ROUND(AVG(trip_length_min),2) AS avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member" -- change to "casual" to apply casual filter
GROUP BY
  member_casual, route
ORDER BY
  num_of_trips DESC
LIMIT 10
```
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/74e0ca07-81b1-4421-b881-68affe986e3b" width="350">
<img src="https://github.com/kelvsc/data-analysis/assets/150187892/89333238-8199-487e-a1ea-fb61f366252a" width="350">

Members and casual riders have different top 10 routes. For members, the popularity of the routes is more spread out, whereas, for casual riders, the popularity of the routes is more concentrated near first place. Popular routes for members are much shorter in trip length (under ~10 mins) compared to those of casual riders (under ~45 mins). 

<br>

## Data Visualization

Google Looker Studio was used as the data visualization tool as the file size of the combined dataset was over 1GB, which exceeded the upload limit in other free data visualization tools like Tableau Public.

The Looker Studio report can be accessed [here](https://lookerstudio.google.com/s/nbQA7OpfDiI). Note: you will need to log into your Google account to view.

If you do not have a Google, you can download the non-interactive data visualization report [here](https://github.com/kelvsc/data-analysis/files/13310966/Cyclistic_Report_Kelvin_Chen.pdf).

<br>

## Summary of Differences between Customer Type

| Members | Casual Riders |
| -------- | ------- |
| Ride more often during the weekday | Ride the most during the weekend |
| Rides are on average ~12 minutes long | Rides are on average ~21 minutes long |
| Average trip length is relatively consistent all year round | Average trip length peaks during spring and summer and plummets during fall and winter |
| Ratio of classic vs electric bike preference is ~2:1 | Ratio of classic vs electric bike preference is ~3:2 |
| Popularity of starting and ending stations is more distributed | Popularity of starting and ending stations are concentrated around downtown, entetertainment districts, and attractions |
| Top 10 popular routes are between 3.5 to 7.7 minutes | Top 10 popular routes are between 5.2 to 45.5 minutes|
| Numer of rides peak at 8AM and 5PM | Number of rides gradually increases throughout the day until 5PM |

<br>

## Recommendations

Based on our data analysis, the top 3 recommendations for Cyclistic's marketing campaign would be to consider the following.

1. Seasonality - Capitalize on seasonality by launching a campaign spanning spring and summer, starting in April, when the weather is turning warmer and people are looking to spend more time outside longer. Cyclistic could also consider offering a spring/summer membership to convert casual riders who don't want to commit to a full year.

2. Location-based Targeting - Casual riders are highly concentrated in downtown, entertainment venues, and attractions. Beyond owned media channels (website, social, email), Cyclistic should consider running out-of-home advertising in areas where casual riders are already located. Popular routes for casual riders could be used to prioritize locations.

3. Membership Perks - Highlight what it means to be a member. Offer more perks for annual memberships and promote all the benefits of why annual members decide to bikeshare for commute, errands, and groceries. Consider partnering with health-minded organizations like gyms, sport centers, dance studios, and more, to offer a discounted annual membership.
