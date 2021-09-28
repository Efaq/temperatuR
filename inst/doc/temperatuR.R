## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>" 
)

## ----setup--------------------------------------------------------------------
library(temperatuR)

## -----------------------------------------------------------------------------
agent = temperaturNuAgent()
info_stations = agent$getInfoStations()
head(info_stations)

## -----------------------------------------------------------------------------
info_stations_aareavaara = agent$getTForStation("aareavaara","2021-06-06-21-00","2021-06-07-21-00")
print(info_stations_aareavaara)


