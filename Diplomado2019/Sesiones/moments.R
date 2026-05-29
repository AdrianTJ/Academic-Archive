# Coeficiente de sesgo
skew.coef <- function(x) {
  bc <- sum((x-mean(x))^3)/length(x)/var(x)^3/2
  return(bc)
}

# Coeficiente de Curtosis
kurtosis.coef <- function(x){
  kc <- sum((x-mean(x))^4)/length(x)/var(x)^2-3
  return(kc)
}

# Relación señal-ruido
snr <- function(x){
  snr <- mean(x)/sd(x)
  return(snr)
}

# Función que reporta los primeros 4 momentos muestrales de un vector x
my.moments <- function(x){
  return(c(mean=mean(x), var=var(x), snr=snr(x), skew=skew.coef(x), kurtosis=kurtosis.coef(x)))
}

# Función que construye el histogramam de un juego de datos 
# y reporta sus primeros cuatro momentos muestrales
myFunction<- function(x) {
  hist(x, breaks=21)
  print(my.moments(x))
  return(NULL)
}

# Examples
n <- 2000
cat("\nDistribucion normal N(-5, 4):\n")
myFunction(rnorm(n, mean=-5, sd=2))

cat("\nDistribucion beta Beta(1/2, 1/2):\n")
myFunction(rbeta(n, shape1=1/2, shape2=1/2))
