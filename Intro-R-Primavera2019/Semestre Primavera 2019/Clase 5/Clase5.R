movies <- read.csv(
  "~/Proyects/Intro-R-Primavera2019/Semestre Primavera 2019/Clase 5/movies_metadata.csv",
  quote="\"",
  stringsAsFactors = F,
  as.is = T,
  fileEncoding = "UTF-8")

movies.df <- movies[,-c(2,4,5,6,7,10,12,13,14,18,19,20,22)]

# movies.adult <- movies.df[which(movies.df$adult == "True"),]


