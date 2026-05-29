###############################################################################
#                             INTRODUCCION A R                                #
#                        AJUSTE DE DISTRIBUCIONES                             #
#                                                                             #
#                     ERNESTO JUVENAL BARRIOS ZAMUDIO                         # 
#                         PAULINA PRECIADO LOPEZ                              #  
#                             05 / Abr / 2014                                 #
###############################################################################

library(MASS)

###############################################################################
#------------------------------------------------------------------------------
# 4.2 Funciones de densidad, de distribucion, quantiles y generador aleatorio
#------------------------------------------------------------------------------

# Cada distribucion preconstruida en R tiene cuatro funciones. Para llamarlas se 
# utiliza un prefijo de una letra que indica la funcion y el nombre raíz de la
# distribución. 

# El nombre raíz de la distribucion normal es "norm", de la exponencial es "exp",
# de la binomial es "binom", etc. 

# Para ver una lista de las distribuciones usar 

  ?distributions

# Los prefijos de las funciones son:

  # p para la funcion de distribucion o probabilidad acumulada
  # d para la funcion de densidad o de masa de probabilidad
  # q para la funcion cuantil (inversa de la funcion de distribucion)
  # r para generar variables aleatorias de la distribucion especificada

# Por ejemplo, las funciones para la normal son: pnorm, rnorm, qnorm y dnorm

# Algunas de estas funciones tienen valores default para los parametros que 
# especifican las funciones que son comunes (e.g. media 0 y varianza 1 para la
# normal estandar)


#-------------------------------------------------------------------------------
# Distribuciones Discretas
#-------------------------------------------------------------------------------

# BINOMIAL: Bin(N,p)
#-------------------

# La distribucion binomial modela el numero de exitos en una secuencia de N
# experimentos independientes en que cada uno tiene una probabilidad p de ser
# exitoso

# Por ejemplo, el numero de aguilas que caeran en N = 10 lanzamientos de una
# moneda honesta (p = 0.5)

# Veamos sus funciones asociadas

  ?Binomial

# Notar los argumentos size (N) y prob (p)

# La funcion de masa es p(x) = choose(n, x) p^x (1-p)^(n-x)

# Supongamos que lanzaremos una moneda N = 20 veces donde la probabilidad de
# aguila (exito) es p = 0.5

  N <- 20; p <- 0.5

  dbinom(5, size = N, prob = p) 
    # Probabilidad de obtener 5 aguilas
  
  pbinom(5, size = N, prob = p) 
    # Probabilidad de obtener entre 0 y 5 aguilas

  qbinom(0.02069473, size = N, prob = p) 
    #El menor valor x de forma que la P[x <= x] = q

  rbinom(1, N, p)
    # Simular el numero de aguilas que se obtienen en 20 lanzamientos de una
    # moneda honesta


# Ejemplo para la exponencial

  (x.exp <- rexp(10, rate = 2)) # Muestra aleatoria de Exp(2)
  dexp(x = 1, rate = 4) # Funcion de densidad: f(x) = r*exp(-r*x)
  pexp(q = 2, rate = 1) # Funcion de distribucion: F(q) = 1 - exp(-r*q)
  qexp(p = .5, rate = 1) # Funcion de cuantiles: x: F(x) = p

# Otras distribuciones, como Pareto, Gumbel, etc. se encuentran en la libre-
# ria VGAM

# Geometrica: Geom(p)
#-------------------

# La distribucion geometrica modela la probabilidad de obtener el primer exito
# despues de cierto numero de experimentos, en los que cada uno tiene dos posi-
# bles resultados y la probabilidad de exito es p

# La funcion de masa tiene la forma P(X = x) = p * (1-p)^x. Usando el ejemplo
# de la moneda, la probabilidad de que la primera aguila salga en el tercer
# lanzamiento es P(X = 3) = (0.5) * (1-0.5)^3

