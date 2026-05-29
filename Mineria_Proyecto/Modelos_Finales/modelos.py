import numpy as np
import pandas as pd 
import math
import matplotlib.pyplot as plt
from scipy.stats import binom

def plot_cluster_info(clusters, cluster, meta_cat, genres_cat, languages_cat):
    """
    Plot the center of each cluster.
    """
    fig, axs = plt.subplots(1,3, figsize = (16,6))
    plt.subplots_adjust(wspace = 0.5)

    plt.sca(axs[0]); ax = plt.gca()
    ax.barh(meta_cat, clusters.iloc[cluster][meta_cat])
    ax.tick_params(labelsize = 12); ax.set_title('General'); ax.set_xlim(0,1.1)

    plt.sca(axs[1]); ax = plt.gca()
    ax.barh(genres_cat, clusters.iloc[cluster][genres_cat])
    ax.tick_params(labelsize = 12); ax.set_title('Genres'); ax.set_xlim(0,1.1)

    plt.sca(axs[2]); ax = plt.gca()
    ax.barh(languages_cat, clusters.iloc[cluster][languages_cat])
    ax.tick_params(labelsize = 12); ax.set_title('Languages'); ax.set_xlim(0,1.1)

    plt.suptitle(f'Cluster {cluster}', fontsize = 14)
    
def plot_movie_info(data, movie_name, meta_cat, genres_cat, languages_cat):
    """
    Plot info of a movie.
    """
    ### iloc[0] sirve para convertirlo a Series. En general no afecta excepto cuando hay nombres
    ### repetidos, pero no debería de ser el caso si estamos seleccionando a mano las películas
    movie = data[data['original_title'] == movie_name].iloc[0]
    
    fig, axs = plt.subplots(1,3, figsize = (16,6))
    plt.subplots_adjust(wspace = 0.5)

    plt.sca(axs[0]); ax = plt.gca()
    ax.barh(meta_cat, movie[meta_cat])
    ax.tick_params(labelsize = 12); ax.set_title('General'); ax.set_xlim(0,1.1)

    plt.sca(axs[1]); ax = plt.gca()
    ax.barh(genres_cat, movie[genres_cat])
    ax.tick_params(labelsize = 12); ax.set_title('Genres'); ax.set_xlim(0,1.1)

    plt.sca(axs[2]); ax = plt.gca()
    ax.barh(languages_cat, movie[languages_cat])
    ax.tick_params(labelsize = 12); ax.set_title('Languages'); ax.set_xlim(0,1.1)

    plt.suptitle(f'{movie_name}', fontsize = 14)
    
def mas_cercanas_a_pelicula(movie_clusters, idx, n):
    
    """
    Calculamos las n peliculas mas cercanas dada una pelicula. Solo se calculan las distancias
    entre las peliculas del mismo cluster.
    
        movie_clusters : DataFrame
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula
        n : Int, numero de peliculas mas cercanas que se regresan
    """
    
    ### Guardamos el renglon con la pelicula que queremos comparar vs las demas
    aux = movie_clusters.loc[idx].drop(['original_title', 'cluster'])

    ### El siguiente df recupera todas las peliculas en el mismo cluster que la pelicula seleccionada
    movie_aux = movie_clusters.copy()
    movie_aux = movie_aux[movie_aux['cluster'] == movie_aux.loc[idx]['cluster']]
    movie_aux = movie_aux.drop(['original_title', 'cluster'], 1)

    ### Calculamos distancia euclidiana entre la pelicula y las de su cluster
    movie_aux['dist'] = movie_aux.apply(lambda x : np.sqrt(np.sum((x-np.array(aux))**2)), 1)

    ### Agregamos el nombre
    movie_aux = pd.DataFrame(movie_clusters['original_title']).join(movie_aux, how = 'inner')

    ### La primera es la misma, entonces se va
    movie_aux = movie_aux.sort_values('dist').iloc[1:]

    ### Finalmente, recuperamos las n mas cercanas
    return movie_aux.head(n)

