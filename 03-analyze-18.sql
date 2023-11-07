SELECT
  member_casual,
  start_station_name, -- switch with end_station_name
  COUNT(*) as num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "casual"
GROUP BY
  member_casual, start_station_name
ORDER BY
  num_of_trips DESC
LIMIT 10