# Veamos sus funciones asociadas

  ?Geometric

# El sufijo es "geom" y el parametro es la probabilidad de exito p

# Ejemplo: Supongamos que la probabilidad de sacar aguila para una moneda es 
# p = 0.3

  p  <- 0.3

  dgeom(3, prob = p) 
    # Probabilidad de obtener 3 soles y luego 1 aguila
  
  pgeom(3, prob = p) 
    # Probabilidad de obtener un aguila en el primero, segundo, tercero o
    # cuarto lanzamiento
  
  qgeom(0.99, prob = p) 
    #El menor valor x de forma que la P[x <= x] = q
  
  rgeom(10, prob = p)
    # Simular 10 experimentos o variables aleatorias con una distribucion
    # geometrica con probabilidad de exito p = 0.3

# Poisson: Poisson(λ)
#-------------------

# La distribucion Poisson se usa para modelar la probabilidad de que cierto
# numero de eventos ocurran en un intervalo fijo de tiempo (o en un espacio
# determinado), si se sabe que estos eventos ocurren a una tasa promedio cono-
# cida λ y que los tiempos de espera entre eventos son independientes

# La funcion de masa es p(x) = λ^x exp(-λ)/x!

# Ejemplos: numero de nacimientos por hora en un cierto dia, el numero de acci-
# dentes de trafico que ocurren en periferico entre San Antonio y Barranca del
# Muerto en un mes

# Veamos sus funciones asociadas

  ?Poisson

# El sufijo es "pois" y el parametro es la tasa promedio λ

# Ejemplo: Supongamos que los nacimientos en el DF ocurren aleatoriamente a una
# tasa promedio de k = 17.5 bebes por hora

  k <-  17.5
  
  dpois(25, lambda = k)
  # Probabilidad de que nazcan 25 bebes en una hora
  
  1 - ppois(10, k) 
  # Probabilidad de que nazcan al menos 10 bebes en una hora
  
  qpois(0.5, k) 
  # El menor valor x de forma que la P[x <= x] = q. En este caso, la mediana de
  # una variable Poisson(17.5)
  
  (y <- rpois(1000, lambda = k))
  # Simular mil realizaciones. Analicemos este vector. ¿Que observamos?
    summary(y)
    
    par(mfrow=c(1,2))
    boxplot(y, main = "Boxplot para nacimientos de bebes \n en el DF por hora x ~ Pois(17.5)",
            col = "springgreen")
    hist(y, freq = F, xlab = "Nacimientos de Bebes en el DF por hora", main = "Histograma",
         ylab = "Masa de Probabilidad", col = rainbow(10))

#-------------------------------------------------------------------------------
# Distribuciones Continuas
#-------------------------------------------------------------------------------

# Uniforme: U(a,b)
#-------------------

# La uniforme tiene un soporte definido por dos numeros a<=b con la propiedad de que todos
# los intervalos entre a y b que tengan la misma longitud son igualmente probables.

# Por ejemplo, X ~ U(0,1). P[0 < X < 1/3] = P[1/3 < X < 2/3]

# La funcion de densidad tiene la forma f(x) = 1/(b-a) y la funcion de distribucion
# P[X <= x] = F(x) = x/(b-a) para x en el intervalo (a,b)

# Veamos sus funciones asociadas

  ?Uniform

# El sufijo es "unif" y los parametros son el soporte: min y max (a y b)

# Pensemos en un ejemplo. Imagina que tenemos una rueda que gira de circunferencia 10m, conç
# marcas en 0, 1, 2, ..., 10 y una aguja que marca un punto en la rueda cuando se detiene

  punif(1, 0, 10)
    # Probabilidad de que la aguja se detenga entre el 0 y el 1

  qunif(c(0.25,0.5, 0.75), 0, 10)
    # Los cuartiles y la mediana de la distribucion

  w <- runif(1000, 0, 10)
    # Simulemos 1000 giros de la rueda
      summary(w)
      par(mfrow = c(1,1))
      hist(w, freq = F)
  
  
