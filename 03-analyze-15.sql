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