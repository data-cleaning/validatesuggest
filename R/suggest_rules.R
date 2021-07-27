#' Suggest rules
#'
#' Suggests rules using the various suggestion checks.
#' Use the more specific `suggest` functions for more control.
#' @inheritParams suggest_type_check
#' @param domain_check if `TRUE` include domain_check
#' @param range_check if `TRUE` include range_check
#' @param type_check if `TRUE` include type_check
#' @param na_check if `TRUE` include na_check
#' @param ratio_check if `TRUE` include ratio_check
#' @param unique_check if `TRUE` include unique_check
#' @export
suggest_rules <- function( d
                         , vars = names(d)
                         , domain_check = TRUE
                         , range_check = TRUE
                         , type_check = TRUE
                         , na_check = TRUE
                         , unique_check = TRUE
                         , ratio_check = TRUE
){
  rules <- validate::validator()

  if (domain_check){
    rules <- rules + suggest_domain_check(d, vars=vars)
  }

  if (range_check){
    rules <- rules + suggest_range_check(d, vars=vars)
  }
  if (type_check){
    rules <- rules + suggest_type_check(d, vars= vars)
  }
  if (na_check){
    rules <- rules + suggest_na_check(d, vars= vars)
  }
  if (unique_check){
    rules <- rules + suggest_unique_check(d, vars= vars)
  }
  if (ratio_check){
    rules <- rules + suggest_ratio_check(d, vars= vars)
  }
  rules
}

# (rules <- suggest_rules(iris))
