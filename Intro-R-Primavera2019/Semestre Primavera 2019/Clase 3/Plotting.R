# Plot de 2 Variables

x <- runif(1000)

y <- rnorm(1000,0,1)

plot(x,y)


# Trabajemos con Iris 

data <- iris

summary(data)

plot(data$Petal.Length,data$Petal.Width)

head(iris)

# Diferentes tipos de plots

stripchart(iris$Sepal.Length)

stripchart(jitter(iris$Sepal.Length))

stripchart(iris$Sepal.Length, method = "stack")

stripchart(iris$Sepal.Length, method = "stack", pch = 14)

hist(iris$Sepal.Length)

hist(iris$Sepal.Length, breaks = 20)

# Con Linea de Densidad

hist(iris$Sepal.Length, breaks = 20, 
     xlim = c(4, 8.5), freq = FALSE)
lines(density(iris$Sepal.Length))

# Que se vea chido 

hist(iris$Sepal.Length, breaks = 20, 
     xlim = c(4, 8.5), freq = FALSE,
     main = "Sépalo", xlab = "Longitud del sépalo",
     ylab = "densidad", col = "light blue")
lines(density(iris$Sepal.Length), col = "hot pink",
      lwd = 4)

# Secuencias 

x <- seq(from = -2*pi, to = 2*pi, length = 100)
y <- cos(x)

plot(x, y)

# Line type

plot(x, y, type = "l", lty = "123456")

# Normal hasta cierto nivel

x <- seq(from = -5, to = 5, by = 1e-1)
y <- dnorm(x)

plot(x, y, type = "n")
abline(v = seq(-5, 5, by = 1), 
       h = seq(0, 0.4, by = 0.1),
       col = "grey")
polygon(c(-5, seq(-5, 1.5, by = 1e-1), 1.5), 
        c(0, dnorm(seq(-5, 1.5, by = 1e-1)), 0),
        density = 100, col = "hot pink")
lines(x, y, lwd = 3)
abline(h = 0, v = 0)

# Boxplot

boxplot(x = iris)

# Boxplot Iris menos species

boxplot(x = iris[-5])

# Boxplot de solo una variable

boxplot(x = iris$Sepal.Width)

# Boxplot Escalada

boxplot(x = scale(iris[-5]))

# Grafica de pares x,y

pairs(iris[-5])
cor(iris[-5])

# Simulacion de Tendencias 

# simulacion de tendencias

set.seed(123)
x0 <- 0
x <- numeric(length = 1001)
x[1] <- x0
for(i in 1:1000){
  x0  <- x0 + rnorm(1)
  x[i+1] <- x0
}

plot(0:1000, x, type = "l")




