test_that("GOF pairs observations by date rather than input row order", {
  date <- as.Date("2007-01-01") + 0:3
  sim <- data.frame(date = date, run_1 = c(2, 4, 8, 16))
  obs <- data.frame(date = date[c(4, 2, 1)], flow = c(16, 4, 2))
  score <- calc_gof(sim, obs, list(mae = function(s, o) mean(abs(s - o))))
  expect_equal(unname(score$mae), 0)
  expect_error(calc_gof(sim, transform(obs, date = date + 100),
    list(mae = function(s, o) mean(abs(s - o)))), "No matching dates")
})

test_that("validation periods reject mixed formats and reversed dates", {
  x <- data.frame(date = as.Date(c("2015-12-31", "2016-01-01", "2023-12-31", "2024-01-01")))
  expect_equal(nrow(filter_period(x, c(2016, 2023))), 2L)
  expect_error(filter_period(x, c("2016", "2023-12-31")), "formats")
  expect_error(filter_period(x, c("2023-01-01", "2016-01-01")), "greater")
})

test_that("calibration export validates run indices before writing", {
  par <- data.frame("cn2.hru | change = abschg" = c(0, 2), check.names = FALSE)
  for (i in list(0, 3, 1.5, NA, c(1, 1))) {
    expect_error(write_cal_file(par, tempdir(), i_run = i), "row indices")
  }
})

test_that("calibration values retain small magnitudes and field boundaries", {
  path <- tempfile(); dir.create(path)
  definition <- tibble::tibble(parameter = "cn2", change = "absval", file_name = "hru")
  par <- list(definition = definition, values = tibble::tibble(cn2 = 1.23456789123456e-20))
  template <- init_cal(definition)
  write_calibration(path, par, template, 1, 1)
  fields <- strsplit(trimws(readLines(file.path(path, "calibration.cal"))[4]), "[[:space:]]+")[[1]]
  expect_equal(fields[1:2], c("cn2", "absval"))
  expect_equal(as.numeric(fields[3]) / par$values$cn2, 1, tolerance = 1e-14)
  expect_length(fields, 11L)
})
