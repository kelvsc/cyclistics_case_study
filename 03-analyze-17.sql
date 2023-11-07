SELECT
  end_station_name,
  COUNT(*) as num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  end_station_name
ORDER BY
  num_of_trips DESC
LIMIT 10