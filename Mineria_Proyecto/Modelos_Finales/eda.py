# -*- coding: utf-8 -*-
# ## Archivo auxiliar para guardar parámetros y funciones, de tal forma que el jupyter sea más legible.

import numpy as np
import pandas as pd

# ######### Variables y parametros

## Durante el EDA se detecto que estos 3 renglones traian informacion incorrecta en movies_metadata.
## Derivado de ello, preferimos quitarlas del analisis. Posteriormente tambien se observo que los renglones
## precedentes a cada uno de estos 3 detectados tambien tenian informacion incorrecta/incompleta.
rows_to_remove = [19730, 19731, 29503, 29504, 35587, 35588]


# ######### Funciones 

def turn_col_to_df(df, idx, col):
    """
        Crea un DataFrame dado un elemento en forma de json i.e.

         [
          {'llave1': elem1_1, 'llave2': elem2_1, ...},
          {'llave1': elem1_2, 'llave2': elem2_2, ...},
          {'llave1': elem1_3, 'llave2': elem2_3, ...}, 
          ...
         ]

        Como estos elementos existen dentro de las celdas de varios DataFrame que ocuparemos,
        nos interesa llamarlos por indice y columna.

        Es posible que no haya valores en ciertas celdas (string vacio), por lo que agregamos
        el try except para estos casos.

        Inputs:
            df: pd.DataFrame
                DataFrame que contiene la columna que se quiere procesar.
            idx: Int
                Posicion del valor dentro del DataFrame original.
            col: String
                Identificador de la columna.
         
        Outputs:
            pd.DataFrame con los valores del json.
    """
    try:
        # print('Exito')
        # print(pd.DataFrame.from_records(eval(df[col].iloc[idx])).assign(parent_id = idx+2).head(5)[['character', 'parent_id']])
        return pd.DataFrame.from_records(eval(df[col].iloc[idx])).assign(parent_id = idx)
        
    except TypeError:
        print('\n\n!!!!!!!!!!!!!!!!!!!!!!!!Fracaso!!!!!!!!!!!!!!!!!!!!!!!!\n\n')
        print(idx)
        return None


def concat_df(df, col, new_df_path):
    """
        Crea un DataFrame a partir de la concatenacion de los DataFrames generados en la funcion
        turn_col_to_df.

        Inputs:
            df: pd.DataFrame
                DataFrame que contiene la columna que se quiere procesar.
            col: String
                Identificador de la columna.
            new_df_path:
                Nombre completo de la ruta (incluyendo nombre del archivo) en que se guardaran los datos.
        Outputs:
            pd.DataFrame con los valores de todos los json.
    """
    try:
        new_df = pd.read_csv(new_df_path, index_col = 0)
    except FileNotFoundError:
        K = df.shape[0]
        new_df = [turn_col_to_df(df, idx, col) for idx in range(K)]
        new_df = [e for e in new_df if e is not None] # Algunos registros contienen strings vacios, los quitamos
        new_df = pd.concat(new_df).reset_index(drop=True)
        new_df.to_csv(new_df_path)
        new_df = pd.read_csv(new_df_path, index_col = 0)
    
    return new_df

def concat_df_test(df, col):
    """
        Crea un DataFrame a partir de la concatenacion de los DataFrames generados en la funcion
        turn_col_to_df. La diferencia con la que no es test, es que esta funcion NO guarda csv ni
        trata de leerlo.

        Inputs:
            df: pd.DataFrame
                DataFrame que contiene la columna que se quiere procesar.
            col: String
                Identificador de la columna.
        
        Outputs:
            pd.DataFrame con los valores de todos los json.
    """

    K = df.shape[0]
    new_df = [turn_col_to_df(df, idx, col) for idx in range(K)]
    new_df = [e for e in new_df if e is not None] # Algunos registros contienen strings vacios, los quitamos
    new_df = pd.concat(new_df).reset_index(drop=True)
    
    return new_df

def date_to_none(x):
    """
        Auxiliar dado el Issue relativo a los renglones faltantes en movies_metadata. Devuelve x si el valor
        se puede castear como entero, y -1 si no. En su momento, sirvio para determinar la variable rows_to_remove.
    """
    try:
        return int(x)
    except ValueError:
        return -1

# def remove_rows(df, df_path):
#     """
#         Le quitamos ciertas filas a los archivos, determinadas por la variable rows_to_remove en este script,
#         ya que traian informacion incorrecta, y los guardamos como csv.

#         Inputs:
#             df: pd.DataFrame
#                 DataFrame original
#         Outputs:
#             pd.DataFrame sin las filas.
#     """
#     new_df = df.drop(rows_to_remove)
#     new_df.to_csv(df_path)

#     return new_df

