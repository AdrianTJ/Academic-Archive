##########################################################################
################################ VECTORES ################################
##########################################################################

# Creacion de Vector
apple <- c('red','green',"yellow")
print(apple)

print(class(apple))

##########################################################################
################################# LISTAS #################################
##########################################################################

# Create a list.
lista1 <- list(c(2,5,3),21.3,sin)

print(lista1)

##########################################################################
################################ MATRICES ################################
##########################################################################

M = matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)

# Arreglos (matrices multidimensionales)
arreglo <- array(c('green','yellow'),dim = c(3,3,2))
print(arreglo)

# Creemos un data frame.
empleados.df <- data.frame(
  id = c (1:5), 
  nombre = c("Rick","Dan","Michelle","Ryan","Gary"),
  salario = c(623.3,515.2,611.0,729.0,843.25), 
  
  fechainicio = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
                          "2015-03-27")),
  stringsAsFactors = FALSE
)

# Imprimamos el DF	
print(empleados.df) 

# Veamoslo fuera de consola
View(iris.df)

# Media
mean(empleados.df$salario)

# Varianza
var(empleados.df$salario)

# Sacar Estructura
str(empleados.df)

# Sacar Resumen
summary(empleados.df)

# Si queremos solo columnas especificas
reducido.df <- data.frame(empleados.df$id,empleados.df$fechainicio)
# Porque no imprime?

# Fecha Promedio
mean.Date(reducido.df$empleados.df.fechainicio)

# Primeras dos columnas
primerasdos.df <- empleados.df[1:2,]
print(primerasdos.df)

# Primeras dos filas
primerasdos.df <- empleados.df[,1:2]
print(primerasdos.df)

# 2a y 4a fila, 3a y 5a columna
reducido.df <- empleados.df[c(3,5),c(2,4)]
print(reducido.df)

# Agregar columna
empleados.df$departamento <- c("IT","Operations","IT","HR","Finance")

# Tambien funciona cbind, rbind

# Veamos los cambios
summary(empleados.df)







iris.df <- iris # Porque es conveniente hacer esto? No se altera la estructura de los datos originales. 

View(iris.df) 
























