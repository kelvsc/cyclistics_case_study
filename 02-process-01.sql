SELECT
  COUNTIF(ride_id IS NULL) AS ride_id_null,
  COUNTIF(rideable_type IS NULL) AS rideable_type_null,
  COUNTIF(started_at IS NULL) AS started_at_null,
  COUNTIF(ended_at IS NULL) AS ended_at_null,
  COUNTIF(start_station_name IS NULL) AS start_station_name_null,
  COUNTIF(start_station_id IS NULL) AS start_station_id_null,
  COUNTIF(start_lat IS NULL) AS start_lat_null,
  COUNTIF(start_lng IS NULL) AS start_lng_null,
  COUNTIF(end_station_name IS NULL) AS end_station_name_null,
  COUNTIF(end_station_id IS NULL) AS end_station_id_null,
  COUNTIF(end_lat IS NULL) AS end_lat_null,
  COUNTIF(end_lng IS NULL) AS end_lng_null,
  COUNTIF(member_casual IS NULL) AS member_casual_null
FROM
  cs-bike-share-analysis.Trip_Data.2022_10_to_2023_09_data