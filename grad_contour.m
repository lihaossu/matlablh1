v = -2:0.2:2;
[x,y] = meshgrid(v);
z = x.* exp(-x.^2-y.^2);
[px,py]= gradient(z,.2,.2);
plot(z);
