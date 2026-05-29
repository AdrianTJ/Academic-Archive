###############################################################################
#                             INTRODUCCION A R                                #
#                           MANIPULACION AVANZADA                             #
#                                                                             #
#                     ERNESTO JUVENAL BARRIOS ZAMUDIO                         # 
#                         PAULINA PRECIADO LOPEZ                              #  
#                             05 / Abr / 2014                                 #
###############################################################################

set.seed(31416)

###############################################################################
#------------------------------------------------------------------------------
# Ejecucion Controlada
#------------------------------------------------------------------------------

# A veces es necesario que la ejecucion de comandos este controlada. Por ejemplo,
# que solamente se ejecute si se cumplen ciertas condiciones o que se repitan
# expresiones cierto numero de veces.

# Para esto usamos funciones de ejecucion condicional y repetitiva como "if", "for",
# "while", etc.

  ?Control


# Estas funciones para controlar las ejecuciones de comandos pueden ser utiles
# al programar nuestras propias funciones


# If, Else, Ifelse
#-----------------

# La funcion "if" es para ejecutar una expresion si una expresion logica es verdadera
# La sintaxis mas basica es "if(cond) expr"

  (x <- sample(1:100, 1, rep = T))

  if(x >= 50) x^2

# Tambien es posible indicar que hacer si la condicion o expresion logica es falsa usando
# else 

  (x <- sample(1:100, 1, rep = T))
  if(x >= 50) {print("Cuadrado"); x^2} else {print("Logaritmo"); log(x)}

# Notar que podemos agrupar comandos usando llaves {} de forma que si la expresion 
# logica es cierta o es falsa pueden ejecutarse varios comandos, no solamente uno
  
# Tambien podemos usar varias expresiones logicas o condiciones simultaneamente

  x <- runif(1, min = -10, max = 10)
  x
  if( (x <0) & (abs(x) >= 5)) {print("Cuadrado"); x^2} else {print("Cubo"); x^3}

# Un atajo es la funcion "ifelse"

  ?ifelse

# Los argumentos son: test(prueba logica), yes(que hacer si es cierta) y no (que hacer
# si es falsa)

  ifelse(runif(10, -10, 10) <0, "negativo", "positivo")

# ifelse puede ser complicada de usar si hay condiciones y/o expresiones anidadas

# For, while
#-----------------

# A veces es deseable repetir un comando o conjunto de comandos un numero fijo de
# veces o hasta que una condicion se cumpla

# Las funciones "for", "while" sirven para esto

# La funcion for requiere de un indice que toma valores en una cierta secuencia finita
# En cada iteracion el indice toma el siguiente valor de la secuencia

# Tiene la sintaxis "for(var in seq) expr"

# Veamos un ejemplo facil

  for(var in 1:10) print(paste("El indice esta en el valor", var))

# Esto podemos hacerlo de forma mas facil con

  print(paste("El indice esta en el valor", 1:10))

# Veamos un ejemplo mas interesante. Usemos los datos case0601 de la libreria Sleuth2

  library(Sleuth2)
  ?case0601

# Contienen las calificaciones que las solicitudes de empleo recibieron por parte de
# estudiantes universitarios en un experimento. Algunos de los solicitantes mostraban
# discapacidades (amputacion, muletas, auditivo o silla de ruedas)

  head(case0601)

# Primero calculemos la calificacion promedio por tipo de discapacidad

  (medias <- tapply(case0601$Score, case0601$Handicap, mean))

# Ahora, creemos una nueva variable calif.ajust que divide el Score por la media
# dependiendo del tipo de discapacidad correspondiente

  case0601$calif.ajust <- numeric(length = dim(case0601)[1])
  head(case0601)

  for(i in 1:nrow(case0601)){
    
    if(case0601[i, 'Handicap'] == 'None'){
      case0601[i, 'calif.ajust'] <- case0601[i, 'Score'] / medias[1]
    }
    if(case0601[i, 'Handicap'] == 'Amputee'){
      case0601[i, 'calif.ajust'] <- case0601[i, 'Score'] / medias[2]
    }
    if(case0601[i, 'Handicap'] == 'Crutches'){
      case0601[i, 'calif.ajust'] <- case0601[i, 'Score'] / medias[3]
    }
    if(case0601[i, 'Handicap'] == 'Hearing'){
      case0601[i, 'calif.ajust'] <- case0601[i, 'Score'] / medias[4]
    }
    
    if(case0601[i, 'Handicap'] == 'Wheelchair'){
      case0601[i, 'calif.ajust'] <- case0601[i, 'Score'] / medias[5]
    }
  }

  head(case0601)

