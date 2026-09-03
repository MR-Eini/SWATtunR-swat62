test_that("observation-only crops cannot misalign PHU, yield and biomass panels", {
  crop <- tibble::tibble(year=2007L, hru=1L, plant_name="corn", run_1=1)
  sim <- list(
    run_info=list(simulation_period=list(start_date=as.Date("2007-01-01"),
      end_date=as.Date("2007-12-31"), years_skip=0)),
    parameter=list(definition=tibble::tibble(parameter="esco")),
    simulation=list(phu=crop, yld=crop, bms=crop))
  obs <- tibble::tibble(plant_name=c("corn", "beans"),
    yield_min=c(1,1), yield_max=c(2,2), yield_mean=c(1.5,1.5))
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off())
  expect_warning(plots <- plot_phu_yld_bms(sim, obs), "No simulated harvest.*beans")
  panels <- vapply(plots$grobs, function(p) sum(grepl("^panel", p$layout$name)), integer(1))
  expect_equal(panels, rep(1L, 3))
})
