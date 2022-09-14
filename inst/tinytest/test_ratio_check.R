data("car_owner")

v <- suggest_ratio_check(car_owner)
expect_equal(length(v), 0)