def mezcla_mas_cercanas_a_pelicula(all_movie_clusters, idx, n):

    """
    Calculamos las n_k peliculas mas cercanas dada una pelicula en cada modelo. Solo se calculan las distancias
    entre las peliculas del mismo cluster.
    
        all_movie_clusters : List of DataFrame
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula
        n : List of Int, numero de peliculas mas cercanas que se regresan por cada modelo
    """

    ## Incicializamos para facilitar obtener el DF
    todas_las_mas_cercanas = 0

    for movie_clusters_k, n_k in zip(all_movie_clusters, n):     
        
        # Aplicamos la función de mas_cercanas_a_pelicula a cada cluster
        df = mas_cercanas_a_pelicula(movie_clusters_k, idx, n_k)
        
        # Vamos guardando todo en un DF
        if not isinstance(todas_las_mas_cercanas, pd.DataFrame):
            todas_las_mas_cercanas = df
        else:
            todas_las_mas_cercanas = pd.concat([todas_las_mas_cercanas, df])

    # Quitamos los valores repetidos (que habrán varios por la naturaleza de los clusters)
    return todas_las_mas_cercanas.drop_duplicates()


def aleatorias_en_cluster(movie_clusters, idx, n):
    
    """
    Calculamos n peliculas aleatorias dentro del mismo cluster.
    
        movie_clusters : DataFrame
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula
        n : Int, numero de peliculas mas cercanas que se regresan
    """
    
    ### El siguiente df recupera todas las peliculas en el mismo cluster que la pelicula seleccionada
    movies_aux = movie_clusters.copy()[movie_clusters['cluster'] == movie_clusters.loc[idx]['cluster']]
    movies_aux = movies_aux.drop(idx)

    ### Regresa una muestra de tamaño n
    return movies_aux.sample(n)

def recomendadas_por_actores(idx, credits_cast, score_actor, movies_metadata, N = 5, M = 10, factor_proba = 0.5, maximo_actores = 4):

    """
    Obtenemos las peliculas que tengan a los mismos actores, si es que estos son importantes de
    acuerdo a la métrica establecida (order_metric2).
            
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula
        credits_cast : DataFrame, definido en el notebook
        score_actor : DataFrame, definido en el notebook
        N = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por actor
        M = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el actor. Nota: M > N
        factor_proba = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba
        maximo_actores = Int, determina la (máxima) cantidad de actores para los cuales se realizará el proceso
    """
    ## Obtenemos los índices de los actores en la determinada película
    actors_indexes = list(credits_cast.set_index('id_credits').loc[idx].sort_values(by = 'order_metric2', ascending = False)['id'])

    ## Auxiliar para inicializar el DF
    recomendadas_por_actores = 0

    for actor_idx in actors_indexes[:maximo_actores]:
        # Obtenemos la proba (score) del actor
        prob = score_actor[score_actor['id'] == actor_idx]['prob'].iloc[0] 
        
        # Obtenemos la cantidad k de películas por actor aleatoriamente (a lo más N)
        k_por_actor = binom.rvs(N, prob*factor_proba)

        # Al menos nos gustaría incluir una película por cada actor
        k_por_actor = max(1, k_por_actor)

        # Obtenemos películas con el mismo actor (quitando la misma película), y nos quedamos con el top M
        # de acuerdo a que tan importante fue el actor en esa película particular (order_metric2)
        top_M_por_actor = credits_cast[credits_cast['id'] == actor_idx].set_index('id_credits').drop(idx).sort_values(by = 'order_metric2', ascending=False).iloc[:M]
        
        # return top_M_por_actor.sample(k_por_actor, replace = True).drop_duplicates()
        # De las m <= M (porque puede que el actor no tenga M otras películas) seleccionadas,
        # obtenemos las k (con reemplazo porque si k > m truena) y quitamos los duplicados

        ### No obstante, en algún punto nos topamos con un error: Si el actor no ha salido mas que en una película, el df top_M_por_actor
        ### será vacío y lo siguiente tronará. Por ello, lo metemos en un try except
        try:
            recomendadas_por_actor = top_M_por_actor.sample(k_por_actor, replace = True).drop_duplicates()
            
            # Vamos guardando todo en un DF
            if not isinstance(recomendadas_por_actores, pd.DataFrame):
                recomendadas_por_actores = recomendadas_por_actor
            else:
                recomendadas_por_actores = pd.concat([recomendadas_por_actores, recomendadas_por_actor])
        except ValueError:
            pass

    ## Finalmente, unimos con el df de películas y obtenemos los títulos     
    return movies_metadata.join(recomendadas_por_actores[['name']], on = "id", how = 'inner')[['original_title', 'name']].sort_values(by='name')

