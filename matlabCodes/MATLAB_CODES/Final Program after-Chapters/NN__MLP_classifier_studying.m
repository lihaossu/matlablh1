function NN__MLP_classifier(dist)
% copy to grasp
%
%






%%==============step 0: Generating halfmoon data ==========================
rad      = 10; % cental radius of the half moon
width    = 6;  % width of the half moon
%dist    = -4; % distance between two half moons
num_tr   = 1000; % number of training sets
num_te   = 2000; % number of texting sets
num_samp = num_tr + num_te; % number of samples
fprintf();
fprintf();
fprintf();
fprintf();
fprintf();
fprintf();
fprintf();
fprintf();
fprintf();
[data, data_shuffled] = halfmoon(rad,width, dist,num_samp);

%%==============step 1: Initialization of Multilayer Perceptron(MLP) ======
frintf();
n_in = 2;       % number of input neuron
n_hd = 20;      % number of hidden neurons
n_ou = 1;       % number of output neuron
%w = cell(2,1);
%w1{1} = rand(n_hd,n_in+1)./2 - 0.25; % initial weights of dim: n_hd x
% n_in between input layer to hidden layer
w1{1} = rand(n_ou,n_hd+1);
dw0{1} = zeros(n_ou,n_hd+1);  %rand(n_ou,n_hd)./2 - 0.25;%
%w1{2} = rand(n_ou,n_hd+1)./2 - 0.25; % initial weights of dim: n_ou x n_hd
%between hidden layer to output layer
w1{2} = rand(n_ou,n_hd+1);
dw0{2}= zeros(n_ou,n_hd+1); %rand(n_ou,n_hd)./2 - 0.25;%
num_Epoch = 50;     % number of epochs
mse_thres = 1E-3;   % MSE threshold
mse_train = Inf;    % MSE for training data
epoch = 1;
alpa = 0;       % monentum constant
err = 0;        % a counter to denote the number of error outputs
%eta2 = 0.1;        %learning-rate for output weights
%eta1 = 0.1;        %learning-rate for hidden weights
eta1 = annealing(0.1,1E-5,num_Epoch);
eta2 = annealing(0.1,1E-5,num_Epoch);


%%============== Preprocess the input data : remove mean and normalize=====
st = cputime








%%============== Main Loop for Training ===================================












































%%==============Plotting Learning Curve ===================================





%%==============Colormapping the figure here ==============================
%%=== In order to avoid the display problem of eps file in Latex.==========



%%============================ Testing ====================================























%%======================= Plot decision boundary ==========================