# Exponencial: Exp(λ)
#-------------------

# La distribucion exponencial sirve para modelar los tiempos de espera entre la ocurrencia
# de eventos de un proceso Poisson. Los eventos ocurren continuamente y de forma indepen-
# diente a una tasa constante promedio λ > 0 

# La funcion de densidad tiene la forma f(x) = λ*exp(-λ*x) y la funcion de distribucion
# F(x) = 1 - exp(-λ*x)

#Veamos sus funciones asociadas

  ?Exponential

# El parametro es "rate", la tasa promedio y el nombre clave es "exp"

# Ejemplo: los hits a una pagina web suceden a una tasa promedio de 5 por minuto. Empezamos
# a observar esta pagina en la manana (t = 0). 

  pexp(.5, rate = 5)
    #Probabilidad de que esperemos entre 0 y 30s para que ocurra el primer hit
    
  pexp(10/60, 5) - pexp(5/60, 5)
    #Probablidad de que esperemos entre 5s y 10s para que ocurra el primer hit

  qexp(p = 0.5, rate = 5)
    #Que tiempo de espera tiene probabiidad acumulada de 0.5
  
# La exponencial tiene la propiedad de "no tener memoria". Esto significa en nuestro ejemplo
# que el tiempo de espera para que ocurra el segundo hit es independiente del tiempo que
# esperamos para que ocurriera el primero

# Simulemos tiempos de espera y visualicemos la distribucion

  (t <- rexp(100, rate = 5))

  summary(t)

  hist(t, freq = F, ylim = c(0, 5), col = "cornsilk2", main = "Histograma tiempos de espera entre hits a pagina web")
  lines(density(t), col = "blue")
  curve(dexp(x, rate = 5), add = T, col = "red")
  legend("topright", c("Densidad Estimada", "Densidad Teorica (λ = 5)"),
         col = c("blue", "red"), lwd = c(1,1))

# Tambien podemos visualizar la funcion empirica de distribucion o probabilidad acumulada
# con la funcion ecdf

  ?ecdf

  plot(ecdf(t), main ="Funcion empirica de distribucion: t ~ Exp(5), 100 simulaciones")
  curve(pexp(x, rate = 5), add = T, col = "red")
  legend("bottomright", "Funcion de distribucion teorica", lwd = 1, col = "red")

# Normal: N(m,s)
#-------------------

# La distribucion normal es una de las mas importantes y comunes. Tiene dos parametros:
# la media m y la desviacion estandar s

# La funcion de densidad es f(x) = 1/(sqrt(2*pi) s) exp^(-((x - m)^2/(2 s^2)))

# Veamos sus funciones asociadas

  ?Normal

# La clave es "norm" y los parametros son mean y sd (media y desviacion estandar), con
# valores default 0 y 1 respectivamente

# Algunas propiedades:

  # La funcion de densidad es simetrica y tiene forma de campana

  curve(dnorm(x), -3, 3, main = "Densidad de X ~ N(0,1)", ylab ="")

  # La media, mediana y moda son iguales

  # 50% de la probabilidad se acumula por debajo de la media

  qnorm(0.5, mean = 0, sd = 1)

  # La probabilidad acumulada entre -s y s (una desviacion estandar por abajo y por arriba)
  # de la media es aproximadamente 68%

  pnorm(1, mean = 0, sd = 1) - pnorm(-1, mean = 0, sd = 1)

  # Entre 2 desviaciones estandar por arriba y por debajo de la media es aprox. 95%

  pnorm(2, mean = 0, sd = 1) - pnorm(-2, mean = 0, sd = 1)

# Algunos ejemplos:
  # Altura de personas, arboles, etc.
  # IQ

# Tomemos por ejemplo los datos Davis de la libreria car

  library(car)
  head(Davis)

