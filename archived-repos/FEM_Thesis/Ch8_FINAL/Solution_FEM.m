function [u,x] = Solution_FEM(n)

% For solving -u'' = 1. 

% setting coefficients
coefficients.a = 1; 
coefficients.b = 0; 
coefficients.c = 0;

% set left boundary condition
leftbdr.x = 0; 
leftbdr.type = 'Dirichlet'; 
leftbdr.value = 0;

% set right boundary condition
rightbdr.x = 10; 
rightbdr.type = 'Dirichlet'; 
rightbdr.value = 100;

% set right-hand side function f
f = @(x) 1;

% set number of intervals and generate grid
% For now, a uniform grid is generated.
% One can rewrite this part to generate a non-uniform grid. 
% n = 10;
x = linspace(leftbdr.x, rightbdr.x, n+1);

% assemble matrix A
A = sparse(n+1,n+1);
for i=1:n % on each sub-interval [x(i), x(i+1)]
localmat = assembleLocalMatrix(x(i),x(i+1),coefficients);
A(i:i+1,i:i+1) = A(i:i+1,i:i+1) + localmat;
end


% assemble right-hand side vector rhs = (f,v)
rhs = zeros(n+1,1);
for i=1:n % on each sub-interval [x(i), x(i+1)]
localrhs = assembleLocalRhs(x(i),x(i+1),f);
rhs(i:i+1) = rhs(i:i+1) + localrhs;
end

% apply left boundary condition
if strcmp(leftbdr.type, 'Dirichlet')
% make the first row (1,0,0,...,0), and set rhs(1) 
A(1,:) = 0;
A(1,1) = 1.0;
rhs(1) = leftbdr.value;
% change 2:end entries of rhs,
% then erase 2:end entries in the first column of A 
rhs(2:end) = rhs(2:end) - A(2:end,1) * leftbdr.value; A(2:end,1) = 0;
else % Neumann bdr condition
rhs(1) = rhs(1) - coefficients.a * leftbdr.value;
end


 % apply right boundary condition
if strcmp(rightbdr.type, 'Dirichlet')
% make the last row (0,...,0,0,1), and set rhs(end)
A(end,:) = 0;
A(end,end) = 1.0;
rhs(end) = rightbdr.value;
% change 1:end-1 entries of rhs,
% then erase 1:end-1 entries in the last column of A 
rhs(1:end-1) = rhs(1:end-1) - A(1:end-1,end) * rightbdr.value;
A(1:end-1,end) = 0;
else % Neumann bdr condition
rhs(end) = rhs(end) + coefficients.a * rightbdr.value;
end
% solve
u = A \ rhs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is to compute (au',v') + (bu',v) + (cu,v)
% on the subinterval [a,b]
function localA = assembleLocalMatrix(a,b,coefficients)
h = b-a;
localA = coefficients.a / h * [1, -1; -1, 1] ...
+ coefficients.b * [-0.5, 0.5; -0.5, 0.5] ... 
+ coefficients.c * h * [1/3, 1/6; 1/6, 1/3];

function localrhs = assembleLocalRhs(a,b,f)
% First, compute the Gaussian points and weights.
% Both gaussianpoints and gaussianweights are column vectors. 
[gaussianpoints, gaussianweights] = lgwt(5,a,b);
% evaluate the value f on Gaussian points % fvalue is a column vector
fvalue = f(gaussianpoints);
% evaluate the value of two basis functions
% (b-x)/(b-a) and (x-a)/(b-a)
% on gaussianpoints.
% "shape" is a matrix with two columns, each column
% contains the value of one basis function on gaussianpoints. 
h = b-a;
shape = [ (b-gaussianpoints)/h, (gaussianpoints-a)/h ];
  % apply the gaussian quadrature to compute localrhs
localrhs = shape' * (fvalue.*gaussianweights);

function [x,w]=lgwt(N,a,b)

% lgwt.m
%
% This script is for computing definite integrals using Legendre-Gauss 
% Quadrature. Computes the Legendre-Gauss nodes and weights  on an interval
% [a,b] with truncation order N
%
% Suppose you have a continuous function f(x) which is defined on [a,b]
% which you can evaluate at any x in [a,b]. Simply evaluate it at all of
% the values contained in the x vector to obtain a vector f. Then compute
% the definite integral using sum(f.*w);
%
% Written by Greg von Winckel - 02/25/2004
N=N-1;
N1=N+1; N2=N+2;

xu=linspace(-1,1,N1)';

% Initial guess
y=cos((2*(0:N)'+1)*pi/(2*N+2))+(0.27/N1)*sin(pi*xu*N/N2);

% Legendre-Gauss Vandermonde Matrix
L=zeros(N1,N2);

% Derivative of LGVM
Lp=zeros(N1,N2);

% Compute the zeros of the N+1 Legendre Polynomial
% using the recursion relation and the Newton-Raphson method

y0=2;

% Iterate until new points are uniformly within epsilon of old points
while max(abs(y-y0))>eps
    
    
    L(:,1)=1;
    Lp(:,1)=0;
    
    L(:,2)=y;
    Lp(:,2)=1;
    
    for k=2:N1
        L(:,k+1)=( (2*k-1)*y.*L(:,k)-(k-1)*L(:,k-1) )/k;
    end
 
    Lp=(N2)*( L(:,N1)-y.*L(:,N2) )./(1-y.^2);   
    
    y0=y;
    y=y0-L(:,N2)./Lp;
    
end

% Linear map from[-1,1] to [a,b]
x=(a*(1-y)+b*(1+y))/2;      

% Compute the weights
w=(b-a)./((1-y.^2).*Lp.^2)*(N2/N1)^2;