def recomendadas_por_director(idx, credits_crew, score_director, movies_metadata, N = 7, M = 14, factor_proba = 0.9):

    """
    Obtenemos las peliculas que tengan al mismo director.
            
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula
        credits_cast : DataFrame, definido en el notebook
        score_actor : DataFrame, definido en el notebook
        N = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por director
        M = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el director. Nota: M > N
        factor_proba = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba
    """

    ## Como solo nos interesan los renglones donde el director en efecto fungió como director
    ## (pues también pudo ser escritor, productor, etc.), filtramos de entrada estos renglones
    aux = credits_crew[credits_crew['job'] == 'Director']

    ## Obtenemos los índices de los actores en la determinada película
    director_idx = aux.set_index('id_credits').loc[idx]['id']

    # Obtenemos la proba (score) del director
    prob = score_director[score_director['id'] == director_idx]['prob'].iloc[0] 

    # Obtenemos la cantidad k de películas por director aleatoriamente (a lo más N)
    k_por_director = binom.rvs(N, prob*factor_proba)

    # Obtenemos películas con el mismo director (quitando la misma película), y nos quedamos con el top M
    top_M_por_director = aux[aux['id'] == director_idx].set_index('id_credits').drop(idx).iloc[:M]

    # De las m <= M (porque puede que el director no tenga M otras películas) seleccionadas,
    # obtenemos las k (con reemplazo porque si k > m truena) y quitamos los duplicados
    recomendadas_por_director = top_M_por_director.sample(k_por_director, replace = True).drop_duplicates()

    ## Finalmente, unimos con el df de películas y obtenemos los títulos     
    return movies_metadata.join(recomendadas_por_director[['name']], on = "id", how = 'inner')[['original_title', 'name']].sort_values(by='name')

def recomendacion_por_overview(overview, idx, indices, cosine_sim, n = 10, ):

    """
    Recomendamos películas basandonos en aquellas cuyas palabras en el overview son similares entre sí.
            
        overview : pd.DataFrame
        idx : Int, valor del índice de la película
        indices : pd.Series, es auxiliar para mapear entre los índices de las bases que tenemos y los de cosine_sim
        cosine_sim : np.array, matriz de nxn que contiene la similitudes entre películas
        n : Int, cantidad de películas que regresa el modelo    
    """
    
    # Obtenemos el índice mapeado de de la película
    cosine_idx = indices[idx]

    # Obtenemos las puntuaciones de similitud por pares de todas las películas con esa película
    # Se hace por tupla, el primer elemento corresponde al índice de la película, el segundo a su similitud
    sim_scores = list(enumerate(cosine_sim[cosine_idx]))

    # Ordenamos según su similitud
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

    # Obtenemos los n más similares (omitiendo la película misma)
    sim_scores = sim_scores[1:n]

    # Obtenemos los índices mapeados de vuelta
    movie_indices = [i[0] for i in sim_scores]

    # Regresamos las películas más similares
    return overview.set_index('id', drop = True).iloc[movie_indices]

