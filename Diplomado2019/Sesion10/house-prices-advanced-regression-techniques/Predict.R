#Predict Future Sales: https://www.kaggle.com/c/competitive-data-science-predict-future-sales/data

Train <- read.csv('./train.csv')

ModeloLineal <- lm(SalePrice ~ LotArea + Street , data = Train)

summary(ModeloLineal)

