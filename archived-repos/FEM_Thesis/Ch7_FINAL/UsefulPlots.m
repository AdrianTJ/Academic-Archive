clear all; close all;   % Clear every thing so it won't mess up with other
                        % existing variables.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  GENERAL PLOT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 5;

Real_Value = @(x) (-exp(x+3).*(x-3) + exp(x).*x - 3*exp(3))/(exp(3)-1);     
[U,x] = Solution_FEM(2^i);
F = griddedInterpolant(x,U);
FEM_Approximation = @(t) F(t);

x2 = 0:0.001:3;
plot(x, FEM_Approximation(x), '+-', x2,Real_Value(x2),'r') 
legend('FEM Solution','Analytical Solution', 'Location', 'northwest')
title('Graph of \phi(x)')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ERROR PLOT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% i = 5;
% 
% Real_Value = @(x) (-exp(x+3).*(x-3) + exp(x).*x - 3*exp(3))/(exp(3)-1);
% [U,x] = Solution_FEM(2^i);
% F = griddedInterpolant(x,U);
% FEM_Approximation = @(t) F(t);
% 
% x2 = 0:1e-4:3;
% Sol = arrayfun(FEM_Approximation,x2) - arrayfun(Real_Value,x2);
% 
% plot(x2,Sol)
% title('Error of the FEM Approximation')
% grid on
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  LOG2 NORM PLOT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = 1e-10;
Real_Value = @(x) (-exp(x+3).*(x-3) + exp(x).*x - 3*exp(3))/(exp(3)-1);
Deriv_Real_Value = @(x) (Real_Value(x+h) - Real_Value(x-h))/(2*h);

for i = 1:16
    [U,x] = Solution_FEM(2^i);
    F = griddedInterpolant(x,U);
    FEM_Approximation = @(t) F(t);
    Sub_Sqrd = @(t) (F(t) - Real_Value(t)).^2;
    Deriv_FEM_Approximation = @(t) (F(t+h) - F(t-h))/(2*h);
    Deriv_Sub_Sqrd = @(t) (Deriv_Real_Value(t) - ...
                          Deriv_FEM_Approximation(t)).^2;
    L2_Norm(i) = (integral(Sub_Sqrd, x(1),x(end)))^(1/2);
    H1_Seminorm(i) = (integral(Deriv_Sub_Sqrd, x(1),x(end)))^(1/2);
    intervals(i) = x(2)-x(1);
end

plot(log2(intervals), log2(H1_Seminorm), '+-')
hold on
plot(log2(intervals), log2(L2_Norm), '*-')
ytick = get(gca, 'YTick')
str = cellstr( num2str(ytick(:),'2^{%d}') )
xtick = get(gca, 'XTick')
str2 = cellstr( num2str(xtick(:),'2^{%d}') )
format_ticks(gca,str2,str)
legend('H^1 Seminorm of the Error','L^2 Norm of the Error','Location','northwest')
title('Comparison of Norms on a log_2-log_2 Scale')
grid on


