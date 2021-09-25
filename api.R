temperaturNuAgent = setRefClass(
  Class = "temperaturNuAgent",
  fields = c("stations"),
  methods = list(
    getTForStations(stations, start_date, end_date){
      
    }
  )
)

example_response_get_all_stations = GET("http://api.temperatur.nu/tnu_1.17.php?cli=elife599carde734&verbose")
example_response_get_measurements = GET("http://api.temperatur.nu/tnu_1.17.php?p=adelov&cli=elife599carde734&data&start=2021-09-12-11-59&end=2021-09-23-11-35")
status_code(response_object)
headers(response_object)

