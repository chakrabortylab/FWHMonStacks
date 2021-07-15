close all,
clear,
clc
%%
x = -10:10;
y = 2*exp(x).^-1 + 3 + 25*rand(1,length(x));
% fit the data
c = polyfit(x,y,7);
% generate fitted curve
xfit = -10:0.1:10;
yfit = polyval(c,xfit);

figure 
plot(x,y,'o',xfit,yfit,'-')
legend({'data','curve-fit'})
title('data and fitted curve')

figure 
plot(x,y,'o'); 
hold on 
plot(xfit,yfit,'-')
hold off 
legend({'data','curve-fit'})
title('data and fitted curve')