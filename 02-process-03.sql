SELECT
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
  EXTRACT(MONTH FROM started_at) AS month,
  TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS trip_length_sec
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
