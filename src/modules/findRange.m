function [ A_range,ii ] = findRange( A_all,dt,T )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[n,m]=size(A_all);

A_range=zeros(length(0:dt:T),(m-1)*2);
A_range(:,1)=0:dt:T;
tTotal=A_all(:,1);eps=1e-3;t=0;

for i=1:n
    %     i1=find(tTotal<=eps+t)
    %     i2=find(tTotal>=-eps+t)
    index=find(t>=tTotal-eps & t<=tTotal+eps);
    
    %     index=intersect(i1,i2)
    var1_temp=A_all(index,2);
    var2_temp=A_all(index,3);
    var1=[min(var1_temp),max(var1_temp)];
    var2=[min(var2_temp),max(var2_temp)];
    try
        A_range(i,[2 3])=var1;
        A_range(i,[4 5])=var2;
    end   
    
        ii=i;
    
    t=dt*i;
    
end
end

