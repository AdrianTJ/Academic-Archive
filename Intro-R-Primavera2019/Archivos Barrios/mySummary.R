mySummary <- function(x) {
# modificación del la función summary aplicada a vectores.
  if(!(is.atomic(x) & is.numeric(x))) stop("Argumento x debe ser numérico!")
  tt <- summary(x)
  tt <- c(n=length(x),tt,sd=sd(x),var=var(x))
  tt
}
# Ejemplos del uso de mySummary

print(mySummary("a"))
print(tt <- table(sample(20,200,replace=TRUE)))
print(mySummary(tt))

z <- rnorm(100)
z[sample(seq(100),5)] <- NA
print(summary(z))
print(mySummary(z))
