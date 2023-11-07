SELECT
  member_casual,
  month,
  ROUND(AVG(trip_length_min), 2) as avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "casual"
GROUP BY
  member_casual, month
ORDER BY
  avg_trip_length_min DESC