# La funcion while tambien sirve para repetir comandos. La sintaxis es 
# "while (cond) expr" que ejecuta "expr" hasta que la condicion "cond" sea falsa. 

# Por ejemplo

  i <- 1
  while ( i < 10) {
    print(paste("El resultado de", i, "al cuadrado es", i^2))
    i <- i + 2
  }

# Otro ejemplo: numero de simulaciones de una variable aleatoria x ~ Poisson(k = 1)
# hasta que obtengamos 3 o mas eventos

x <- rpois(1, lam = 1)
k <- 0

while(x <= 2){
  x <- rexp(1, rate = 1)
  k <- k + 1
}

k

# Notar que la funcion while usualmente requiere inicializar variables

#------------------------------------------------------------------------------
# La familia "apply"
#------------------------------------------------------------------------------

# Usar ciclos tiene aspectos indeseables:
  
#1. Las variables usadas para indexar se quedan en el ambiente

  (i <- "Hola")
  for(i in 1:5) print(paste("Iteracion", i))
  i # i ya no es "Hola"

# Tenemos que llevar control  de que variables se usan para iterar, o cuales se 
# generan dentro de un ciclo pero en realidad no nos interesa conservar

#2. Pueden ser procesos muy lentos o que requieren muchas lineas de codigo.
# Por ejemplo sacar la media de un vector numerico por cada nivel de un factor
# usando un ciclo (ojo, es muy ineficiente a proposito)

  x <- rnorm(100000) #Muestra aleatoria normal estandar de tamano 1000
  f <- sample(c("A","B"), 100000, rep = T)

  t1 <- proc.time() # Para medir el tiempo que tarda en ejecutarse el ciclo

  sum.A <- numeric(length = 1)
  sum.B <- numeric(length = 1)
  num.A <- numeric(length = 1)
  num.B <- numeric(length = 1)

  for(i in 1:100000){
    
    if(f[i] == "A"){
      sum.A <- sum.A + x[i]
      num.A <- num.A + 1
    }else{
      sum.B <- sum.B + x[i]
      num.B <- num.B + 1
  }}

  (med.A <- sum.A/num.A)
  (med.B <- sum.B/num.B)

  (t1.f <- proc.time() - t1)

# Tenemos que ir entrada por entrada, ver si el factor f es A o B e ir acumulando
# los valores de x segun corresponda

# R tiene una familia de funciones llamada la familia apply que pueden hacere lo mismo
# que los ciclos, sin dejar variables indeseables en el ambiente y de forma mucho
# mas eficiente

# Para el ejemplo anterior podemos usar una funcion que ya conocemos: tapply

  t2 <- proc.time()
  
  tapply(x, f, mean)

  (t2.f <- proc.time() - t2)

# tapply divide los datos x en dos bloques de forma eficiente y hace el calculo
# para cada bloque

# Hay muchas funciones en la familia apply, de la libreria base veremos: apply,
# lapply, sapply y tapply (que ya vimos) y de la libreria plyr veremos ddply
# y ldply


# apply
#------------

  ?apply

# Se usa para aplicar una funcion a una matriz (o arreglo) por columnas o por
# renglones (o por capas)
# Los argumentos son X: el arreglo o matriz, MARGIN: 1 para renglones, 2 para
# columnas, etc y FUN: la funcion que utilizar

  (mat <- matrix(sample(1:1000, 28, rep = T), ncol = 4))

# Minimo de cada renglon

  (min.col <- apply(mat, 1, min))

# Media y desviacion estandar de cada columna

  (apply(mat, 2, mean))

  (apply(mat, 2, sd))

# OJO: No funciona con tablas de datos, tienen que ser matrices (pueden ser sub-
# conjuntos numericos de tablas de datos)

# Es posible que FUN sea una funcion que nosotros especifiquemos por ejemplo

  apply(mat, 2, function(columna){mean(columna)/sd(columna)})

