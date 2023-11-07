SELECT
  member_casual,
  day_of_week,
  ROUND(AVG(trip_length_min), 2) as avg_trip_length_min
FROM
  cs-bike-share-analysis.Trip_Data.clean_table
WHERE
  member_casual = "member"
GROUP BY
  member_casual, day_of_week
ORDER BY
  avg_trip_length_min DESC