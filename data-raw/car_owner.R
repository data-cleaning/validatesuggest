## code to prepare `DATASET` dataset goes here
set.seed(1)
n <- 500

age <- sample(70, n, replace=TRUE)
driver_license <- sample(c(TRUE, FALSE), n, replace = TRUE, prob=c(.9, .1))
driver_license[age < 17] <- FALSE
income <- rlnorm(n, meanlog=log(2000), 0.5)
income[age < 19 & runif(n) <= .8] <- 0

owns_car <- driver_license & income > 1500 & runif(n) <= 0.9
car_color <- sample(c("black", "gray", "red", "blue"), n, replace=TRUE)
is.na(car_color) <- !owns_car

car_color[car_color == "red"] <- "gray"
car_color[income > 4000] <- "red"

car_owner <- data.frame(age, driver_license, owns_car, car_color, income)
usethis::use_data(car_owner, overwrite = TRUE)
