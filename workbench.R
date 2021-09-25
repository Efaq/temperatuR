#Code to pick json from all stations and build dataframe:

#status_code(example_response_get_all_stations)
#headers(example_response_get_all_stations)

stations_content = content(example_response_get_all_stations, as = "parsed", type = "application/json")
stations_list = stations_content$stations
head(stations_list)

indexing_field = "id"
fields_of_interest = c("title", "lat", "lon", "kommun", "lan", "moh")
#
fields_of_interest = append(fields_of_interest, indexing_field)
proto_df = list()
for (name in fields_of_interest){
  proto_df[[name]] = vector()
  for (i in 1:length(stations_list)){
    proto_df[[name]] = append(proto_df[[name]], stations_list[[i]][[name]])
  }
}
stations_df = data.frame(proto_df, row.names = indexing_field)