x = load('ex2x.dat');
y = load('ex2y.dat');
plot(x,y,'*')
xlabel('height')
ylabel('age')
x = [ones(length(x),1) x];
w = inv(x' * x) * x' * y;% the normal equation for linear regression
hold on 
plot(x(:,2), w(2,1).*x(:,2)+w(1,1));