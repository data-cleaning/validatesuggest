data(task2)

v <- suggest_cond_rule(task2)
expect_equal(length(v), 0)