def recomendacion_por_conjunto_actores(df, idx, indices, cosine_sim, credits, credits_cast, conjunto_actores_id, n_0 = 15000, n_f = 20, c = 0.05):

    """
    Recomendamos películas basandonos en aquellas cuyos actores hayan salido en conjunto.
            
        df : pd.DataFrame
        idx : Int, valor del índice de la película
        indices : pd.Series, es auxiliar para mapear entre los índices de las bases que tenemos y los de cosine_sim
        cosine_sim : np.array, matriz de nxn que contiene la similitudes entre películas
        credits : pd.DataFrame
        credits_cast : pd.DataFrame
        conjunto_actores_id : pd.Series, contiene el set de los actores (por id) por película
        c : Float, cantidad entre 0 y 1, generalmente con valores pequeños, con el cual se hace un corte al final y se regresan
                solo las películas con valor |interseccion|/|union| > c. Se puede ocupar 0 si se quieren las posibles n_f.
        n_0 : Int, cantidad de películas que se exploran inicialmente en el modelo de tf_idf . Si bien 15,000 de default es alto
                y puede alentar un poco, se eligió porque particularmente con Transformers era la que recuperaba las demás. 
        n_f : Int, cantidad de películas máximo que regresa el modelo 
                (puede regresar menos si se quitaron muchas en algunos pasos)
        
    """
    
    # Obtenemos el índice mapeado de de la película
    cosine_idx = indices[idx]

    # Obtenemos las puntuaciones de similitud por pares de todas las películas con esa película
    # Se hace por tupla, el primer elemento corresponde al índice de la película, el segundo a su similitud
    sim_scores = list(enumerate(cosine_sim[cosine_idx]))

    # Ordenamos según su similitud
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    # sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=False)


    # Obtenemos los n más similares (omitiendo la película misma)
    sim_scores = sim_scores[1:n_0]

    # Obtenemos los índices mapeados de vuelta
    movie_indices = [i[0] for i in sim_scores]

    # Regresamos las películas más similares únicamente con base en lo implementado de linear_kernel, que es
    # tomar el producto punto de la matriz con 0 si el actor k no aparece y 1 si sí.
    temp = df.set_index('id', drop = True).iloc[movie_indices]


    ### Hicimos pruebas con lo obtenido en el renglón anterior, y si bien hay algunos resultados buenos,
    ### notamos algunas mejoras que se podían implementar. En las siguientes lineas se detalla esto.

    idx2keep = [] # Auxiliar para guardar los índices que se quedan
    idx2drop = [] # Auxiliar para guardar los índices que se van

    ### En este primer paso, quitamos aquellas películas sin actores (el 5 es tomando en cuenta la longitud de "[]",
    ### que son justo los registros sin cast)
    temp1 = credits.set_index('id').loc[temp.index]

    idx2keep = idx2keep + list(temp1[temp1['cast'].apply(lambda x : len(x) >= 5)].index)
    idx2drop = idx2drop + list(temp1[temp1['cast'].apply(lambda x : len(x) < 5)].index)

    ### En este segundo paso, quitamos aquellas películas con menos de 5 actores
    temp2 = credits_cast.set_index('id_credits').loc[idx2keep].reset_index().groupby('id_credits').count()['id']

    idx2keep = idx2keep + list(temp2[temp2 >= 5].index)
    idx2drop = idx2drop + list(temp2[temp2 < 5].index)

    ### En este tercer paso, ordenamos con la métrica de cardinalidad de intersección sobre cardinalidad de union
    temp3 = temp.drop(idx2drop)

    calibracion_inter_union = {key: metrica_inter_union(conjunto_actores_id.loc[idx], conjunto_actores_id.loc[key])
                            for key in temp3.index}
    calibracion_inter_union = pd.Series(calibracion_inter_union)
    calibracion_inter_union = calibracion_inter_union.sort_values(ascending = False)
    calibracion_inter_union.name = '|interseccion|/|union|'

    ### Regresamos valores ordenados, cortando en el valor c de la métrica |interseccion|/|union|
    temp4 =  pd.concat([temp.loc[calibracion_inter_union.index], calibracion_inter_union], 1).head(n_f)
    
    ### Como paso final, hay veces en las que se regresa la misma película. La quitamos si pasa
    if idx in temp4.index:
        temp4.drop(idx, inplace = True)

    return temp4[temp4['|interseccion|/|union|'] > c]

def pop_in_cluster(idx, clusters, pop_metric, n = 10):

    """
    Recomendamos películas basandonos las más populares dentro del cluster.
            
        idx : Int, valor del índice de la película
        clusters : pd.DataFrame
        pop_metric : pd.DataFrame
        n : Int, número de películas que se recomiendan
        
    """
    aux = clusters.loc[idx]['cluster']
    aux = clusters[clusters['cluster'] == aux][['original_title']]
    aux =  pop_metric.join(aux, on = 'id', rsuffix = '_').dropna().sort_values(
            by = 'pop_metric', ascending = False)[['pop_metric','original_title']].head(n)
    if idx in aux.index:
        aux.drop(idx, inplace = True)
    
    return aux

