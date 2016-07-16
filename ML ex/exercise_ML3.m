x = load('ex3x.dat');
y = load('ex3y.dat');
% figure %Open a new figure window
% plot(x,y,'o');
% ylabel('')
% xlabel('') x has two kind of features, plot function is not good. The
% features have so different scales.

% Preprocessing data
% ones() function add a column of ones to x
m = length(x);
x = [ones(m,1),x];
sigma = std(x); % std function means standard deviation with two kinds of 
                % equations,std(x)[std(x,1) means same] is the first kind of equation '/(n-1)' 
                % the second kind of equation is std(x,2) with '/(n)'
mu = mean(x);
x(:,2) = (x(:,2) - mu(2)./sigma(2));
x(:,3) = (x(:,3) - mu(3)./sigma(3));

