
###############################################################################
#                             INTRODUCCION A R                                #
#                          VISUALIZACION DE DATOS                             #
#                                                                             #
#                     ERNESTO JUVENAL BARRIOS ZAMUDIO                         # 
#                         PAULINA PRECIADO LOPEZ                              #  
#                             29 / Mar / 2014                                 #
###############################################################################

###############################################################################

# La visualizacion de datos es fundamental en el analisis estadistico. R permite
# hacer muchos tipos de graficos. Aqui se muestran algunos de los ejemplos mas 
# comunes. Los datos que se usan son simulados o datos preconstruidos de R

# Los graficos se despliegan en el dispositivo grafico. Es posible crearlos di-
# rectamente en un archivo o guardarlos con varios formatos como .pdf, .png, 
# .jpeg, etc.

# Los comandos graficos de alto nivel generan graficos nuevos. Los comandos de
# bajo nivel agregan informacion a graficos existentes. Los comandos interacti-
# vos sirven para agregar o extraer informacion de un grafico usando el mouse.

# Existe un gran numero de parametros graficos para personalizar la vi-
# sualizacion

#------------------------------------------------------------------------------
# 1. La funcion plot()
#------------------------------------------------------------------------------

# La funcion grafica mas comun es plot(). Dependiendo del tipo de los objetos a 
# graficar, plot produce diferences visualizaciones

# plot(x) 

  # Si x es un vector numerico, produce un grafico de dispersion de los valores
  # de x contra el indice

    x <- rnorm(100) # muestra aleatoria de distribucion normal estandar
    plot(x)

  # Podemos modificar algunos parametros para personalizar la grafica

    plot(x, main = "Grafico de dispersion", ylab = "x ~ N(0,1)", xlab = "Num. Obs")

    plot(x, main = "Grafico de dispersion", ylab = "x ~ N(0,1)", xlab = "Num. Obs", col = 4, 
         bg ="grey", pch = 21, col.axis = "red", col.main = "hotpink4")

  # Algunos de estos parametros se pueden explorar en la ayuda de plot(). Una lista mas completa
  # puede encontrarse en la funcion par()

  # Si x es un factor, produce un grafico de barras

    (fac <- as.factor(sample(c("a", "b", "c"), 100, replace = TRUE)))

    plot(fac)
    
    plot(fac, xlab= "Factor")
    
    plot(fac, xlab = "Factor", col = rainbow(10), ylim = c(0,50))

# plot(x,y)

  # Si x y y son vectores numericos de la misma longitud

    y <- rnorm(length(x), mean = 0, sd = 0.5) + 2*jitter(x)
    
    plot(x, y)
    
    plot(y ~ x) #Equivalente a plot(x,y)
    
  # Si x es un vector numerico y y un factor

    plot(x, fac)
    plot(fac, x) # grafico de caja y brazos de x para cada nivel de fac

  # Si ambos son factores
    
    (fac2 <- as.factor(sample(c("Si", "No"), 100, replace = TRUE)))
    
    plot(fac, fac2)

    plot(fac, fac2, main = "Grafico de Mosaico para dos factores", col = c("blue", "red"))

# Si x es una serie de tiempo, grafica como serie de tiempo

  ?UKgas
  
  plot(UKgas)
  #plot.ts(UKgas) #equivalentes
  
  #?plot.ts


# Tambien es posible pasar como argumento una tabla de datos

  tabla2 <- data.frame( x, y, fac, fac2)
  
  head(tabla2)  
  
  plot(tabla2)

# Esta visualizacion dependera de los tipos de datos en la tabla. Generalmente
# se produce una matriz de dispersion (graficos de dispersion de cada variable
# contra cada variable)

#------------------------------------------------------------------------------
# 2. Visualizacion de datos univariados continuos
#------------------------------------------------------------------------------

# Cuando tenemos datos univariados de variables continuas suele de interes vi-
# sualizar su distribucion o densidad, para lo que un grafico de dispersion no
# sirve

  plot(x)

