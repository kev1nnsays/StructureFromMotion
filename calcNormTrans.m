function [T, T_prime] = calcNormTrans(priors1, priors2)

Points = length(priors1(1,:));

xmean = mean(priors1(1,:));
ymean = mean(priors1(2,:));
d=0;
x_average=0; 
y_average = 0; 
for i = 1:Points
    d = d + sqrt((priors1(1,i)-xmean)^2+(priors1(2,i)-ymean)^2)/Points*sqrt(2);
    x_average = x_average + priors1(1,i)/Points;
    y_average = y_average + priors1(2,i)/Points;
end

T = [1/d 0 -x_average/d;...
     0 1/d -y_average/d;...
     0 0 1];

%q' = T_prime * x'
xmean = mean(priors2(1,:));
ymean = mean(priors2(2,:));
d=0;
x_average=0; 
y_average = 0; 
for i = 1:Points
    d = d + sqrt((priors2(1,i)-xmean)^2+(priors2(2,i)-ymean)^2)/Points*sqrt(2);
    x_average = x_average + priors2(1,i)/Points;
    y_average = y_average + priors2(2,i)/Points;
end

T_prime = [1/d 0 -x_average/d;...
           0 1/d -y_average/d;...
           0 0 1];