SELECT
  member_casual,
  COUNT(*) AS num_of_rides,
  (ROUND((COUNT(*) / (SELECT COUNT(*) FROM cs-bike-share-analysis.Trip_Data.clean_table)) * 100)) AS ride_percentage
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  member_casual