# R tiene otras funciones graficas de alto nivel para darnos esta facilidad

## HISTOGRAMAS Y CURVAS DE DENSIDAD ESTIMADA
#--------------------------------------------
# Como vimos en la seccion de manipulacion de datos, la funcion hist() grafica
# un histograma de un vector numerico

# Veamos el histograma del vector x que fue es una muestra aleatoria de tamano
# 100 de una normal estandar

  hist(x)

# El eje y dice "Frequency" lo que implica que la altura del rectangulo representa
# conteos dentro de las celdas. Si cambiamos el parametro frequency a FALSE obtene
# mos la proporcion de observaciones dentro de cada celda.

  hist(x, freq = F)

# Veamos un histograma para los datos preconstruidos "faithful"

  attach(faithful)
  head(faithful, n = 10)

  hist(eruptions, main = "Histograma de la duracion de las 
       erupciones del Geyser Old Faithful",
       xlab = "Min", ylab = "Frecuencias", ylim = c(0, 80),
       xlim = c(1, 6), col = "limegreen")

# R clasifica los datos en celdas y cuenta el numero de observaciones que caen
# en cada celda. Es posible modificar la construccion del histograma con para-
# metros como freq, breaks, etc. Ver ?hist para detalles al respecto.

# En particular, para graficar proporciones en lugar de frecuencias usamos
# freq = F o probability = T

  hist(eruptions, main = "Histograma de la duracion de las 
         erupciones del Geyser Old Faithful",
       xlab = "Tiempo espera (min)", ylab = "Proporciones", freq =F,
       xlim = c(min(eruptions) - .5, max(eruptions) + .5),
       col = "limegreen")

# Si usamos proporciones la suma del area de los rectangulos es igual a 1

# Podemos cambiar el numero de celdas de forma manual, o escogiendo otro metodo

  (w <- hist(eruptions, main = "Histograma de la duracion de las \nerupciones del Geyser Old Faithful",
       xlab = "Tiempo espera (min)", ylab = "Proporciones", probability =T,
       xlim = c(min(eruptions) - .5, max(eruptions) + .5),
       col = "limegreen",
       breaks = 15))

# Agregemos una linea horizontal que pase por la proporcion media

  abline( h = mean(w$density), col = "red", lty = "dotted")

# Podemos agregar una curva suave que estime la funcion de densidad de el
# tiempo de duracion de las erupciones con la funciones density y la funcion
# lines
  
  lines(density(eruptions))

# Supongamos que queremos ver una grafica de este tipo para los tiempos de espera entre 
# las erupciones y los tiempos de espera en paralelo

  par(mfrow = c(1, 2)) 

  #Divide el dispositivo grafico en un renglon y dos columnas

  hist(eruptions, main = "Duracion Erupciones",
     xlab = "Tiempo espera (min)", ylab = "Proporciones", probability =T,
     xlim = c(min(eruptions) - .5, max(eruptions) + .5), cex.main = .7,
     cex.lab = .7,
     col = "limegreen")

  # El argumento "freq = FALSE" hace que el histograma represente proporcio-
  # nes en lugar de frecuencias y el total del area del histograma es 1. Los ar-
  # gumentos cex.main y cex.lab reducen el tamano del texto del titulo y los
  # ejes respectivamente

  lines(density(eruptions))

  # Agrega un estimador suave de la densidad (estimador kernel)

  hist(waiting, main = "Tiempo de espera",
       xlab = "Tiempo de espera (min)",col = "hotpink2", cex.main = 0.7, 
       cex.lab = 0.7, freq = FALSE)

  lines(density(waiting))

# Quitemos los datos

  detach(faithful)

## GRAFICOS DE TALLOS Y HOJAS
#--------------------------------------------

# La funcion stem() produce una grafica de tallos y hojas que son visualizacio-
# nes utiles para datos pequenos

# Utilizaremos el conjunto de datos USArrests que contiene las tasas de arrestos
# de 3 tipos de crimenes violentos en 50 estados de los Estados Unidos en 1973. 
# Estan construidas como el numero de arrestos por cada 100,000 habitantes. Ade-
# mas de da el porcentaje de poblacion urbana.

  attach(USArrests)
  head(USArrests)
  ?USArrests

