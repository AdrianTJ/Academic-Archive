# Datos tomados de https://www.inegi.org.mx/temas/salud/default.html#Tabulados
# Defunciones por suicidio por entidad federativa y grupos quinquenales de edad según sexo
# Estudio Universitario: https://www.hoylosangeles.com/noticias/local/hoyla-loc-con-toda-una-vida-por-delante-universitarios-estan-considerando-el-suicidio-20180912-story.html

setwd('/Users/ryosc/Documents/R/SesionesClase/Sesion10/')
Datos <- read.csv(file='./Mental_06.csv')

Totales <- subset(Datos,Datos$Entidad.federativa == 'Total')

Totales <- Totales[,-1]

Totales <- Totales[,c(1,2,5,8,11,14,17,20,23)]

Totales.final <- as.data.frame(t(Totales))
colnames(Totales.final) <- as.character(unlist(Totales.final[1,]))
Totales.final = Totales.final[-1, ]

hist(Totales.final$`10 a 14 años`) # Error! Niveles. 

str(Totales.final)

as.numeric(Totales.final$`10 a 14 años`)

as.numeric(levels(Totales.final$`10 a 14 años`))[Totales.final$`10 a 14 años`]

hist(as.numeric(levels(Totales.final$`10 a 14 años`))[Totales.final$`10 a 14 años`])

barplot(as.numeric(levels(Totales.final$`10 a 14 años`))[Totales.final$`10 a 14 años`])

barplot(as.numeric(levels(Totales.final$`20 a 24 años`))[Totales.final$`20 a 24 años`])

barplot(as.numeric(levels(Totales.final$Total))[Totales.final$Total])








