install.packages("tidyverse")
install.packages('GGally')
library(GGally)
library(ggplot2)

Irisdata <- iris
View(Irisdata)
dim(iris)
table(iris$Species) #Have equal number of each
str(iris)

summary(Irisdata)

boxplot(Irisdata$Sepal.Length,iris$Sepal.Width,iris$Petal.Length,iris$Petal.Width)

hist(Irisdata$Sepal.Length, main="Histogram of Sepal Length", xlab="Sepal Length", xlim=c(4,8), col="blue", freq=FALSE)

ggplot(Irisdata, aes(x=Sepal.Width, y=1:150, color=Species)) + geom_point() 

ggplot(Irisdata, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) + geom_point() + labs(title="Scatterplot", x="Sepal Length", y="Sepal Width")

ggplot(Irisdata, aes(x=Petal.Length, y=Petal.Width, color=Species)) + geom_point() + labs(title="Scatterplot", x="Petal Length", y="Petal Width") 

ggpairs(data=Irisdata,columns=2:5,title="Iris Flower Features",colour='Species')

pairs(Irisdata[,1:4], col=Irisdata$Species)

subset(Irisdata, Species == "setosa")
Irisdata[which(Irisdata$Species == 'setosa'),]
















