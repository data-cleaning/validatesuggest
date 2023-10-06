library(validatesuggest)

data(retailers, package="validate")
summary(retailers)

suggest_type_check(retailers)

suggest_domain_check(retailers)

suggest_na_check(retailers)

suggest_pos_check(retailers)

suggest_all(retailers)



