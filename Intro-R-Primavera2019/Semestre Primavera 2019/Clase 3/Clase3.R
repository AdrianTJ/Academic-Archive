# While Loop

# while (test_expression)
# {
#   statement
# }

i <- 1
while (i < 6) {
  print(i)
  i = i+1
}

# For Loop

# for (val in sequence)
# {
#   statement
# }

x <- c(2,5,3,9,8,11,6)
count <- 0
for (val in x) {
  if(val %% 2 == 0)  count = count+1
}
print(count)

# If

x <- 5
if(x > 0){
  print("Numero positivo")
}

# If Else 

x <- -5
if(x > 0){
  print('Numero no negativo')
} else{
  print("Numero Negativo")
}

# If, Else, Else If

x <- 0
if (x < 0) {
  print("Negative number")
} else if (x > 0) {
  print("Positive number")
} else
  print("Zero")

# Funciones 

# f <- function(<arguments>) {
#   Do something interesting
# }

# Una funcion con una sola variable

f <- function(a) {
  a^2
}

f(2)

# Funcion con muchos argumentos, podemos solo usar uno

f <- function(a,b,c) {
  a^2
}

f(2)

# Funcion con muchos argumentos, pero si uno es requerido, y no se pone, hay error. 

f <- function(a, b) {
  print(a)
  print(b)
}

f(4)

# Funcion de dos variables, pero falta la z

f <- function(x, y) {
  x^2 + y / z
}

f(3,5)

# Funcion de funciones 

make.power <- function(n) {
  pow <- function(x) {
    x^n
  }
  pow
}

cubo <- make.power(2)

cubo(3)