# Grafiquemos la altura con colores por sexo

  plot(Davis$height, col = Davis$sex, pch = 19, ylab = "Altura")
  legend("bottomright", c("Fem", "Masc"), col = c(1,2), pch = 19)

# Hay un punto "extrano"

  (raro <- identify(Davis$height))
  Davis[raro,]

# La altura y el peso fueron invertidos, hay que corregirlo

  Davis[raro,2:3] <- Davis[raro,3:2]

  plot(Davis$height, col = Davis$sex, pch = 19, ylab = "Altura")
  legend("bottomright", c("Fem", "Masc"), col = c(1,2), pch = 19)

# Veamos la densidad estimada por genero con histogramas
  par(mfrow = c(1,2))
  hist(Davis$height[which(Davis$sex == "F")], main = "Altura Mujeres", freq = F)
  lines(density(Davis$height[which(Davis$sex == "F")]), col = "red")
  
  hist(Davis$height[which(Davis$sex == "M")], main = "Altura Hombres", freq = F)
  lines(density(Davis$height[which(Davis$sex == "M")]), col = "blue")

# Y las funciones empiricas de distribucion agregando las curvas de distribucion teorica con
# medias y desviaciones estandar estimadas de cada grupo

  med.muj <- mean(Davis$height[which(Davis$sex == "F")])
  med.hom <- mean(Davis$height[which(Davis$sex == "M")])
  sd.muj <- sd(Davis$height[which(Davis$sex == "F")])
  sd.hom <- sd(Davis$height[which(Davis$sex == "M")])

  plot(ecdf(Davis$height[which(Davis$sex == "F")]), main = "Altura Mujeres")
  curve(pnorm(x, mean = med.muj, sd = sd.muj), col = "red", add = T)

  plot(ecdf(Davis$height[which(Davis$sex == "M")]), main = "Altura Hombres")
  curve(pnorm(x, mean = med.hom, sd = sd.hom), col = "blue", add = T)

# Gamma: Gam(sh,sc)
#-------------------

# La distribucion gamma tiene dos parametros: escala (scale) y forma (shape)

# Se usa en muchos contextos. Algunos ejemplos

  # Precipitacion pluvial acumulada en una ciudad
  # El monto agregado de reclamos a una aseguradora
  # Consumo energetico en millones de kilovatios por hora en el DF

# Puede pensarse que sirve para modelar el tiempo que hay que esperar para que ocurra
# un numero especifico de eventos que ocurren conforme una distribucion Poisson 

# Veamos sus funciones asociadas

  ?GammaDist

# El sufijo se gamma y los parametros son shape y rate. Notar que shape no tiene valores
# predeterminados

# Supongamos el el consumo diario de energia electrica en una ciudad pequena en millones
# de KW/hora es una variable aleatoria Gamma con shape = 3 y rate = 0.5 y que la unica
# planta de la ciudad tiene una capacidad diaria de 10 millones de KW/hora 

# ¿Cual es la probabilidad de que el abastecimiento sea insuficiente en un dia cualquiera?

  1- pgamma(10, shape = 3, rate = 0.5)  #P[X > 10]

# ¿Cual es la probabilidad de que el consumo en un dia cualquiera estre entre 5 y 8 
# millones de KW/hora?

  pgamma(8, shape = 3, rate = 0.5) - pgamma(5, shape = 3, rate = 0.5) #P[5 < X < 8]

# La distribucion Gamma es muy flexible, puede tener muchas formas

  par(mfrow=c(1,1))
  curve(dgamma(x, shape = 1, rate = 2), 0, 5)
  curve(dgamma(x, shape = 1, rate = .5), 0, 5, add = T, col = 2)
  curve(dgamma(x, shape = 2, rate = 2), 0, 5, add = T, col = 3)
  curve(dgamma(x, shape = 9, rate = 5.5), 0, 5, col = 4, add = T)

