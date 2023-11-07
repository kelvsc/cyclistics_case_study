SELECT
  month,
  COUNT(*) AS num_of_rides
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
GROUP BY
  month
ORDER BY
  num_of_rides DESC