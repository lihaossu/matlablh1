x=linspace(-inf,inf);
y1=(1/((pi)^(1/2)))*exp((-x)^2);
y2=(1/((pi)^(1/2)))*exp(-(x-1)^2);
plot(x,y1,'o',x,y2,'*');