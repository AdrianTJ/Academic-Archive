###############################################################################
#                             INTRODUCCION A R                                #
#             AJUSTE DE DISTRIBUCIONES Y PRUEBAS DE HIPOTESIS                 #
#                                                                             #
#                     ERNESTO JUVENAL BARRIOS ZAMUDIO                         # 
#                         PAULINA PRECIADO LOPEZ                              #  
#                             12 / Abr / 2014                                 #
###############################################################################

set.seed(250582)

###############################################################################

# Usualmente en estadistica queremos:

# Caracterizar la distribucion de datos univariados

  # Es simetrica o sesgada?
  # Una moda o varias?
  # Como son las colas de la distribucion?
  # Se parece a alguna familia de distribuciones?

# Comparar la distribucion de dos conjuntos de datos
  # Son iguales las medias? Y las varianzas?
  # Las funciones de densidad o de probabilidad acumulada (estimadas) tienen
  # formas similares?

# Tenemos muchas herramientas graficas y pruebas de hipotesis para responder
# estas preguntas

#------------------------------------------------------------------------------
# Herramientas Graficas
#------------------------------------------------------------------------------

# Generemos algunos datos

  x <- rnorm(100, mean = 5, sd = 3)
  y <- rgamma(150, shape = 1, rate = 4)

# Los histogramas y boxplots nos dan informacion sobre la distribucion de los
# datos
  # Tendencia central (media, mediana)
  # Sesgo
  # Modas

  par(mfrow=(c(2,2)))

  boxplot(x, main = "x", horizontal = T)
  boxplot(y, main = "y", horizontal = T)

  hist(x, freq = F, main = "x")
  lines(density(x))

  hist(y, freq = F, main = "y")
  lines(density(y))

# La densidad de x es mas o menos simetrica y unimodal
# La densidad de y esta sesgada (positivamente)

# Tambien vimos ya la funcion ecdf que construye la funcion empirica de
# probabilidad acumulada o distribucion (fepc)

  par(mfrow=c(1,2))
  plot(ecdf(x))
  curve(pnorm(x, mean = 5, sd = 3), add = T, col = "red")
  abline(v = mean(x), col = "blue")
  plot(ecdf(y))
  curve(pgamma(x, shape = 1, rate = 4), add = T, col = "red")
  abline(v = mean(y), col = "blue")

# Esta funcion da saltos de 1/n donde n es el tamano de la muestra. 
# La definimos como 
  #F[t] = 1/n (numero de elementos en la muestra <= t)

# Esta grafica muestra que la fepc de una normal tiene forma de S, que es
# simetrica y que cambia de curvatura en la media

# La fepc de una gamma con estos parametros (1 y 4) es una curva asimetrica 
# que crece rapido primero y luego lento

#QQ-plot
#########
# El grafico Q-Q o cuantil-cuantil es otra herramienta visual para evaluar
# las caracteristicas de la distribucion de los datos y compararlos con
# distribuciones teoricas

  ?qqplot

# Compara los cuantiles de dos distribuciones. Casos:
  
  # La de los datos de interes con los de datos generados aleatoriamente de 
  # una distribucion teorica de la que se cree que los datos provienen
  
  # La de dos pares de datos empiricos si se quieren evaluar las similitudes
  # y diferencias entre sus distribuciones

  # La de los datos con los cuantiles de una normal

# El ultimo caso tiene una funcion especial que se llama qqnorm

# Recordemos que el cuantil k se define como el primer valor q para el que
# P[X < = q ]  = k. Por ejemplo, la mediana es el punto q que acumula 0.5 (50%)
# de la probabilidad

# Si los cuantiles se parecen, es evidencia de que los datos provienen de la
# misma familia de distribuciones

# Veamos la grafica qqnorm de x

  par(mfrow = c(1,1))
  qqnorm(x)

# Esta grafica compara los cuantiles de x con los de una normal (estandar)

# Podemos agregar una linea recta que nos ayude a evaluar la similitud
# entre los cuantiles

  qqline(x)

# qqline por default genera una linea recta entre el primer y el tercer
# tercil observados y teoricos (con una distribucion teorica normal)
# de forma que entre mas cercanos sean los puntos del grafico qq a la
# recta, mas fuerte es la evidencia sobre la similitud entre los
# cuantiles de los datos comparados

# Veamos ahora los de y

  qqplot(rgamma(1000, shape = 1, rate = 4), y, xlab = "Cuantiles Teoricos")
  qqline(y, distribution = function(p) qgamma(p, rate = 4, shape = 1))

  #Notar que tuvimos que hacer para especificar el qqline de la gamma

#-----
# En estos casos conocemos la distribucion y los parametros, pero en aplica-
# ciones reales no es asi.

# Usualmente el problema es evaluar si los datos tienen una distribucion
# aproximadamente normal

# Tomemos como ejemplo los datos Salaries en la libreria car
  
  library(car)
  ?Salaries

# Veamos los salarios de los hombres

  sal.h <- Salaries[Salaries$sex == "Male",]$salary
  length(sal.h)
  summary(sal.h); sd(sal.h)

  par(mfrow = c(1,2))
  hist(sal.h, freq = F, col = "steelblue", 
       main = "Histograma salarios hombres", cex.main = 0.8)
  lines(density(sal.h))
  boxplot(sal.h, main = "Boxplot salarios hombres", cex.main = 0.8)

# Normalizamos los datos
  sal.h.n <- scale(sal.h)

  plot(ecdf(sal.h.n), main = "ECDF Salarios hombres normalizados",
       cex.main = 0.7)
  curve(pnorm(x), col = "red", add = T)

  qqnorm(sal.h.n, cex.main = 0.8, ylab = "Cuantiles muestrales",
         xlab = "Cuantiles teoricos")
  qqline(sal.h.n)

# No parece que la distribucion sea normal, de hecho se aprecia un sesgo
# positivo considerable y diferencias importantes entre la ecdf y la 
# teorica y los cuantiles empiricos y teoricos

# Que pasa si tomamos el logaritmo?

  log.sal.h <- log(Salaries[Salaries$sex == "Male",]$salary)
  length(log.sal.h)
  summary(log.sal.h)
  
  par(mfrow = c(1,2))
  hist(log.sal.h, freq = F, col = "steelblue", 
       main = "Histograma log-salarios hombres", cex.main = 0.8)
  lines(density(log.sal.h))
  boxplot(log.sal.h, main = "Boxplot salarios hombres")

# El sesgo positivo es considerablemente dismunido. Normalizamos los datos
  log.sal.h.n <- scale(log.sal.h)
  
  plot(ecdf(log.sal.h.n), main = "ECDF log-Salarios hombres normalizados",
       cex.main = 0.7)
  curve(pnorm(x), col = "red", add = T)
  
  qqnorm(log.sal.h.n, cex.main = 0.8, ylab = "Cuantiles muestrales",
         xlab = "Cuantiles teoricos")
  qqline(log.sal.h.n)

# Ahora hay mas similitud con una normal, pero las colas de las distribucion
# siguen desviandose de este supuesto



