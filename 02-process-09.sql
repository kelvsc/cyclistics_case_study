SELECT
  member_casual,
  ROUND(AVG(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS avg_trip_length_min,
  ROUND(MIN(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS min_trip_length_min,
  ROUND(MAX(TIMESTAMP_DIFF(ended_at, started_at, MINUTE)), 2) AS max_trip_length_min,
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  member_casual