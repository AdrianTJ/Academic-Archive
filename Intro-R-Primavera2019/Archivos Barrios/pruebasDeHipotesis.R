#=========================================================================
# COMPARACION DE MEDIAS, VARIANZAS Y PROPORCIONES
# Package: ISwR
# Description: Data sets and scripts for text examples and exercises in
# P. Dalgaard (2008), `Introductory Statistics with R', 2nd ed.,
# Springer Verlag, ISBN 978-0387790534.

library(ISwR)

# Prueba t, una muestra
# Ej: Consumo diario de energía
print(intake)

(summary(x <- intake$pre))
(quantile(x))

# Se desea probar si se toma la cantidad recomendada: 7725 kJ.
# Suponiendo normalidad.
print(tt <- t.test(x, mu=7725))


# print(names(tt))
# help(t.test)

print(tt <- t.test(x, mu=7725, alternative="less"))
# Note que es el mismo valor del estadístico pero distinto valor-p.
# Note el Intervalo de Confianza.



# Prueba de hipótesis de dos muestras. Supuesto de normalidad.

der <- c(113.2, 108.2, 110.8, 114.3, 110.7, 106.6, 109.5, 110.8, 108.8, 113.4)
izq <- c(112.5, 108.8, 111.2, 114.2, 111.8, 106.4, 109.8, 111.3, 109.2, 113.6)
vision.dat <- data.frame(izq,der)
par(oma=c(0,0,0,2))
plot(der,col=2,pch=20,
     xlab="persona", ylab="agudeza",main="Comparación de Agudeza Visual")
points(y,col=4,pch=19)
legend("bottomright", legend=c("derecho","izquierdo"),pch=c(20,19),col=c(2,4))
points(jitter(rep(11.,10)),der,xpd=NA,col=2,pch=20)
points(jitter(rep(11.,10)),izq,xpd=NA,col=4,pch=19)
par(oma=c(0,0,0,0))

# Desconocidas las varianzas: Problema Behrens-Fisher => Aproximación de Welch.
print(tt <- t.test(der,izq, alternative="two", paired=FALSE, var.equal=FALSE))

# Desconocidas las varianzas pero se suponen las mismas.
print(tt <- t.test(der,izq, alternative="two", paired=FALSE, var.equal=TRUE))

# Se suponen observaciones pareadas
print(tt <- t.test(der,izq, alternative="two", paired=TRUE))


# Prueba de Igualdad de Varianzas
print(tt <- var.test(der,izq, alternative="two",conf.level=.90))
help(var.test)

x <- rnorm(20,2,1)
y <- rnorm(30,-1,2)
print(tt <- var.test(x,y, alternative="two",conf.level=.90))




## Prueba de Proporciones
print(tt <- prop.test(39,215,0.15)) # Aproximación normal
help(prop.test)

print(tt <- binom.test(39,215,0.15)) # Prueba exacta


## Prueba de Igualdad de Proporciones
x <- c(5,15)  # (No. 'e'exitos, No. )
y <- c(6,34)
print(tt <- prop.test(x,y,correct=FALSE)) # Aproximación normal
#=========================================================================

#=========================================================================
# PRUEBAS DE BONDAD DE AJUSTE
# Prueba Kolmogorv - Smirnov
# Ejemplos tomados de la ayuda de la función ks.test

require(graphics)

set.seed(140412)


# Prueba de Kolmogorv comparando una distribución teórica y una empírica.
n <- 20
x <- rnorm(n)
plot(0,0,xlim=3*c(-1,+1),ylim=c(0,1),type="n",
     xlab="x",ylab="probabilidad",main="Prueba Kolmogorov")
curve(pnorm,from=-4,to=4,n=101,lwd=2,add=TRUE,col=3)
plot(ecdf(x),add=TRUE,col=4)

print(tt <- ks.test(x,"pnorm"))
x <- sort(x)
y <- pnorm(x)
h <- seq(n)/n
for(i in seq(n)) segments(x[i],y[i],x[i],h[i],col=grey(.8))
idx <- which.max(abs(y-h))
segments(x[idx],y[idx],x[idx],h[idx],col=2)
text(x[idx],(y[idx]+h[idx])/2,paste("D=",round(tt$statistic,3),sep=""),
     pos=4,col=2)


# Prueba de Smirnov comparando dos distribuciones empíricas.
x <- rnorm(50)
y <- runif(30,-3,3); # y <- rchisq(30,4)-2; # y <- rnorm(40)
plot(ecdf(x), xlim = range(c(x, y)),col=2, main="Prueba de Smirnov")
plot(ecdf(y), add = TRUE, col=4)
# Do x and y come from the same distribution?
ks.test(x, y)

# Prueba de Lilliefors
library(nortest)
print(tt <- lillie.test(x))


# Prueba Ji-cuadrada para bondad de ajuste.
n <- 100
x <- runif(n,-3,3)
lim <- c(-Inf,seq(-3, 3, by=1),+Inf)
# x <- rnorm(n)
# lim <- c(-Inf,seq(-3, 3, by=1),+Inf)
(freq <- table(cut(x, breaks = lim)))
prob <- rep(1/8,8)
print(tt <-  chisq.test(freq, p = prob))
#=========================================================================


#=========================================================================
# PRUEBAS Ji-Cuadrada

# Consumo de cafeina de acuerdo al estado civil
(caff.marital <-matrix(c(652, 1537,598,242,36,46,38,21,218,327,106,67),nrow=3,byrow=TRUE))
colnames(caff.marital) <- c("0","1-150","151-300",">300")
rownames(caff.marital) <- c("Casado","Antes casado","Soltero")
print(caff.marital)

# Margenes
print(margin.table(caff.marital,1))
print(margin.table(caff.marital,2))

# Proporciones
print(prop.table(caff.marital,1))
print(prop.table(caff.marital,2))

# Prueba de indepencia de consumo de cafeina de acuerdo al estado civil
print(tt <- chisq.test(caff.marital))
print(names(tt))

print(tt$observed)
print(tt$expected)
#=========================================================================
