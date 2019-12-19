%function fitness = testFn(a,b,c,d,e,f,g,h,i,j,k)
function fitness = testFn(p)
    %p = [a,b,c,d,e,f,g,h,i,j,k];  
    fitness = sum(p) + norm(p) / (p(2) + 100) * 100;
end