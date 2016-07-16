t=linspace(0,2*pi,100);
N=length(t);
num_tap=1;
for i=1:1:N
    P(i)=sin(t(i));
    T(i)=sin(t(i));
    if i>=4
        T(i)=cos(t(i-3))^5+sin(t(i-2))^2+cos(t(i-1))^3+sin(t(i));
    end
end
Q=100;
if num_tap==0
    P1=P(1:Q);
else
    P1 = zeros(num_tap,Q);
end
T1=T(1:Q);
for i=1:1:num_tap
    P1(i,i+1:Q) = P(1,1:(Q-i));
end
net = newff(minmax(P1),[5 1],{'tansig' 'purelin'});
nets = train(net,P1,T1);
y = sim(nets,P1);
plot(t(1:Q),T1,'r',t(1:Q),y,'b');
legend('real','estimated');