SELECT
  EXTRACT(MONTH FROM started_at) AS months
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data
GROUP BY
  months
ORDER BY
  months