def mezcla_modelos(idx, p, movie_clusters, n, credits_cast, score_actor, movies_metadata, N_ac, M_ac, factor_proba_ac, maximo_actores):

    """
    Se llaman a los modelos ya definidos y se mezclan con un vector de probabilidades
            
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula
        p : 

        Para K-Means
            movie_clusters : DataFrame
            n : Int, numero de peliculas mas cercanas que se regresan

        Para actores
            credits_cast : DataFrame, definido en el notebook
            score_actor : DataFrame, definido en el notebook
            N_ac = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por actor
            M_ac = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el actor. Nota: M > N
            factor_proba_ac = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba
            maximo_actores = Int, determina la (máxima) cantidad de actores para los cuales se realizará el proceso
    """

    modelos = {
           'k-means': {
                       'funcion': mas_cercanas_a_pelicula(movie_clusters, idx, n)['original_title'],
                       'p_k': p['k-means']
                      },
                       
                       
           'actores': {
                       'funcion': recomendadas_por_actores(idx, credits_cast, score_actor, movies_metadata,
                                                           N_ac, M_ac, factor_proba_ac , maximo_actores)['original_title'],
                       'p_k': p['actores']
                      },                       
          }

    return pd.concat([modelos[key]['funcion'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])

def modelo_final(idx, p, 
                 movie_clusters_1, n_1, # K-Means 1
                 movie_clusters_2, n_2, # K-Means 2
                 movie_clusters_3, n_3, # K-Means 3
                 movie_clusters_h, n_h, # Hierarchical Clustering
                 credits_cast, score_actor, movies_metadata, N_ac, M_ac, factor_proba_ac, maximo_actores, # Actores
                 credits_crew, score_director, N_dir, M_dir, factor_proba_dir, # Director
                 overview, indices, cosine_sim, n_ov, # Overview
                 identificar_modelo = True,
                 ):

    """
    Se llaman a los modelos ya definidos y se mezclan con un vector de probabilidades
            
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula.
        p : Dict, contiene las probabilidades de cada modelo.
        identificar_modelo : Bool, si es True, también regresa cual fue el modelo para tal película.

        Para K-Means 
            Para cada uno de los diferentes modelos de K-Means:
                movie_clusters_k : DataFrame
                n_k : Int, numero de peliculas mas cercanas que se regresan

        Para Hierarchical Clustering
            movie_clusters_h : DataFrame
            n_h : Int, numero de peliculas mas cercanas que se regresan

        Para actores
            credits_cast : DataFrame, definido en el notebook
            score_actor : DataFrame, definido en el notebook
            N_ac = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por actor
            M_ac = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el actor. Nota: M > N
            factor_proba_ac = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba
            maximo_actores = Int, determina la (máxima) cantidad de actores para los cuales se realizará el proceso

        Para director
            credits_crew : DataFrame, definido en el notebook
            score_director : DataFrame, definido en el notebook
            N_dir = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por director
            M_dir = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el director. Nota: M > N
            factor_proba_dir = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba

        Para overview
            overview : DataFrame, definido en el notebook
            indices : pd.Series, es auxiliar para mapear entre los índices de las bases que tenemos y los de cosine_sim
            cosine_sim : np.array, matriz de nxn que contiene la similitudes entre películas
            n_ov : Int, cantidad de películas que regresa el modelo    
    """

    modelos = {
        'k-means_1': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_1, idx, n_1),'k-means_1')[['original_title', 'model']],
                    'p_k': p['k-means_1']
                    },
        'k-means_2': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_2, idx, n_2),'k-means_2')[['original_title', 'model']],
                    'p_k': p['k-means_2']
                    },
        'k-means_3': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_3, idx, n_3),'k-means_3')[['original_title', 'model']],
                    'p_k': p['k-means_3']
                    },

        'hierarchical': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_h, idx, n_h),'hierarchical')[['original_title', 'model']],
                    'p_k': p['hierarchical']
                    },
                                            
        'actores': {
                    'funcion': add_model(recomendadas_por_actores(idx, credits_cast, score_actor, movies_metadata,
                                                        N_ac, M_ac, factor_proba_ac , maximo_actores),'actores')[['original_title', 'model']],
                    'p_k': p['actores']
                    }, 
        'director': {
                    'funcion': add_model(recomendadas_por_director(idx, credits_crew, score_director, movies_metadata, 
                                                         N_dir, M_dir, factor_proba_dir),'director')[['original_title', 'model']],
                    'p_k': p['director']
                    },  
        'overview': {
                    'funcion': add_model(recomendacion_por_overview(overview, idx, indices, cosine_sim, n_ov ),'overview')[['original_title', 'model']],
                    'p_k': p['overview']
                    },                   
        }

    if identificar_modelo:
        return pd.concat([modelos[key]['funcion'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])
    else:
        return pd.concat([modelos[key]['funcion']['original_title'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])

def modelo_final_v2(idx, p, 
                    movie_clusters_1, n_1, # K-Means 1
                    movie_clusters_2, n_2, # K-Means 2
                    movie_clusters_3, n_3, # K-Means 3
                    movie_clusters_h, n_h, # Hierarchical Clustering
                    credits_cast, score_actor, movies_metadata, N_ac, M_ac, factor_proba_ac, maximo_actores, # Actores
                    credits_crew, score_director, N_dir, M_dir, factor_proba_dir, # Director
                    conjunto_actores_df, indices_actores, cosine_sim_actores, conjunto_actores_id, credits, n_0, n_f, c , # Coocurrencia Actores
                    identificar_modelo = True,
                    sample = False,
                    ):

    """
    Se llaman a los modelos ya definidos y se mezclan con un vector de probabilidades.
    
    --- Diferencias con modelo_final --- 

    1. Se quitó el modelo de overview a favor de coocurrencia de actores.
    2. Se dio posibilidad de quitar aleatoriedad en los modelos (nótese que actores y director ya la traen implicita)
            
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula.
        p : Dict, contiene las probabilidades de cada modelo.

        identificar_modelo : Bool, si es True, también regresa cual fue el modelo para tal película.
        sample : Bool, si es True, sample una fracción p_k de los resultados de cada modelo. Si no, devuelve el top p_k

        Para K-Means 
            Para cada uno de los diferentes modelos de K-Means:
                movie_clusters_k : DataFrame
                n_k : Int, numero de peliculas mas cercanas que se regresan

        Para Hierarchical Clustering
            movie_clusters_h : DataFrame
            n_h : Int, numero de peliculas mas cercanas que se regresan

        Para actores
            credits_cast : DataFrame, definido en el notebook
            score_actor : DataFrame, definido en el notebook
            N_ac = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por actor
            M_ac = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el actor. Nota: M > N
            factor_proba_ac = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba
            maximo_actores = Int, determina la (máxima) cantidad de actores para los cuales se realizará el proceso

        Para director
            credits_crew : DataFrame, definido en el notebook
            score_director : DataFrame, definido en el notebook
            N_dir = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por director
            M_dir = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el director. Nota: M > N
            factor_proba_dir = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba

        Para Coocurrencia Actores
            conjunto_actores_df : pd.DataFrame
            indices_actores : pd.Series, es auxiliar para mapear entre los índices de las bases que tenemos y los de cosine_sim
            cosine_sim_actores : np.array, matriz de nxn que contiene la similitudes entre películas            
            conjunto_actores_id : pd.Series, contiene el set de los actores (por id) por película
            credits : pd.DataFrame
            c : Float, cantidad entre 0 y 1, generalmente con valores pequeños, con el cual se hace un corte al final y se regresan
                    solo las películas con valor |interseccion|/|union| > c. Se puede ocupar 0 si se quieren las posibles n_f.
            n_0 : Int, cantidad de películas que se exploran inicialmente en el modelo de tf_idf . Si bien 15,000 de default es alto
                    y puede alentar un poco, se eligió porque particularmente con Transformers era la que recuperaba las demás. 
            n_f : Int, cantidad de películas máximo que regresa el modelo 
                    (puede regresar menos si se quitaron muchas en algunos pasos)   
    """
    
    modelos = {
        'k-means_1': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_1, idx, n_1),'k-means_1', p)[['original_title', 'model']],
                    'p_k': p['k-means_1']
                    },
        'k-means_2': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_2, idx, n_2),'k-means_2', p)[['original_title', 'model']],
                    'p_k': p['k-means_2']
                    },
        'k-means_3': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_3, idx, n_3),'k-means_3', p)[['original_title', 'model']],
                    'p_k': p['k-means_3']
                    },

        'hierarchical': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_h, idx, n_h),'hierarchical', p)[['original_title', 'model']],
                    'p_k': p['hierarchical']
                    },
                                            
        'actores': {
                    'funcion': add_model(recomendadas_por_actores(idx, credits_cast, score_actor, movies_metadata,
                                                        N_ac, M_ac, factor_proba_ac , maximo_actores),'actores', p)[['original_title', 'model']],
                    'p_k': p['actores']
                    }, 
        'director': {
                    'funcion': add_model(recomendadas_por_director(idx, credits_crew, score_director, movies_metadata, 
                                                         N_dir, M_dir, factor_proba_dir),'director', p)[['original_title', 'model']],
                    'p_k': p['director']
                    },  
        'coocurrencia_actores': {
                    'funcion': add_model(recomendacion_por_conjunto_actores(conjunto_actores_df, idx, indices_actores, cosine_sim_actores, 
                                         credits, credits_cast, conjunto_actores_id, n_0, n_f, c),'coocurrencia_actores', p)[['original_title', 'model']],
                    'p_k': p['coocurrencia_actores']
                    },                   
        }

    if identificar_modelo:
        if sample:
            df =  pd.concat([modelos[key]['funcion'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])
        else:
            df =  pd.concat([modelos[key]['funcion'].iloc[:int(np.floor(modelos[key]['p_k']*len(modelos[key]['funcion'])))] for key in modelos.keys()])
    else:
        if sample:
            df =  pd.concat([modelos[key]['funcion']['original_title'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])
        else:
            df =  pd.concat([modelos[key]['funcion']['original_title'].iloc[:int(np.floor(modelos[key]['p_k']*len(modelos[key]['funcion'])))] for key in modelos.keys()])
    
    return df

def modelo_final_v3(idx, p, 
                    movie_clusters_1, n_1, # K-Means 1
                    movie_clusters_2, n_2, # K-Means 2
                    movie_clusters_3, n_3, # K-Means 3
                    movie_clusters_h, n_h, # Hierarchical Clustering
                    credits_cast, score_actor, movies_metadata, N_ac, M_ac, factor_proba_ac, maximo_actores, # Actores
                    credits_crew, score_director, N_dir, M_dir, factor_proba_dir, # Director
                    conjunto_actores_df, indices_actores, cosine_sim_actores, conjunto_actores_id, credits, n_0, n_f, c , # Coocurrencia Actores
                    overview, indices, cosine_sim, n_ov, # Overview
                    clusters, pop_metric, n_pop, # Pop Metric
                    identificar_modelo = True,
                    sample = False,
                    ):

    """
    Se llaman a los modelos ya definidos y se mezclan con un vector de probabilidades.
    
    --- Diferencias con modelo_final_v2 --- 

    1. Se agrega de nuevo overview, ya que es mejor tenerlo y en todo caso solo pasarle un 0 en el vector de probas.
            
        idx : Int, es el id (NO es la posicion en renglones) de la pelicula.
        p : Dict, contiene las probabilidades de cada modelo.

        identificar_modelo : Bool, si es True, también regresa cual fue el modelo para tal película.
        sample : Bool, si es True, sample una fracción p_k de los resultados de cada modelo. Si no, devuelve el top p_k

        Para K-Means 
            Para cada uno de los diferentes modelos de K-Means:
                movie_clusters_k : DataFrame
                n_k : Int, numero de peliculas mas cercanas que se regresan

        Para Hierarchical Clustering
            movie_clusters_h : DataFrame
            n_h : Int, numero de peliculas mas cercanas que se regresan

        Para actores
            credits_cast : DataFrame, definido en el notebook
            score_actor : DataFrame, definido en el notebook
            N_ac = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por actor
            M_ac = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el actor. Nota: M > N
            factor_proba_ac = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba
            maximo_actores = Int, determina la (máxima) cantidad de actores para los cuales se realizará el proceso

        Para director
            credits_crew : DataFrame, definido en el notebook
            score_director : DataFrame, definido en el notebook
            N_dir = Int, determina el parámetro n de Bin(n,p), que se usa para establecer la máxima cantidad de películas por director
            M_dir = Int, determina la máxima cantidad de películas elegibles de acuerdo a que tan importante fue el director. Nota: M > N
            factor_proba_dir = Float [0,1], es un factor ocupado para ajustar la probabilidad p de la Bin(n,p), tal que p = factor_proba * proba

        Para Coocurrencia Actores
            conjunto_actores_df : pd.DataFrame
            indices_actores : pd.Series, es auxiliar para mapear entre los índices de las bases que tenemos y los de cosine_sim
            cosine_sim_actores : np.array, matriz de nxn que contiene la similitudes entre películas            
            conjunto_actores_id : pd.Series, contiene el set de los actores (por id) por película
            credits : pd.DataFrame
            c : Float, cantidad entre 0 y 1, generalmente con valores pequeños, con el cual se hace un corte al final y se regresan
                    solo las películas con valor |interseccion|/|union| > c. Se puede ocupar 0 si se quieren las posibles n_f.
            n_0 : Int, cantidad de películas que se exploran inicialmente en el modelo de tf_idf . Si bien 15,000 de default es alto
                    y puede alentar un poco, se eligió porque particularmente con Transformers era la que recuperaba las demás. 
            n_f : Int, cantidad de películas máximo que regresa el modelo 
                    (puede regresar menos si se quitaron muchas en algunos pasos)
        
        Para overview
            overview : DataFrame, definido en el notebook
            indices : pd.Series, es auxiliar para mapear entre los índices de las bases que tenemos y los de cosine_sim
            cosine_sim : np.array, matriz de nxn que contiene la similitudes entre películas
            n_ov : Int, cantidad de películas que regresa el modelo

        Para popularidad
            clusters : pd.DataFrame
            pop_metric : pd.DataFrame
            n_pop : Int, número de películas que se recomiendan
    """
    
    modelos = {
        'k-means_1': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_1, idx, n_1),'k-means_1', p)[['original_title', 'model']],
                    'p_k': p['k-means_1']
                    },
        'k-means_2': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_2, idx, n_2),'k-means_2', p)[['original_title', 'model']],
                    'p_k': p['k-means_2']
                    },
        'k-means_3': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_3, idx, n_3),'k-means_3', p)[['original_title', 'model']],
                    'p_k': p['k-means_3']
                    },

        'hierarchical': {
                    'funcion': add_model(mas_cercanas_a_pelicula(movie_clusters_h, idx, n_h),'hierarchical', p)[['original_title', 'model']],
                    'p_k': p['hierarchical']
                    },
                                            
        'actores': {
                    'funcion': add_model(recomendadas_por_actores(idx, credits_cast, score_actor, movies_metadata,
                                                        N_ac, M_ac, factor_proba_ac , maximo_actores),'actores', p)[['original_title', 'model']],
                    'p_k': p['actores']
                    }, 
        'director': {
                    'funcion': add_model(recomendadas_por_director(idx, credits_crew, score_director, movies_metadata, 
                                                         N_dir, M_dir, factor_proba_dir),'director', p)[['original_title', 'model']],
                    'p_k': p['director']
                    },  
        'coocurrencia_actores': {
                    'funcion': add_model(recomendacion_por_conjunto_actores(conjunto_actores_df, idx, indices_actores, cosine_sim_actores, 
                                         credits, credits_cast, conjunto_actores_id, n_0, n_f, c),'coocurrencia_actores', p)[['original_title', 'model']],
                    'p_k': p['coocurrencia_actores']
                    }, 
        'overview': {
                    'funcion': add_model(recomendacion_por_overview(overview, idx, indices, cosine_sim, n_ov ),'overview', p)[['original_title', 'model']],
                    'p_k': p['overview']
                    },  
        'pop_metric': {
                    'funcion': add_model(pop_in_cluster(idx, clusters, pop_metric, n_pop),'pop_metric', p)[['original_title', 'model']],
                    'p_k': p['pop_metric']
                    },                    
        }

    if identificar_modelo:
        if sample:
            df =  pd.concat([modelos[key]['funcion'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])
        else:
            df =  pd.concat([modelos[key]['funcion'].iloc[:int(np.floor(modelos[key]['p_k']*len(modelos[key]['funcion'])))] for key in modelos.keys()])
    else:
        if sample:
            df =  pd.concat([modelos[key]['funcion']['original_title'].sample(frac = modelos[key]['p_k']) for key in modelos.keys()])
        else:
            df =  pd.concat([modelos[key]['funcion']['original_title'].iloc[:int(np.floor(modelos[key]['p_k']*len(modelos[key]['funcion'])))] for key in modelos.keys()])
    
    return df


def add_model(df, string, p = None):
    """"
        Funcion auxiliar para meter una columna que indique que modelo fue
    """
    if p is not None:
        if p[string] > 0:
            df['model'] = string
        else:
            df = pd.DataFrame(columns = ['original_title', 'model'])
    else:
        df['model'] = string
    return df

### Funciones auxiliares para determinar la cardinalidad de las intersecciones y uniones

def cardinalidad_interseccion(A, B):   
    return len(A.intersection(B))

def cardinalidad_union(A, B):  
    if len(A.union(B)) == 0:
        return 1
    else:
        return len(A.union(B))
    
def metrica_inter_union(A, B):
    return cardinalidad_interseccion(A, B)/cardinalidad_union(A, B)