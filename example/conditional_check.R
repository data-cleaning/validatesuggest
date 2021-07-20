data("car_owner")
d <- car_owner
assoc_rule(d)
car_owner$age
car_owner$driver_license

library(rpart)
m <- rpart(driver_license ~ ., car_owner)
m

car_owner$no_income <- car_owner$income <= 0
m <- rpart(no_income ~ . - income, car_owner)
m

m <- rpart(owns_car ~ . - income, car_owner)
m

table(license = car_owner$driver_license, car=car_owner$owns_car)


m <- rpart(owns_car ~ ., car_owner, control = rpart.control(maxdepth = 2))
m

m <- rpart(car_color ~ ., car_owner, control = rpart.control(maxdepth = 2))
m
