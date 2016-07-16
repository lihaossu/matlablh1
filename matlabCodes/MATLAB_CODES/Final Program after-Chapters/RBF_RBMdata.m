%% Test the PNN performance with the same dataset in RBF. 




%%================Step 0: Generating data ================================
clc; clear all; close all;
num_tr = 500; % number of training sets
num_te = 100; % number of testing sets
Training_Standard_Deviation = 50;
Standard_Noise = 30;
% Metal
Metal_x1 = 600; Metal_y1 = 500; Metal_x2 = 900; Metal_y2 = 800;
% Test Metal
Metal_te_x = 400; Metal_te_y = 300;
%label0 = 1*ones(length(Metal_x1),1);
% Electronic
Electronic_x1 = 600; Electronic_y1 = 700; Electronic_x2 = 1300;Electronic_y2 =1400;
Electronic_te_x = 550; Electronic_te_y = 650;
%label1 = -1*ones(length(Electronic_x1),1);
% num_tr = 500 , so the total training data number is 2000
num_dim = 51;


for i = (1 : num_tr),
    Metal1_x1(i,:) = Metal_x1+ Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    Metal2_x2(i,:) = Metal_x2 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    Metal1_y1(i,:) = Metal_y1 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    Metal2_y2(i,:) = Metal_y2 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    data1_metal(i,:) = Metal1_x1(i,:) - Metal1_y1(i,:);
    data2_metal(i,:) = Metal2_x2(i,:) - Metal2_y2(i,:);
    Electronic1_x1(i,:) = Electronic_x1 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    Electronic1_y1(i,:) = Electronic_y1 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    Electronic2_x2(i,:) = Electronic_x2 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    Electronic2_y2(i,:) = Electronic_y2 +Standard_Noise*randn(1,1)+ Training_Standard_Deviation*randn(1,num_dim);
    data1_Elec(i,:) = Electronic1_x1(i,:) - Electronic1_y1(i,:);
    data2_Elec(i,:) = Electronic2_x2(i,:) - Electronic2_y2(i,:);
end
label0 = 1 * ones(length(data1_metal),1);
label1 = 2 * ones(length(data1_Elec),1);
% data 1,2,3,4
data1 = data1_metal;
data2 = data2_metal;
data3 = data1_Elec;
data4 = data2_Elec;
data = [data1;data2;data3;data4];
%scale the data to [0,1] range 
max1 = max(data(:,1:num_dim));
min1 = min(data(:,1:num_dim));
for i = (1:num_tr*4),
    data_scaled(i,:) = (data(i,:) - min1)./(max1 - min1);
end
labels = [label0;label0;label1;label1];
data_pre = [data_scaled , labels];
data_tr_shuffle = data_pre;
[n_tr_row,n_tr_col] = size(data_tr_shuffle);
shuffle_tr_seq = randperm(n_tr_row);
for i = (1:n_tr_row),
    data_tr_shuffledall(i,:) = data_tr_shuffle(shuffle_tr_seq(i),:);
end
data_tr_shuffled = data_tr_shuffledall(:,1:num_dim);
labels_tr_shuffled = data_tr_shuffledall(:,num_dim+1);
% D_train = data_tr_shuffled';
% L_train = labels_tr_shuffled';
%% Test data num_te = 200, so the total test data number is 400.
% Measured noise is seted to 2. 
Test_Standard_Deviation_ = 50;
for i = (1:num_te),
    Metal1_te_x(i,:) = Metal_te_x+ Standard_Noise*randn(1,1) + Test_Standard_Deviation_*randn(1,num_dim);
    Metal1_te_y(i,:) = Metal_te_y+ Standard_Noise*randn(1,1) + Test_Standard_Deviation_*randn(1,num_dim);
    data1_te_metal(i,:) = Metal1_te_x(i,:) - Metal1_te_y(i,:);
    Electronic1_te_x(i,:) = Electronic_te_x+ Standard_Noise*randn(1,1) + Test_Standard_Deviation_*randn(1,num_dim);
    Electronic1_te_y(i,:) = Electronic_te_y+ Standard_Noise*randn(1,1) + Test_Standard_Deviation_*randn(1,num_dim);
    data1_te_Elec(i,:) = Electronic1_te_x(i,:) - Electronic1_te_y(i,:);
end
label_te_0 = 1 * ones(size(data1_te_metal,1),1);
label_te_1 = 2 * ones(size(data1_te_Elec,1),1);
% data_te 1,2
data_te1 = data1_te_metal;
data_te2 = data1_te_Elec;
data_te = [data_te1;data_te2];
%scale the test data to [0,1] range
max1_te = max(data_te(:,1:num_dim));
min1_te = min(data_te(:,1:num_dim));
for i = (1:num_te*2),
    data_te_scaled(i,:) = (data_te(i,:) - min1_te)./(max1_te - min1_te);
end
labels_te = [label_te_0;label_te_1];
data_te_pre = [data_te_scaled,labels_te];
data_te_shuffle = data_te_pre;
[n_te_row,n_te_col] = size(data_te_shuffle);
shuffle_te_seq = randperm(n_te_row);
for i = (1:n_te_row),
    data_te_shuffledall(i,:) = data_te_shuffle(shuffle_te_seq(i),:);
end
data_te_shuffled = data_te_shuffledall(:,1:num_dim);
labels_te_shuffled = data_te_shuffledall(:,num_dim+1);
% D_test = data_te_shuffled';
% L_test = labels_te_shuffled';
% L_train_temp = L_train;
% L_train = ind2vec(L_train);
%% building PNN model
num_dim1 = 1:5:51;
frame = 10;
for idx_numdim = 1:length(num_dim1)
    D_train = data_tr_shuffled(:,1:num_dim1)'; 
    L_train = labels_tr_shuffled';
    D_test = data_te_shuffled(:,1:num_dim1)';
    L_test = labels_te_shuffled';
    L_train_temp = L_train;
    L_train = ind2vec(L_train);
    Spread = 3.5;
    for idx_frame = 1:frame
    net = newpnn(D_train,L_train,Spread);
    Y = sim(net,D_train);
    Yc = vec2ind(Y);
    Y2 =sim(net,D_test);
    Y2c = vec2ind(Y2);
    error = sum(Y2c~=L_test);
    Acc_error(idx_frame) = error;
    end
    Error(idx_numdim) = (sum(Acc_error)/(frame*num_te*2))*100;
end
bar(num_dim1,Error);
axis([0 56 0 50]);
grid on;
%% 
% figure(1)
% subplot(1,2,1)
% stem(1:length(Yc),Yc,'bo')
% hold on
% stem(1:length(Yc),L_train_temp,'r*')
% title('PNN training performace')
% xlabel('order')
% ylabel('classification result')
% set(gca,'Ytick',[1:5])
% subplot(1,2,2)
% H=Yc-L_train_temp;
% stem(H)
% title('PNN training error')
% xlabel('order')

%%

% figure(2)
% stem(1:length(Y2c),Y2c,'b^')
% hold on
% stem(1:length(Y2c),L_test,'r*')
% title('PNN test performance')
% xlabel('test order')
% ylabel('classification result')
% set(gca,'Ytick',[1:5])
%% error
%  error = sum(Y2c~=L_test);
%  error_rate = error/length(L_test);
%  fprintf('Classification error using PNN is %f\n', error_rate);












