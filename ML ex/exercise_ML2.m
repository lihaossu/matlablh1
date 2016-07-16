x = load('ex2x.dat');
y = load('ex2y.dat');
figure %open a new figure window
plot(x,y,'o');
ylabel('Height in meters')
xlabel('Age in years')
% ones() function add a column of ones to x
m = length(x); % number of training examples
x = [ones(m,1), x];
theta = zeros(size(x(1,:)))'; % initialize the parameters to theta
alpha = 0.07;
MAT_ITR = 1500;
for iteration_num = 1: MAT_ITR
    grad = (1/m).* x' *((x * theta) - y);
    theta = theta - alpha .* grad;
end
hold on % plot new data without clearing old plot
plot(x(:,2),x*theta,'-k')
legend('Training data','Linear regression')
hold off % don't overlay any more plots on this plot

exact_theta = (x' * x)\x' * y; % normal equation theta = inv(x'*x)*x'*y
exact_theta2 = inv(x'*x)*x'*y;% why (x' * x)\x' * y = inv(x'*x)*x'*y? 
% Predict values for age 3.5 and 7
predict1 = [1,3.5] * theta
predict2 = [1,7] * theta


% Understanding J(theta)
theta0_vals = linspace(-3, 3, 100);
theta1_vals = linspace(-1, 1, 100);
J_vals = zeros(100, 100);% initialize Jvals to 100x100 matrix of 0's
J_vals = zeros(length(theta0_vals), length(theta1_vals));

for i = 1:length(theta0_vals)
	  for j = 1:length(theta1_vals)
	      t = [theta0_vals(i); theta1_vals(j)];
	      J_vals(i,j) = (0.5/m).*((x * t-y)' * (x * t-y));
      end
    
end

% Plot the surface plot
% Because of the way meshgrids work in the surf command, we need to 
% transpose J_vals before calling surf, or else the axes will be flipped
J_vals = J_vals'
figure;
surf(theta0_vals, theta1_vals, J_vals)
xlabel('\theta_0'); ylabel('\theta_1')


