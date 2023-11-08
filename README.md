# Cyclistics Case Study

## Intro

In this example case study, we analyze historical bike-share data to identify trends and insights in order to design effective marketing strategies and tactics.

Tools used in this case study include Google BigQuery for data analysis with SQL, and Google Looker Studio for data visualization.

<br>

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

**Since we need days, months and trip length for some of our questions, let’s doublecheck if the data looks correct.**
Starting with day_of_week
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

<br>

Now months.
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


