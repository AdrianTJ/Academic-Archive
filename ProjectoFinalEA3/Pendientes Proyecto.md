# Cosas que hacer del proyecto EA3 

## General

* Quitar la columna de valores asociados a **key**, no sirven de nada
* Hacer otro DF con toda la informacion relevante 
	* Fechas en formato nuevo (ya las tengo)
	* Distancias en formato nuevo
	* Pasajeros en original 
* Ver como le vamos a hacer para calcular el tiempo que pasa una persona en el Taxi 
* Generar nuevas variables para los años dependiendo de la tarifa que se calcula (Por ejemplo, si hay una tarifa especifica de 2010-2014, usar esa para todos los años en ese rango, otra para 2014-2017, etc)

## Información

* Encontrar las tarifas de taxi historicas de NY 
* Coordenadas en donde se encuentra el aeropuerto porque tiene un precio fijo viajar a (y desde?) el
* Checar el precio de viajar del aeropuerto a algun lugar en Manhattan
* Checar que pasa con la tasa fija si se va a un lugar distinto que Manhattan
* Ver como hacerle para checar que el lugar de arrivo esta fuera de Manhattan

## Distancias
* Quitar los valores de cero en donde no se registro informacion del viaje de coordenadas
* Ver que norma vamos a usar para calcular distancia (paquete geospere me funciono para extraer la informacion y tiene varias opciones)

## Mapas

* Hacer un mapa con todos los puntos de pickup
* Hacer un mapa con todos los puntos de dropoff

## Modelo Predicitivo
* Ya con el data frame nuevo y los valores de los viajes, calcular el costo de un viaje 
* Probablemente con Machine Learning (paquete caret)
* Modelo de regresion lineal? 

## Estadistica

* Ya con el nuevo DF, hacer estadistica sobre el, por ejemplo, componentes principales y covarianzas de las variables
* medias, varianzas, pruebas de hipotesis, etc 
* Histogramas 
* No se, cosas de estadistica