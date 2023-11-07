SELECT
  member_casual,
  month,
  COUNT(*) AS num_of_rides
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member"
GROUP BY
  member_casual, month
ORDER BY
  num_of_rides DESC
