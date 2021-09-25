#library(httr)

temperaturNuAgent = setRefClass(
  Class = "temperaturNuAgent",
  fields = c("client_name"),
  methods = list(
    initialize = function() {
      client_name <<-
        paste("temperatuR",
              as.integer(Sys.time()),
              as.integer(1000000000 * runif(1)),
              sep = "_")
    },
    getInfoStations = function() {
      indexing_field = "id"
      fields_of_interest = c("title", "lat", "lon", "kommun", "lan", "moh")
      response_get_all_stations = GET(url = "http://api.temperatur.nu/tnu_1.17.php?verbose",
                                      query = list(cli = client_name))
      stop_for_status(response_get_all_stations)
      stations_list = content(response_get_all_stations,
                              as = "parsed",
                              type = "application/json")$stations
      fields_of_interest = append(fields_of_interest, indexing_field)
      proto_df = list()
      for (name in fields_of_interest) {
        proto_df[[name]] = vector()
        for (i in 1:length(stations_list)) {
          proto_df[[name]] = append(proto_df[[name]], stations_list[[i]][[name]])
        }
      }
      return(data.frame(proto_df, row.names = indexing_field))
    },
    getTForStation = function(station, start_date, end_date) {
      response_get_measurements = GET(
        url = "http://api.temperatur.nu/tnu_1.17.php?data",
        query = list(
          p = station,
          cli = client_name,
          start = start_date,
          end = end_date
        )
      )
      stop_for_status(response_get_measurements)
      content_measurement_obj = content(response_get_measurements, as = "parsed", type = "application/json")[["stations"]][[1]]
      station_id = content_measurement_obj[["id"]]
      station_data = content_measurement_obj[["data"]]
      proto_df = list()
      proto_df$datetime = vector()
      proto_df$temperatur = vector()
      for (my_data in station_data) {
        proto_df$datetime = append(proto_df$datetime, my_data$datetime)
        proto_df$temperatur = append(proto_df$temperatur, as.double(my_data$temperatur))
      }
      return(data.frame(proto_df))
    }
  )
)