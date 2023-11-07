SELECT
  member_casual,
  day_of_week,
  hour_of_day,
  COUNT(*) AS num_of_trips
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  member_casual, day_of_week
ORDER BY
  member_casual, num_of_trips