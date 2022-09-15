#' Suggest rules
#'
#' Suggests rules using the various suggestion checks.
#' Use the more specific `suggest` functions for more control.
#' @inheritParams suggest_type_check
#' @param domain_check if `TRUE` include domain_check
#' @param range_check if `TRUE` include range_check
#' @param type_check if `TRUE` include type_check
#' @param pos_check if `TRUE` include pos_check
#' @param na_check if `TRUE` include na_check
#' @param ratio_check if `TRUE` include ratio_check
#' @param unique_check if `TRUE` include unique_check
#' @param conditional_rule if `TRUE` include cond_rule
#' @export
suggest_rules <- function( d
                         , vars = names(d)
                         , domain_check = TRUE
                         , range_check = TRUE
                         , pos_check = TRUE
                         , type_check = TRUE
                         , na_check = TRUE
                         , unique_check = TRUE
                         , ratio_check = TRUE
                         , conditional_rule = TRUE
                         ){
  rules <- validate::validator()

  if (domain_check){
    rules <- rules + suggest_domain_check(d, vars=vars)
  }
  if (range_check){
    rules <- rules + suggest_range_check(d, vars=vars)
  }
  if (pos_check){
    rules <- rules + suggest_pos_check(d, vars = vars)
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
  if (conditional_rule){
    rules <- rules + suggest_cond_rule(d, vars= vars)
  }
  rules
}

#' @export
#' @rdname suggest_rules
#' @aliases suggest_rules
suggest_all <- suggest_rules
# (rules <- suggest_rules(iris))

#' @export
#' @rdname suggest_rules
write_all_suggestions <- function( d
                                 , vars=names(d)
                                 , file=stdout()
                                 , domain_check = TRUE
                                 , range_check = TRUE
                                 , type_check = TRUE
                                 , pos_check = TRUE
                                 , na_check = TRUE
                                 , unique_check = TRUE
                                 , ratio_check = TRUE
                                 , conditional_rule = TRUE
                                 ){
  text <-
"#Generated with `validatesuggest`
"
  writeLines(text, file)
  if (domain_check){
    write_domain_check(d, vars = vars, file = file)
  }

  if (range_check){
    write_range_check(d, vars = vars, file = file)
  }

  if (pos_check){
    write_pos_check(d, vars = vars, file = file)
  }

  if (type_check){
    write_type_check(d, vars = vars, file = file)
  }

  if (na_check){
    write_na_check(d, vars = vars, file = file)
  }

  if (ratio_check){
    write_ratio_check(d, vars = vars, file = file)
  }

  if (conditional_rule){
    write_cond_rule(d, vars = vars, file = file)
  }


}
