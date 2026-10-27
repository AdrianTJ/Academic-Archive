library(tidyverse)
library(rvest)

companies <- c('BA','DIS','FB')

PublicInfo <- function(companies){
  
  Finanzas <- function(Stock){
    site <- paste("https://finance.yahoo.com/quote/",Stock,sep = "")
    site <- paste(site,"/key-statistics?p=",sep="")
    site <- paste(site,Stock,sep="")
    finances <- site %>% 
      read_html() %>% 
      html_table(header = FALSE) %>% 
      map_df(bind_cols) %>% 
      as_tibble()
    return(finances)
  }
  
  Companias <- companies
  
  Tabla <- lapply(Companias,Finanzas)
  
  MarketCap <- NULL
  EV <- NULL
  EVRev <- NULL
  EVOverEBIDTA <- NULL
  Revenue <- NULL
  RoE <- NULL
  
  for(i in 1:length(Companias)){
    MarketCap[i] <- Tabla[[i]]$X2[1]
    EV[i] <- Tabla[[i]]$X2[2]
    EVRev[i] <- Tabla[[i]]$X2[8]
    EVOverEBIDTA[i] <- Tabla[[i]]$X2[9]
    Revenue[i] <- Tabla[[i]]$X2[44]
    RoE[i] <- Tabla[[i]]$X2[43]
  }
  
  Resultados <- data.frame(Companias,EV,MarketCap,EVRev,EVOverEBIDTA,Revenue,RoE)
  colnames(Resultados) <- c('Quote','Enterprise Value','Market Cap','EV / Revenue','EV / EBITDA','Revenue (ttm)','Return on Equity (ttm)')
  return(Resultados)
}

PI <- PublicInfo(companies)

# write.csv(PI, file = "PublicInfo.csv")
