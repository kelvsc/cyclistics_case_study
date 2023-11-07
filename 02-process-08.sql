SELECT
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
ORDER BY
  trip_length_min DESC
LIMIT 500
