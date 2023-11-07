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