SELECT
  route,
  COUNT(*) AS num_of_trips,
  ROUND(AVG(trip_length_min),2) AS avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  route
ORDER BY
  num_of_trips DESC
LIMIT 10