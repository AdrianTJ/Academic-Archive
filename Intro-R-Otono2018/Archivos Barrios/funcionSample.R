#------------------------------------------------------------------------------
# Breve introduccion a la funcion "sample"
#------------------------------------------------------------------------------

# La funcion sample es muy utilizada. Toma una muestra aleatoria de los elementos de un
# vector x (o de una secuencia regular de 1 a x) del tamano deseado, con o sin reemplazo
# con probabilidades iguales o desiguales


sample(10, size = 5, rep = F)

sample(1:10, size = 5, rep = F)

sample(c("Hom", "Muj"), size = 10, prob = c(.49, .51))

sample(c("Hom", "Muj"), size = 10, rep = T, prob = c(.49, .51))
