data("retailers", package="validate")

suggest_domain_check(retailers)

rules <- suggest_pos_check(retailers)
expect_equal(length(rules), 7)

rules <- suggest_pos_check(retailers, only_positive = FALSE)
expect_equal(length(rules), 9)
