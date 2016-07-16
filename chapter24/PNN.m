function test_predict = PNN(train_data, train_class, test_data, sigma) 
 
% Classify using a probabilistic neural network 
% Inputs: 
% 	train_data	- Train patterns 
%	train_class	- Train targets 
%   test_data   - Test  patterns 
%	sigma           - Gaussian width 
% Outputs 
%	test_predict	- Predicted targets 
 
[Dim, Nf]       = size(train_data); 
c_category       = unique(train_class); 
 
%Build the classifier 
x               = train_data; 
W               = x ./(ones(Dim,1)*sqrt(sum(x.^2)));  %x_jk <- x_jk / sqrt(sum(x_ji^2)), w_jk <- x_jk 
 
%if x in w_i then a_ji <- 1 
a = zeros(Nf, length(c_category)); 
for i = 1:length(c_category), 
    a(find(train_class == c_category(i)),i) = 1; 
end 
 
%Test it and classify the test patterns 
test_data = test_data ./ (ones(Dim,1)*sqrt(sum(test_data.^2))); 
 
%z_k <- W'*test_data 
zk        = W' * test_data; 
 
%if a_ki=1 then g_i <- g_i + exp((zk-1)/sigma^2) 
gc = zeros(length(c_category),size(test_data,2)); 
for i = 1:length(c_category), 
    link            = a(:,i) * ones(1,size(test_data,2)); 
    gc(i,:)  = sum(exp((zk-1)/sigma^2) .* link); 
end 
 
%class <- argmax gc(x) 
[m, indices] = max(gc); 
test_predict = zeros(1,size(test_data,2)); 
for i = 1:length(c_category), 
    test_predict(find(indices == i)) = c_category(i); 
end 