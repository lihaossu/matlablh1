x=linspace(-10,10,1000);
y1=1/((pi).^(1/2))*exp(-(x).^(2));
y2=1/((pi).^(1/2))*exp(-(x-1).^(2));
subplot(1,2,1);
plot(x,y1,x,y2);
xlabel('t=-10 to 10');
syms x0 y0
[x0]=solve(1/((pi).^(1/2))*exp(-(x0).^(2))==1/((pi).^(1/2))*exp(-(x0-1).^(2)));%get x0%
y0=1/((pi).^(1/2))*exp(-(x0-1).^(2));%the threshold point of y0%
subplot(1,2,2);
plot(x,y1,x,y2);
text(1/2,(5081767996463981*exp(-1/4))/9007199254740992,'\leftarrow threshold (1/2,(5081767996463981*exp(-1/4))/9007199254740992)');

