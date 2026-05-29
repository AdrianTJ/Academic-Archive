def bfgs(f, gradiente, x_init, tol=1e-3):
    """
    Cálculo de aproximación numérica de mínimo de una función por el método de BFGS.
    Se usa búsqueda de línea de el paquete scipy. 
    Args:
    
        f (function): función a la cual aproximar el mínimo.
        
        gradiente (function): Expresión para el gradiente de f.
        
        x_init (np.array): Punto inicial del cual seguirá el método.
        
        tol (float): Tolerancia para el problema.
        
    Regresa:
    
        xk (np.array): Valor final de la aproximación. 

        k (integer): Número de iteraciones. 
    """
    # Se inicializa el número de iteraciones
    k = 0

    # Se inicializa el gradiente
    grad_k = gradiente(x_init)

    # Se calcula el tamaño necesario para la Hessiana `Hess`, dependiendo del tamaño 
    # del vector x_init. Se inicializa como la identidad. 
    n = len(x_init)
    Hess = np.eye(n)

    # Inicialización del vector solución. 
    x_k = x_init

    # Inicializamos alfa
    alfa = 0.001

    while np.linalg.norm(grad_k,2) > tol and k < 2000:
        # pk: Aproximación a la dirección de descenso por Newton. 
        p_k = -Hess @ grad_k

        # Busqueda de línea de scipy. Regresa varias cosas, pero solamente nos 
        # interesa el primer término, alfa. 
        alfa = sp.optimize.line_search(f, gradiente, x_k, p_k)[0]
        if alfa == None: 
          alfa = 0.01

        # Creando nueva x para siguiente iteración. 
        x_new = x_k + alfa * p_k
        
        # Calculamos `s` y `y` para la iteración k, y actualizamos x y el gradiente
        s_k = x_new - x_k
        x_k = x_new
        grad_new = gradiente(x_new)
        y_k = grad_new - grad_k
        grad_k = grad_new
        

        # Actualización de la aproximación a la Hessiana
        rho_k = 1.0 / (y_k.transpose() @ s_k)
        A1 = np.eye(n) - rho_k * np.outer(s_k, y_k)
        A2 = np.eye(n) - rho_k * np.outer(y_k, s_k)
        Hess = A1 @ (Hess @ A2) + (rho_k * np.outer(s_k,s_k))

        # Subimos el número de iteraciones
        k += 1
    return (x_k, k)