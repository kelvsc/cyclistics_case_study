SELECT
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
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS trip_length_min, -- calculate the trip length in minutes by taking the difference between ended_at and started_at
  start_station_name,
  start_lat,
  start_lng,
  end_station_name,
  end_lat,
  end_lng,
  CONCAT(start_station_name, " to ", end_station_name) AS route, -- make a new column to determine routes taken
  CONCAT(start_lat, ",", start_lng) AS start_lat_lng, -- make a new column to merge start lattitude and longitude
  CONCAT(end_lat, ",", end_lng) AS end_lat_lng, -- make a new column to merge end latitude and longitude
  member_casual
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
WHERE
  start_station_name IS NOT NULL AND
  end_station_name IS NOT NULL AND
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) BETWEEN 1 AND 1440 AND
  rideable_type != "docked_bike"