# Aprenderemos como programar nuestras funciones mas adelante


# lapply y sapply
#------------------

# lapply y sapply son para listas. Aplican una funcion a cada elemento de la lista

  ?lapply

# lapply regresa una lista de la misma longitud que los datos originales y 
# sapply trata de regresar los datos en un vector o matriz

# Los argumentos basicos son la lista X y la funcion a aplicar

  (x <- list(a = 1:10, beta = exp(-3:3), matriz = matrix(1:6, ncol = 3)))

# Calculemos la media por cada variable

  lapply(x, mean)

  sapply(x, mean)

# Y los cuartiles

  lapply(x, quantile)

  sapply(x, quantile)
  class(sapply(x, quantile))


# La libreria plyr
#------------------

# La libreria plyr es de Hadley Wickham y contiene funciones para partir datos,
# utilizar funciones por bloques y agregar datos

  library(plyr)

# Es muy comun que para una tabla de datos queramos utilizar funciones por bloques
# definidos por una cierta variable y obtener como resultado una  tabla de datos
# (no una lista o una matriz)

# Para esto podemos usar la funcion ddply: data.frame-to-data.frame apply

  ?ddply

# Para subconjuntos de una tabla de datos .data definidos por variables .variables
# podemos utilizar una funcion y luego combinar los resultados en un data.frame

# Usemos los datos case0601 de la libreria Sleuth2

  library(Sleuth2)
  head(case0601)

# Para cada nivel de "Handicap" calculemos la media, la desviacion estandar,
# el minimo y el maximo

  (res <- ddply(case0601, .(Handicap), summarise, med = mean(Score), err.est = sd(Score),
        min = min(Score), max = max(Score)))

  class(res)

# Ahora podemos utilizar res como otra tabla de datos

# La libreria plyr tiene muchas otras funciones en la familia apply como:

  #ldply para pasar de listas a data.frames
  #adply para pasar de arreglos a data.frames, etc.
       
#------------------------------------------------------------------------------
# Programar funciones
#------------------------------------------------------------------------------

# Los usuarios pueden programar sus propias funciones y esta es una de las fa-
# ciliades de R que resultan mas utiles. Aqui damos una descripcion MUY basica

# De forma general la sintaxis de una funcion es 

  # nombre_fun <- function (arg_1, arg_2,..., arg_n) {expr_1; expr_2;...;expr_m}

# El resultado que la funcion regresa es la ultima expresion

# Ejemplo: Raiz enesima de un numero

  raiz_n <- function (x, n) { x ^ (1/n) }

  raiz_n (8,3)
  raiz_n (-1,5)

# Otro ejemplo: centrar los renglones o las columnas de una matriz respecto a la media

  centrar_mat <- function(mat, by = c("reng", "cols")){
    
    if(by == "reng"){
      
      med <- rowMeans(mat)
      mat2 <- mat - med
      
    }else{
      
      med <- colMeans(mat)
      mat2 <-  t(t(mat) - med)
    }
    
    mat2
    
  }

  (mat <- matrix(sample(1:100, 21, rep = T), ncol = 3))

  centrar_mat(mat, by = "reng")

# Podemos hacer que algunos argumentos tengan valores por defecto

# Graficar un histograma de una muestra aleatoria normal de tamano "n", media "m"
# y desviacion estandar "de" 

  grafnorm <- function (n, m = 0, de = 1){
    muestra <- rnorm(n, m, de)
    hist(muestra)
  }

  grafnorm( 100, m = 8, de = 10)

#  Guardemos el resultado de la funcion

  (res <- grafnorm(100))

# Es un histograma. Esto sucede porque la ultima expresion en la funcion es la
# llamada a la funcion hist(). Si queremos que la funcion nos regrese la muestra 
# simulada en lugar del histograma

  grafnorm <- function (n, m = 0, de = 1){
    muestra <- rnorm(n, m, de)
    hist (muestra)
    muestra
  }

(res <- grafnorm(100))

# Notar que la asignacion de la variable "muestra" es interna a la funcion y tem-
# poral

  muestra

# Tambien podemos regresar la muestra y el histograma usando list()

  grafnorm <- function (n, m = 0, de = 1){
    muestra <- rnorm(n, m, de)
    (histo <- hist (muestra))
    list(muestra, histo)
  }
