distOrigen <- function(x=0,y=0,plot=FALSE,locate=TRUE) {
    r <- sqrt(x^2+y^2)
    if(plot) {
      n <- 101
      xx <- seq(-r,r,length=n)
      plot(0,0, xlim=c(-r,r), ylim = c(-r,r), type = "n", pty="s", 
           xlab="x", ylab="y")
      lines(xx,yy<-sqrt(r^2-xx^2))
      lines(xx,-yy)
      if(locate) {
        points(c(0,x),c(0,y),pch=c(3,21))
        arrows(0,0,x,y)
      }
    }
    invisible(c(x=x,y=y,R=r))
}

# Ejemplos en el uso de distOrigen
# Note el efecto de invisible al regresar la función 
(distOrigen())
tt <- distOrigen()
print(tt)


distOrigen(-1,-1,plot=TRUE)
print(distOrigen(1,+2,plot=TRUE))
print(distOrigen(-10,+3,plot=TRUE,locate=FALSE))
