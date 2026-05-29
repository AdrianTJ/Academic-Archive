getwd()

setwd("/Users/Ryo/Documents/R_General/Diplomado")

getwd()

read.csv("/Users/Ryo/Documents/R_General/Diplomado/Sesion3/cities.csv")

cities <- read.csv("/Users/Ryo/Documents/R_General/Diplomado/Sesion3/cities.csv")

View(cities)

# https://archive.ics.uci.edu/ml/datasets/Wine

# https://stackoverflow.com/questions/21101927/read-files-with-extension-data-into-r

read.table("diagnosis.data", fileEncoding="UTF-16", dec=",")

Vinos <- read.table("/Users/Ryo/Documents/R_General/Diplomado/Sesion3/wine.data", fileEncoding="UTF-8", sep=",")

View(Vinos)

# Data Sets con valores que faltan

Name <- c("John", "Tim", NA)
Sex <- c("men", "men", "women")
Age <- c(45, 53, NA)
dt <- data.frame(Name, Sex, Age)

View(dt)

# IMPORTAR DE EXCEL





