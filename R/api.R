#'Temperatur.nu API agent
#'
#'\code{temperaturNuAgent} takes care of all the dialogue with Temperatur.nu's API.
#'
#'\code{temperaturNuAgent} is an RC class. The idea is that all the communication
#'with Temperatur.nu's API will happen through an object of this class.
#'Upon creation, the object generates a client name to be able to identify itself
#'to the API. It is generated automatically through the prefix "temperatuR",
#'a time-stamp of when the object was created and a random integer.
#'
#'\code{getInfoStations()} returns a data.frame where the rows are all id's of
#'temperature measurement stations registered in Temperatur.ru and the columns
#'are different information about the stations. You should use id's from this
#'result to query for temperature measurements.
#'
#'\code{getTForStation(station, start_date, end_date)} returns a data.frame with
#'temperature measurements. Each row contains a date and time and a temperature
#'in degrees Celsius. Note that, due to how the API works, the granularity of the
#'results can be per hour or per couple of minutes, depending on how much
#'the API backend has processed the data. The correct time stamp of a measurement
#'will always be present together with the temperature itself.
#'
#'For calling \code{getTForStation(station, start_date, end_date)}, \code{station}
#'should be a valid station id, as obtained with \code{getInfoStations()}.
#'\code{start_date} and \code{end_date} should both follow the format YYYY-mm-dd-HH-ii,
#'meaning 4 numerical digits for year and 2 numerical digits for month, day, hour and minute,
#' all those separated by "-". So if you want to set June the 6th, 1523 as the starting
#' date and January the 12th, 1528 as ending date, both at 9 pm, you would call:
#' 
#'\code{getTForStation("station_id_here!", "1523-06-06-21-00", "1528-01-12-21-00")}
#'
#'@source
#'See the official documentation for Temperatur.nu's API at \url{https://www.temperatur.nu/info/api/}
#'
#'@importFrom methods new
#'@importFrom httr GET
#'@importFrom httr stop_for_status
#'@importFrom httr content
#'@export temperaturNuAgent
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
      tryCatch({
        stations_list = content(response_get_all_stations,
                                as = "parsed",
                                type = "application/json")$stations
      },
      error = function(c) {
        stop("Unknown error while trying to extract content from Json response!")
      })
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
      tryCatch({
        content_measurement_obj = content(response_get_measurements,
                                          as = "parsed",
                                          type = "application/json")[["stations"]][[1]]
      },
      error = function(c) {
        stop(
          "Error while extracting response content. Did you use a valid station id (not name!) and valid date formats (YYYY-mm-dd-HH-ii) and intervals (end date later than start date)?"
        )
      })
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