function [ step]=detectAmountOfSteps(data)
x= data(:,1).^2;
y= data(:,2).^2;
z=data(:,3).^2;
a = sqrt(data(:,1).^2+data(:,2).^2+data(:,3).^2);
n = size(a,2);
p=[];
step=0;
i=2;
while (i<n)
   if (a(i,1)>a(i-1,1) & a(i,1)>a(i+1,1))
       p(i)=1;
   else
       p(i)=0;
   end
   i=i+1;
end
j = 1;
k=0;
while (j<n)
   if (p(j)==1)
      if k~=0
         D = j-k-1;
         if (D>2)
            step = step+1; 
         end
      end
      k=j;
   end
   j=j+1;
end
if (j==n)
   D=n-k;
   if (D>2)
       step =step +1;
   end
end
