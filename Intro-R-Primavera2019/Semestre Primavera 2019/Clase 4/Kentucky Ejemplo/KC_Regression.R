# Paquetes
library(plyr)
# Cambiar Directorio de trabajo
workingdir <- '~/Proyects/Intro-R-Primavera2019/Semestre Primavera 2019/Clase 3'
setwd(workingdir)




Kentucky <- read.csv("./kc_house_data.csv")

View(Kentucky)

Kentucky.df <- Kentucky[,c(-1,-16,-2)]

# Exploratory Data Analysis! 

plot(Kentucky.df$lat,Kentucky.df$long)

plot(
  Kentucky.df$lat[which(Kentucky.df$price >= mean(Kentucky.df$price))],
  Kentucky.df$long[which(Kentucky.df$price >= mean(Kentucky.df$price))]
  )

Kentucky.lm <- lm(price ~ ., data = Kentucky.df)

summary(Kentucky.lm)

plot(Kentucky.df$price, Kentucky.df$yr_built)

Kentucky.df$zipcode <- as.factor(Kentucky.df$zipcode)

promediozipcode <-with(Kentucky.df, tapply(Kentucky.df$price, Kentucky.df$zipcode, mean))

tapply(Kentucky.df$zipcode,Kentucky.df$zipcode,length)
















