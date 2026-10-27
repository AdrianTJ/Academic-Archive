clear all; close all;   % Clear every thing so it won't mess up with other
                        % existing variables.

Real_Value = @(t) 15*t - (1/2)*t.^2;
iterations = 16;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  L2 NORM ESTIMATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for i = 1:iterations
%     [U,x] = Solution_FEM(2^i);
%     F = griddedInterpolant(x,U);
%     FEM_Approximation = @(t) F(t);
%     Sub_Sqrd = @(t) (F(t) - Real_Value(t)).^2;
%     L2_Norm(i) = (integral(Sub_Sqrd, x(1),x(end)))^(1/2);
%     intervals(i) = 2^i;
%     length(i) = x(2) - x(1);
% end
% 
% L2_Norm
% 
% loglog(intervals,L2_Norm,'*-')
% grid on
% plot(log(L2_Norm))
% 
% for i = 2:iterations
%     EOC(i) = log(L2_Norm(i)/L2_Norm(i-1))/log(length(i)/length(i-1));
% end
% 
% EOC
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  H1 SEMINORM ESTIMATION  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% h = 1e-10;
% Deriv_Real_Value = @(x) (Real_Value(x+h) - Real_Value(x-h))/(2*h);
% 
% for i = 1:iterations
%     [U,x] = Solution_FEM(2^i);
%     F = griddedInterpolant(x,U);
%     FEM_Approximation = @(t) F(t);
%     Deriv_FEM_Approximation = @(t) (F(t+h) - F(t-h))/(2*h);
%     Deriv_Sub_Sqrd = @(t) (Deriv_Real_Value(t) - ...
%                           Deriv_FEM_Approximation(t)).^2;
%     H1_Seminorm(i) = (integral(Deriv_Sub_Sqrd, x(1),x(end)))^(1/2);
%     intervals(i) = 2^i;
%     length(i) = x(2) - x(1);
% end
% 
% H1_Seminorm
% loglog(intervals,H1_Seminorm,'+-')
% 
% for i = 2:iterations
%     EOC(i) = log(H1_Seminorm(i)/H1_Seminorm(i-1))/...
%              log(length(i)/length(i-1));
% end
% 
% EOC
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  H1 NORM ESTIMATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% h = 1e-10;
% Deriv_Real_Value = @(x) (Real_Value(x+h) - Real_Value(x-h))/(2*h);
% 
% for i = 1:iterations
%     [U,x] = Solution_FEM(2^i);
%     F = griddedInterpolant(x,U);
%     FEM_Approximation = @(t) F(t);
%     Deriv_FEM_Approximation = @(t) (F(t+h) - F(t-h))/(2*h);
%     Deriv_Sub_Sqrd = @(t) (Deriv_Real_Value(t) - ...
%                           Deriv_FEM_Approximation(t)).^2;
%     Sub_Sqrd = @(t) (F(t) - Real_Value(t)).^2;
%     H1_Norm(i) = (integral(Deriv_Sub_Sqrd, x(1),x(end)))^(1/2) + ...
%                  (integral(Sub_Sqrd, x(1),x(end)))^(1/2);
%     intervals(i) = 2^i;
%     length(i) = x(2) - x(1);
% end
% 
% H1_Norm
% plot(H1_Norm)
% plot(log(H1_Norm))
% 
% for i = 2:iterations
%     EOC(i) = log(H1_Norm(i)/H1_Norm(i-1))/...
%              log(length(i)/length(i-1));
% end
% 
% EOC
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  L-inf SEMINORM ESTIMATION  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for i = 1:iterations
%     [U,x] = Solution_FEM(2^i);
%     F = griddedInterpolant(x,U);
%     FEM_Approximation = @(t) F(t);
%     x2 = 0:1e-4:10;
%     Sol = arrayfun(FEM_Approximation,x2) - arrayfun(Real_Value,x2);
%     Linf_Norm(i) = max(abs(Sol));
%     intervals(i) = 2^i;
%     length(i) = x(2) - x(1);
% end
% 
% Linf_Norm
% plot(log(Linf_Norm))
% 
% for i = 2:iterations
%     EOC(i) = log(Linf_Norm(i)/Linf_Norm(i-1))/...
%              log(length(i)/length(i-1));
% end
% 
% EOC





