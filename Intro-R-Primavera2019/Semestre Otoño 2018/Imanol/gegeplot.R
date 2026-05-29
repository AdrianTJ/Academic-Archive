install.packages("tidyverse")

require(ggplot2)
require(reshape2)

data(iris)
x <- iris$Sepal.Length

hist(x)
ggplot(data = x, aes(x = x)) +
  geom_histogram(aes(y = ..density..))

rm(x)
ggplot(data = iris, aes(x = Sepal.Length)) +
  geom_histogram(aes(y = ..density..))

ggplot(data = iris, aes(x = Sepal.Length, 
                        y = Petal.Length)) +
  geom_point()

ggplot(data = iris, aes(x = Sepal.Length, 
                        y = Petal.Length,
                        colour = Species)) +
  geom_point() +
  labs(title = "Botánica", colour = "Especie de iris") +
  xlab("Longitud de sépalo") +
  ylab("Longitud de pétalo")

install.packages("GGally")
require(GGally)

ggpairs(data = iris, aes(colour = Species, alpha = 0.7))

ggplot(data = iris) +
  geom_bin2d(aes(x = Sepal.Length,
                 y = Petal.Length))

ggplot(data = iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot() + 
  geom_jitter() +
  coord_flip()

modificacion <- melt(iris, id = "Species")
head(modificacion)

ggplot(data = modificacion, aes(x = Species,
                                y = value,
                                fill = variable)) +
  geom_boxplot()

modificacion2 <- cbind.data.frame(scale(iris[-5]),
                                  iris$Species)
names(modificacion2)[5] <- "Species"
modificacion2 <- melt(modificacion2, id = "Species")

ggplot(data = modificacion2, aes(x = variable,
                                 y = value,
                                 fill = Species)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.1, aes(colour = Species))

ggplot(data = iris, aes(x = Sepal.Length,
                        y = Petal.Length)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_density2d()

ggplot(iris, aes(x = Species, y = Sepal.Length,
                 fill = Species)) +
  geom_violin() +
  geom_boxplot(alpha = 0.3) +
  geom_jitter()

matriz <- cor(iris[,-5])
ggplot(data = melt(matriz), aes(x = Var1, y = Var2,
                                fill = value)) +
  geom_bin2d()

set.seed(123)
mapita <- matrix(data = runif(n = 250*300), nrow = 250)

ggplot(data = melt(mapita), aes(x = Var1, y = Var2,
                                colour = value)) +
  geom_point() +
  scale_color_continuous(low = "red", high = "yellow")

set.seed(123)
X <- cbind(runif(n = 1e4, -2, 2), runif(n = 1e4, -2, 2))
plot(X, pch = '.')
indice <- (X[,1]^2 + X[,2]^2) < 2 * 
  (1 - cos(atan2(X[,2], X[,1])))^(1/2)
points(X[indice,], pch = 14, col = "red")

X <- data.frame(x1 = X[,1], x2 = X[,2],
                dentro = factor(ifelse(indice, 
                                       "si", "no")))

ggplot(data = X, aes(x = x1, y = x2, colour = indice)) +
  geom_point(size = 3) +
  scale_color_manual(values = c("black", "purple"))
