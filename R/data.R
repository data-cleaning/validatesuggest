#' Car owners data set (fictitious).
#'
#' A constructed data set useful for detecting conditinal dependencies.
#'
#'
#' @format A data frame with 200 rows and 4 variables. Each
#' row is a person with:
#' \describe{
#'   \item{age}{age of person}
#'   \item{driver_license}{has a driver license, only persons older then 17 can have a license
#'   in this data set}
#'   \item{income}{monthly income}
#'   \item{owns_car}{only persons with a drivers license
#'   , and a monthly income > 1500 can own a car}
#'   \item{car_color}{NA when there is no car}
#' }
"car_owner"
