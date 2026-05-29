install.packages("caret")

require(caret)

data("iris")

plot(iris$Sepal.Length, iris$Sepal.Width)

data("cars")

head(cars)

set.seed(987)
train_index <- sample(1:804, 640)
train.data <- cars[train_index, ]
test.data <- cars[-train_index, ]

modelo.lm <- train(form = Price ~ ., data = train.data,
                   method = "lm")
summary(modelo.lm)

require(dplyr)

?select
modelo.lm <- train(form = Price ~ ., 
                   data = train.data %>%
                     select(-matches("Saturn")) %>%
                     select(-matches("coupe")) %>%
                     select(-matches("wagon")),
                   method = "lm")
summary(modelo.lm)

predicciones.lm <- predict(modelo.lm, test.data)

sum((test.data$Price - predicciones.lm)^2)
plot(test.data$Price, predicciones.lm)

set.seed(123)
train_index <- sample(1:150, 125)
iris.train <- iris[train_index,]
iris.test <- iris[-train_index,]

install.packages("kknn")
require(kknn)

install.packages("e1071")
require(e1071)

trncntrl <- trainControl(method = "cv", number = 3)

modelo.kknn <- train(data = iris.train,
                     Species ~ .,
                     method = "kknn", 
                     trControl = trncntrl,
                     tuneGrid = data.frame(kmax = c(5, 10, 15),
                                           distance = c(1, 2, 3),
                                           kernel = c("rectangular",
                                                      "triangular",
                                                      "gaussian")))
summary(modelo.kknn)

plot(modelo.kknn)
ggplot(modelo.kknn)

newgrid <- expand.grid(kmax = 5:15,
                       distance = seq(1, 5, 1),
                       kernel = c("rectangular",
                                  "triangular",
                                  "gaussian"))

modelo.kknn <- train(data = iris.train,
                     Species ~ .,
                     method = "kknn", 
                     trControl = trncntrl,
                     tuneGrid = newgrid)

summary(modelo.kknn)
ggplot(modelo.kknn)

predicciones.kknn <- predict(modelo.kknn, newdata = iris.test)
confusionMatrix(data = predicciones.kknn,
                reference = iris.test$Species)
