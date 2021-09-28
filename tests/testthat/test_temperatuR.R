
agent = temperaturNuAgent()


test_that("temperaturNuAgent creates a client name when accessing the API", {
  expect_true(length(agent$client_name)!=0)
})


test_that("class getInfoStation function is correct", {
  inf_stations  <- agent$getInfoStations()
  
  expect_true(class(inf_stations) == "data.frame")
})

test_that("internal structure of getInfoStation function output is correct", {
  inf_stations  <- agent$getInfoStations()

  attrib_infstations<-c("title" , "lat"  ,  "lon"  ,  "kommun" ,"lan"  ,  "moh" )
  expect_equal(attributes(inf_stations)[[1]],attrib_infstations  )
  
})


test_that("class getTForStation function is correct", {
  info_place <- agent$getTForStation("aareavaara","2015-06-06-21-00", "2016-06-07-21-00")
  
  expect_true(class(info_place) == "data.frame")
})


test_that("internal structure of getInfoStation function output is correct", {
  info_place <- agent$getTForStation("aareavaara","2015-06-06-21-00", "2016-06-07-21-00")
  
  attrib_infspecific<-c("datetime","temperatur")
  expect_equal(attributes(info_place)[[1]],attrib_infspecific  )
  
})




test_that("getTForStation function is returning an empty dataframe when inserting an inexistent station id", {
  info_place <- agent$getTForStation("abcd","2015-06-06-21-00", "2016-06-07-21-00")
  
  expect_true(nrow(info_place)==0)
})



test_that("Error messages are returned for erronous input in the getTForStation function", {
  input_error <-c(1,1,1)
  expect_error(agent$getTForStation(input_error))
  
  input_error <-c(1,"2015-06-06-21-00",1)
  expect_error(agent$getTForStation(input_error))
  
  input_error <-c(1,"2015-06-06-21-00","2016-06-06-21-00")
  expect_error(agent$getTForStation(input_error))
  
  input_error <-c("aareavaara","2016-06-06-21-00","2015-06-06-21-00")
  expect_error(agent$getTForStation(input_error))
  
  input_error <-c("aareavaara","2016-06-06-21-00")
  expect_error(agent$getTForStation(input_error))
  
  
})