# Veamos un grafico de tallos y hojas para la proporcion de poblacion urbana

  stem(UrbanPop)

# La grafica se construye separando cada valor, de forma que el ultimo digito es
# la hoja y el primero el tallo (a la izquierda de |). La primera barra esta for-
# mada por 3 | 29, para representar que hay un 32 y un 39 en UrbanPop. La segunda
# barra 4 | 445588 indica que hay dos valores 44, dos 45 y dos 48. Y asi sucesi-
# vamente.

# La grafica stem() permite observar rasgos de la distribucion como el rango,
# sesgo, modas, etc.


## DIAGRAMAS DE CAJAS Y BRAZOS
#--------------------------------------------

par(mfrow = c(1,1))

# Los diagramas de cajas y brazos o boxplot son otra forma de visualizar datos
# continuos en donde puede observarse el rango inter-cuartil ,la mediana, posi-
# bles valores atipicos, etc.

# Tambien es una forma facil de comparar la distribucion de una variable 
# continua agrupada con respecto a un factor.

# Veamos una grafica de cajas y brazos para las tasas de arresto por asesinato
# de los datos USArrests

  boxplot(Murder, border = "magenta4", col ="pink", 
          main = "Tasa de arrestos por asesinato en 50 \nestados de Estados Unidos en 1973",
          cex.main = 0.9)
  
  abline( h = mean(Murder), lwd = 2, lty= 2)
  
  legend("topright", "Tasa media", lwd = 2, col =1, cex = 0.8, lty = 2) 

# La linea negra representa la tasa media de arrestos por asesinato y es agrega-
# da con el comando abline que agrega lineas rectas a una grafica. Veamos

  ?abline

# El grafico tambien muestra una leyenda para explicar lo que la linea representa,
# esta fue agregada con la funcion legend

  ?legend

# Las graficas de cajas y brazos pueden cambiarse de orientacion haciendo que
# el parametro "horizontal" sea TRUE y se puede hacer que las cajas tengan muescas
# estableciendo el parametro "notch" como TRUE. Para otras opciones ver ?boxplot

  boxplot(Murder, border = "magenta4", col ="pink", 
        main = "Tasa de arrestos por asesinato en 50 \nestados de Estados Unidos en 1973",
        cex.main = 0.9, horizontal = T, notch = T)



# Veamos un diagrama de cajas y brazos de una variable continua agrupada. Usaremos
# datos simulados sobre el genero y el salario de 20 individuos

  tabla1 <- read.table("Ingreso_Genero.txt", header=T, quote="\"")
  head(tabla1)
  attach(tabla1)

  boxplot(Ingreso ~ Genero, names = c("Mujeres", "Hombres"), ylab = "Ingreso") 
  
  medias <- tapply(Ingreso, Genero, mean) # Calcula la media de cada grupo
  
  abline(h = medias, col = c(2,3), lty = 2)
  
  legend("topright", c("Ingreso Medio Mujeres", "Ingreso Medio Hombres"), 
         lty = 2, col = c(2,3), cex = 0.7)

#------------------------------------------------------------------------------
# 3. Visualizacion de datos discretos
#------------------------------------------------------------------------------

# La forma mas comun de representar datos categoricos es la grafica de barras.
# Vimos que la funcion plot(fac) produce dicha grafica cuando fac es un factor.
# La funcion barplot() nos da facilidades mas directas para este tipo de graficas.

  ?barplot

# El argumento esencial es "height" que puede ser un vector numerico o una matriz.
# Si es un vector, se construye una grafica en que altura de las barras esta dada
# por cada entrada.
  
  (vect <- sample(10:20, replace = TRUE, size = 5))

  barplot(vect)

  barplot(vect, names = letters[1:5], legend.text = "Ejemplo", 
          col = c("forestgreen", "steelblue"),
          density = c(50, 50), border = TRUE, angle = c(25, 90 ))

  (matriz <- matrix(sample(10:30, replace = TRUE, size = 9), nrow = 3, ncol = 3,
                    dimnames = list(c("r1", "r2", "r3"), c("c1", "c2", "c3"))))

  par(mfrow = c(1,2))
  
  barplot(matriz)
  
  barplot(matriz , beside = TRUE)

