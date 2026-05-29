# Sesion 8

install.packages('yarrr')
library(yarrr)


# Exam data
exam <- data.frame(
  id = 1:5,
  q1 = c(1, 5, 2, 3, 2),
  q2 = c(8, 10, 9, 8, 7),
  q3 = c(3, 7, 4, 6, 4))

# Demographic data
demographics <- data.frame(
  id = 1:5,
  sex = c("f", "m", "f", "f", "m"),
  age = c(25, 22, 24, 19, 23))

combined <- merge(x = exam, 
                  y = demographics, 
                  by = "id")

str(combined)

aggregate(formula = q1 ~ sex, 
          data = combined, 
          FUN = mean)

aggregate(formula = q3 ~ sex, 
          data = combined,
          subset = age > 20,
          FUN = mean)

colMeans(combined[,2:4])

combined <- combined[order(combined$age),]

combined <- combined[order(combined$age, decreasing = TRUE),]

movies <- read.csv(file = './movies.csv')

str(movies)

summary(movies)

with(movies, tapply(X = time,        # DV is time
                    INDEX = genre,   # IV is genre
                    FUN = mean,      # function is mean
                    na.rm = TRUE))   # Ignore missing

tapply(movies$time, movies$genre, mean, na.rm = TRUE)

hist(movies$time,breaks = 20)







