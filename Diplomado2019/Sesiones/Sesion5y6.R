# Plot Basico

altura <- c(145, 167, 176, 123, 150)
peso <- c(51, 63, 64, 40, 55)

plot(altura,peso) # Diferencia de variable independiente y dependiente
plot(peso,altura)

# Creacion de Plots Varias con mtcars

View(mtcars)
?mtcars
summary(mtcars)

plot(mtcars$cyl,mtcars$mpg)

# Varias Graficas en un solo lugar con pairs

pairs(~wt+mpg+disp+cyl,data = mtcars,
      main = "Scatterplot Matrix")

############################################################################
############################## Histogramas #################################
############################################################################

hist(mtcars$mpg) # Esta muy vacio, hay que agregarle cosas

hist(mtcars$mpg, freq = F, ylim = c(0, .1), col = "cornsilk2", main = "Histograma millas por galon")
lines(density(mtcars$mpg), col = "blue")
curve(dnorm(x,mean = mean(mtcars$mpg),sd = sd(mtcars$mpg)), add = TRUE, col = "red")
legend("topright", c("Densidad Estimada", "Densidad Teorica (Normal)"),
       col = c("blue", "red"), lwd = c(1,1))

# Agregar mas breaks a un hist plot

hist(mtcars$mpg, freq = F, ylim = c(0, .15), col = "cornsilk2", breaks = 10, main = "Histograma millas por galon")
lines(density(mtcars$mpg), col = "blue")
curve(dnorm(x,mean = mean(mtcars$mpg),sd = sd(mtcars$mpg)), add = TRUE, col = "red")
legend("topright", c("Densidad Estimada", "Densidad Teorica (Normal)"),
       col = c("blue", "red"), lwd = c(1,1))

length(mtcars$mpg)

hist(mtcars$mpg, freq = F, ylim = c(0, .15), col = "cornsilk2", breaks = 32, main = "Histograma millas por galon")
lines(density(mtcars$mpg), col = "blue")
curve(dnorm(x,mean = mean(mtcars$mpg),sd = sd(mtcars$mpg)), add = TRUE, col = "red")
legend("topright", c("Densidad Estimada", "Densidad Teorica (Normal)"),
       col = c("blue", "red"), lwd = c(1,1))

# Histogramas de datos categoricos

hist(mtcars$vs,freq = F)
lines(density(mtcars$vs), col = "blue")

hist(mtcars$cyl,freq = F)
lines(density(mtcars$cyl), col = "blue")

plot(mtcars$cyl) # Tampoco nos da mucha informacion

##############################################################################
################################ BOXPLOTS ####################################
##############################################################################
# La informacion de la variable dependiente tiene que ser categorica

boxplot(mpg ~ cyl, data = mtcars, xlab = "Numero de Cilindros",
        ylab = "Millas por Galon")

boxplot(mpg ~ am, data = mtcars, xlab = "Automatico o Manual",
        ylab = "Millas por Galon")

t.test(mtcars$mpg[which(mtcars$am == 0)], mu = mean(mtcars$mpg[which(mtcars$am == 1)]))


##############################################################################
############################### Line Plots ###################################
##############################################################################
# Importancia de tiempo. 

# Una sola vaiable

v <- c(7,12,28,3,41)
plot(v,type = "o",col = "red", xlab = "Month", ylab = "Rain fall", 
     main = "Rain fall chart")

# Varias Variables

v <- c(7,12,28,3,41)
t <- c(14,7,6,19,3)
plot(v,type = "o",col = "red", xlab = "Month", ylab = "Rain fall", 
     main = "Rain fall chart")
lines(t, type = "o", col = "blue")





















############################################################################
############################# Otro Ejemplo #################################
############################################################################

BirdData <- data.frame(
  Tarsus  = c(22.3, 19.7, 20.8, 20.3, 20.8, 21.5, 20.6, 21.5),
  Head    = c(31.2, 30.4, 30.6, 30.3, 30.3, 30.8, 32.5, 31.6),
  Weight  = c(9.5, 13.8, 14.8, 15.2, 15.5, 15.6, 15.6, 15.7),
  Wingcrd = c(59, 55, 53.5, 55, 52.5, 57.5, 53, 55),
  Species = c('A', 'A', 'A', 'A', 'A',  'B', 'B', 'B')
)

t.test(BirdData$Tarsus, mu = 20) # Lo veremos despues

boxplot(BirdData$Tarsus ~ BirdData$Head, # No tiene sentido, Head no es categorico
        xlab = 'Head' , ylab = "Tarsus")

boxplot(BirdData$Tarsus ~ BirdData$Species,
        xlab = 'Species' , ylab = "Tarsus")

