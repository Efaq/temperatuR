content_measurement = content(example_response_get_measurements, as = "parsed", type = "application/json")
station_id = content_measurement[["stations"]][[1]][["id"]]
station_data = content_measurement[["stations"]][[1]][["data"]]
proto_df = list()
proto_df$datetime = vector()
proto_df$temperatur = vector()
for (my_data in station_data){
  proto_df$datetime = append(proto_df$datetime, my_data$datetime)
  proto_df$temperatur = append(proto_df$temperatur, as.double(my_data$temperatur))
}
measurements_df = data.frame(proto_df)
