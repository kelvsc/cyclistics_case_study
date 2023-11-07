SELECT
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  day_of_week
ORDER BY
  day_of_week