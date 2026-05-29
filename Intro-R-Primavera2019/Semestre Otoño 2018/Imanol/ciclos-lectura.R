# COndicionales

x <- sin(cos(log(abs(tan(exp(pi))))))
y <- rnorm(1)

if(x > 0){
  print("Positivo")
} else {
  print("Negativo")
}

# Conjunción

if(x*y > 0 & y < 1){
  print("hola")
} else {
  print("falla")
}

if( x > y | x + y < 1){
  print("es cierto")
} else {
  print("no lo es")
}


letras <- c("a", "e", "i", "O", "u")

for(i in 1:15){
  print(i^2)
}

s

for(letra in letras){
  print(letra)
}

s <- 10

while (s > 0) {
  s <- s - 1
}

mi.primera.funcion <- function(x){
  y <- 2 * x
  return(y)
}

mi.primera.funcion(54)
mi.primera.funcion(x = 10)

segunda.funcion <- function(x, y = 1){
  return(x^y)
}

segunda.funcion(3)
segunda.funcion(3, 2)
segunda.funcion(y = 3, x = 2)

complicada <- function(x, m = 1){
  if(!(m %in% 1:3)){
    warning("m no es entera")
  } else {
    if(m == 1){
      y <- 3 * x
    } else {
      if(m == 2){
        y <- x + 2
      } else {
        y <- rep(0, length(x))
      }
    }
    return(y)
  }
}

complicada(x = 1:3)
complicada(x = 1:3, m = 2)
complicada(x = 1:3, m = 3)
complicada(x = 1:3, m = pi)

getwd()
# C:\Users\salones.ITAM\Documents\R
datos <- read.csv(file = "C:/Users/salones.ITAM/Documents/R/kc_house_data.csv",
                  colClasses = c(rep("character", 2), rep(NA, 19)))

install.packages("wesanderson")
require(wesanderson)

color <- wes_palette(name = "GrandBudapest1", 
                     type = "continuous", 
                     n = 10)[4]

hist(datos$bedrooms)
hist(datos$bedrooms, xlim = c(0, 33))
hist(datos$bedrooms, xlim = c(0, 10),
     main = "Histograma uno", 
     xlab = "Número de recámaras",
     ylab = "Frecuencia absoluta",
     col = color)
