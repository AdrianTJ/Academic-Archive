import numpy as np
import numpy.linalg as ln
import scipy as sp
import scipy.optimize
import pandas as pd
from pytest import approx
###IMPORTACION MODULO función BFGS
from funciones_algoritmo_bfgs import bfgs


###Carga de datos
datos = pd.read_csv("./Datos/Stroke_Data.csv")

# Cambiamos los datos a un array de numpy pata poder trabajar con ellos.
datos_array = np.asarray(datos)

# Tomamos la variable objetivo, en este caso, esta es `stroke`
y = datos_array[:, 0].astype('float64')

# Tomamos el resto de las variables como variables explicativas, y agregamos un
# intercepto
X = np.asarray(datos_array[:, 1:]).astype('float64')
intercept = np.ones(X.shape[0]).reshape(X.shape[0], 1)
X = np.concatenate((intercept, X), axis = 1)

# Función de costo
def cost(beta, X=X, y=y):
    # Por simplicidad resumimos los términos
    h = np.exp(np.dot(X, beta))
    log_h = np.log(1.0 + h)

    # Regresamos la función de costo según la definimos arriba
    return np.sum(-y*np.dot(X, beta) + y*log_h + (1-y)*log_h)

# Función logit
def logit(X, beta):
    return 1/(1.0 + np.exp(-np.dot(X, beta)))

# Función de score
def score(beta, X=X, y=y):
    return np.dot(X.T, logit(X, beta) - y)


# Optimización con BFGS implementado manualmente
result, _ = bfgs(f = cost,
                 gradiente = score ,
                 x_init = np.ones(10)*0.5)

# Optimización con BFGS a través de scipy
sol_scipy_bfgs = sp.optimize.minimize(fun = cost,
                                      x0 = np.ones(10)*0.5,
                                      method = 'BFGS',
                                      args = (X,y),
                                      jac = score)


def test(scipy_bfgs, nuestro_bfgs):
    assert scipy_bfgs == approx(nuestro_bfgs, rel=1e-6) #

test(sol_scipy_bfgs.x, result)
