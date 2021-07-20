
atomic_check_expr <- validatesuggest:::atomic_check_expr

a <- atomic_check_expr("a", "FALSE", is_logical = TRUE)
expect_equal(a, "a == FALSE")

a <- atomic_check_expr("a", "hi", is_logical = FALSE)
expect_equal(a, "a == \"hi\"")

a <- atomic_check_expr(".pos.a", "TRUE", is_logical = TRUE)
expect_equal(a, "a > 0")

a <- atomic_check_expr(".pos.a", "FALSE", is_logical = TRUE)
expect_equal(a, "a <= 0")

a <- atomic_check_expr(".pos.a", "TRUE", is_logical = TRUE, negate = TRUE)
expect_equal(a, "a <= 0")

a <- atomic_check_expr(".pos.a", "FALSE", is_logical = TRUE, negate = TRUE)
expect_equal(a, "a > 0")


r <- suggest_cond_rule(car_owner)
