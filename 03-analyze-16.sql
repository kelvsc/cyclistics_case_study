SELECT
  start_station_name,
  COUNT(*) as num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  member_casual, start_station_name
ORDER BY
  member_casual, num_of_trips DESC
LIMIT 10