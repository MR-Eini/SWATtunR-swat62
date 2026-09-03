#' Write a SWAT+ Calibration File
#'
#' This function prepares and writes a `calibration.cal` file based on the
#' provided parameter table. If multiple run IDs are supplied, separate
#' calibration folders and files will be created for each run.
#'
#' @param par A data frame containing SWAT+ parameter definitions and values.
#' Column names should indicate **which file the parameter belongs to** and **how it is modified**.
#' Examples of column naming conventions include:
#' \itemize{
#'   \item \code{"esco.hru | change = absval"} — absolute value change
#'   \item \code{"awc.sol | change = relchg"} — relative change
#' }
#' For full details on parameter definitions and conventions, see:
#' <https://biopsichas.github.io/SWATtunR/articles/hc-par.html#hc_step2>
#' @param model_path Path to the SWAT+ model directory.
#' @param write_path Optional. Directory where the calibration file(s) will be
#' written. If \code{NULL} (default), files are written into \code{model_path}.
#' @param i_run An integer or integer vector specifying run ID(s).
#' Default is \code{1}.
#'
#' If multiple run IDs are supplied (e.g. \code{c(1, 3, 5)}), calibration files
#' will be written into:
#' \itemize{
#'   \item \code{<write_path>/cal_files/cal_1/calibration.cal}
#'   \item \code{<write_path>/cal_files/cal_3/calibration.cal}
#'   \item \code{<write_path>/cal_files/cal_5/calibration.cal}
#' }
#'
#' @note
#' To use a specific generated calibration file in a SWAT+ model run, copy it
#' into the model directory and update the `file.cio` entry accordingly.
#'
#' @return Invisibly returns \code{NULL}. The function writes output files.
#'
#' @importFrom dplyr bind_rows %>%
#' @importFrom purrr map
#' @export
#'
#' @examples
#' \dontrun{
#' write_cal_file(my_parameter_table, "path/to/model", i_run = 1)
#' write_cal_file(my_parameter_table, "path/to/model", i_run = c(1, 3, 5))
#' }
#' @keywords write
#'
write_cal_file <- function(par, model_path, write_path = NULL, i_run = 1){
  if (!is.data.frame(par) || nrow(par) == 0L) stop("par must be a nonempty data frame.")
  if (!is.numeric(i_run) || !length(i_run) || anyNA(i_run) ||
      any(!is.finite(i_run) | i_run != trunc(i_run) | i_run < 1 | i_run > nrow(par)) ||
      anyDuplicated(i_run)) stop("i_run must contain unique row indices within par.")
  # Set default write path
  if (is.null(write_path)) {
    write_path <- model_path
  }

  # Prepare calibration components
  par_t <- format_swatplus_parameter(par)
  unit_conds <- read_unit_conditions(model_path, par_t)

  is_plant <- par_t$definition$file_name == "pdb"
  if (any(is_plant)) {
    par_t$plants_plt <- readr::read_table(file.path(model_path, "plants.plt"),
      skip = 1, show_col_types = FALSE)
  }
  cal_def <- par_t$definition[!is_plant, , drop = FALSE]
  cal <- map(seq_len(nrow(cal_def)),
             ~ cal_def[.x, ]) %>%
    map(~ setup_calibration_cal(.x, unit_conds)) %>%
    bind_rows()
  # Write the calibration file.
  if(length(i_run) > 1){
    for(i in i_run){
      target_path <- ensure_dir(file.path(write_path, "cal_files", paste0("cal_", i)))

      write_calibration(target_path, par_t, cal,
                        seq(1, dim(par)[1], 1), i)
    }
    message("Multiple calibration files written to: ",
            file.path(write_path, "cal_files"))
  } else {
    target_path <- ensure_dir(write_path)
    write_calibration(target_path, par_t, cal,
                      seq(1, dim(par)[1], 1), i_run)
    message(paste0("Parameter files written to: ", write_path))
  }
}
