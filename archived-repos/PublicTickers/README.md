# PublicTickers

R Code that generates a CSV of relevant company data, all taken from Yahoo! Finance. The required libraries to run this R 
script are tidyverse and Rvest, both available using install.packages() tool. 

In the base example, three companies' tickers are used, these being the tickers in the comapnies vector: 
* The Boeing Company (BA)
* The Walt Disney Company (DIS)
* Facebook, Inc. (FB)

The variables extracted from the Yahoo! Finance site are: 
* Market Cap
* Enterprise Value
* EV / Revenue
* EV / EBIDTA
* Revenue (ttm)
* Return on Investment (ttm). 

These can be changed, or if some other indicators are of interest, added in the for loop on line 31. 
