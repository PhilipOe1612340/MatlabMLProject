

% from Global Optimisation Toolbox

options = struct("MaxGenerations", 1000000, "MaxTime", 5);
opt = struct("fitnessfcn", @testFn, "nvars", 11, "options", options);
[x,fval,exitflag,output,population,scores] = ga(opt);

x
output