# Si tenemos un factor como

  fac

# Y  llamamos la funcion barplot

  barplot(fac)

# Produce un error porque fac no es un vector ni una matriz de frecuencias. 
# Debemos usar:

  barplot(table(fac))

# Alternativamente

  plot(fac, col = 2, space = 0.1, density = 30)

# Notar que acepta los mismos parametros que barplot porque el argumento es un
# factor

## GRAFICA DE PUNTOS
#-------------------------------------
# Otra representacion grafica para datos categoricos nos la da la funcion 
# dotchart que produce una grafica de puntos

  par(mfrow = c(1,1))

  dotchart(table(fac))
  
  dotchart(matriz)

# Ver ?dotchart para detalles

## GRAFICA DE PIE
#-------------------------------------
# Tambien se utilizan graficas circulares o de pie para representar factores. Mos-
# tramos brevemente como hacerlas pero queremos recalcar que estos graficos no son
# recomendados 

  
  pie(table(fac))

# Notar que es dificil distinguir que regiones son mas grandes porque algunos
# valores son muy similares

  par(mfrow = c(1,2))

  pie(table(fac))
  barplot(table(fac))

#------------------------------------------------------------------------------
# 3. Visualizacion de datos multivariados
#------------------------------------------------------------------------------

# Las matrices de dispersion proveen una forma simple de visualizar las relacio-
# nes entre pares de variables cuando los datos tienen tres o mas variables. Esto
# se hace con la funcion pairs()

  pairs(USArrests)

# Podemos personalizar la visualizacion agregando titulos, cambiando las etiquetas,
# colores, etc.

  pairs(USArrests, main = "Matriz de dispersion", labels = c("Asesinato", 
       "Asalto", "PobUrbana", "Violacion"), pch = 21, col = 1, bg = "gray",
        cex.labels = 0.9, panel = panel.smooth)

# Usaremos un ejemplo de la descripcion de la funcion pairs para hacer que nuestra
# grafica tenga histogramas de cada variable en la diagonal y las correlaciones
# entre variables en los cuadros arriba de la diagonal.

# Copiamos la funcion panel.hist que definira el contenido de la diagonal

  panel.hist <- function(x, ...)
  {
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col = "gray",...)
  }

# Y la funcion panel.cor que escribira la correlacion entre pares de variables (con
# algunas modificaciones)

  panel.cor <- function(x, y, digits = 2, cex.cor = 1.5, ...)
  {
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- cor(x, y)
    txt <- format(r, digits = digits)
    text(0.5, 0.5, txt, cex = cex.cor)
  }
  
# Veamos la grafica 

  pairs(USArrests, main = "Matriz de dispersion", labels = c("Asesinato",
        "Asalto", "PobUrbana", "Violacion"), 
        cex.labels = 0.9, lower.panel = panel.smooth, upper.panel = panel.cor,
        diag.panel = panel.hist)

#------------------------------------------------------------------------------
# 4. Interactuar con el mouse
#------------------------------------------------------------------------------

# Si queremos obtener las coordenadas de algun punto en una grafica, por ejemplo
# para agregar una leyenda en esa posicion podemos usar la funcion locator

  plot(Murder , Assault)
  (loc <- locator())

# Damos clic en el boton "Esc" pra terminar y agregamos una leyenda en esa posicion
  
  legend(loc, "Una leyenda")

# O texto
  (loc <- locator())
  text(loc, "Agregamos texto", col = "purple", font = 8)

# Tambien podemos usar la funcion identify() para encontrar puntos en la grafica,
# posiblemente con etiquetas

  identify(Murder , Assault, row.names(USArrests))



