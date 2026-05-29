# Help
help(install.packages)
?install.packages

# Paquetes
install.packages('tidyverse')
library(tidyverse)

# Calculos
12 + 36
12 - 36
12 * 6
12 / 7
12^7
12 %% 7
12 %/% 7

# Variables 
# https://csgillespie.wordpress.com/2010/11/16/assignment-operators-in-r-vs/

variable.numerica1 <- 12 
print(class(variable.numerica1))

variable.string <- "hola"
print(class(variable.string))

variable.boolean <- TRUE
print(class(variable.boolean))

variable.double <- 2.718
print(variable.double)

vector1 <- c(1,2,5.3,6,-2,4) # Vector Numerico
vector2 <- c("one","two","three") # Vector de caracteres
vector3 <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) # Vector Logico
print(class(vector1))
print(class(vector2))
print(class(vector3))

variable.raw <- charToRaw("Hello")
print(class(variable.raw)) # Guardado como 48 65 6c 6c 6f

variable.compleja <- 2+5i
print(class(variable.compleja))

variable.fecha <- as.Date("2012-01-01")
class(variable.fecha)







