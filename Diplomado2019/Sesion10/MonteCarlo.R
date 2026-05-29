# Simulacion Monte Carlo 
library(tidyverse)

# We know that the math constant $\pi$ can be approximated by 4 times of the number of 
# points inside a 1/4 circle divided by the total number of points




# both x and y contains now 100 random numbers
x <- runif(100)
y <- runif(100)

# Distance from center
z=sqrt(x^2+y^2)

# Count how many of the distances in z vector are smaller than 1 (falling inside the 1/4 circle)
which(z<1)
length(which(z<=1))*4/length(z)


# Grafiquemos
plot(x[which(z<=1)],y[which(z<=1)],xlab="X",ylab="Y",main="Monte Carlo")
points(x[which(z>1)],y[which(z>1)],col='blue')









runs <- 100000
#runif samples from a uniform distribution
xs <- runif(runs,min=-0.5,max=0.5)
ys <- runif(runs,min=-0.5,max=0.5)
in.circle <- xs^2 + ys^2 <= 0.5^2
mc.pi <- (sum(in.circle)/runs)*4
plot(xs,ys,pch='.',col=ifelse(in.circle,"blue","grey")
     ,xlab='',ylab='',asp=1,
     main=paste("MC Approximation of Pi =",mc.pi))








promedios = NULL

randints = function(num) {
  sample(c(-1, 1), num, replace = TRUE,prob = c(.5,.5))
}

df1 = data.frame(cs = cumsum(randints(100)), t = 1:100)
ggplot() + geom_line(data = df1, aes(t, cs), alpha = 0.8)

gamble_plot = function(nruns){
  for(i in 1:nruns){
    df = data.frame(cs=cumsum(randints(100)), t=1:100)
    promedios[i] = df$cs[100]
  }
  return(promedios)
}

Promedios <- gamble_plot(365)
mean(Promedios)



gamble_plot = function(nruns, len){
  p = ggplot()  
  for(i in 1:nruns){
    color = "darkgreen"
    df = data.frame(cs=cumsum(randints(len)), t=1:len)
    if(select(df, cs)[len,] < 0) color = "darkorange"
    p = p + geom_line(data=df, aes(t,cs), alpha=0.4, color=color)
  }
  p
}

gamble_plot(300, 200)




