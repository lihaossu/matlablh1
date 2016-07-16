%% this 

%%
clc;
clear all
close all
% %% 
% load class1
% load class2
%%
 Metal_x = 400; Metal_y = 100;
 Electronic_x = 200; Electronic_y = 900;
  Metal_x1 = 700; Metal_y1 = 300;
  Metal_te_x = 500; Metal_te_y = 400;
 Electronic_x1 = 400; Electronic_y1 = 800;
 Electronic_te_x = 550; Electronic_te_y = 650;
 Training_Standard_Deviation = 50;
 Number_of_Training_Data = 50;
 Standard_Measure = 30;
 Standard_Noise = 2;
 Metal1 = [ceil(Metal_x1+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y1+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 Metal = [ceil(Metal_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 NLJ = [ceil(Electronic_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 NLJ1 = [ceil(Electronic_x1+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y1+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 Measured_Metal = [ceil(Metal_te_x+Standard_Noise*randn(1,1)+Standard_Measure*randn(Number_of_Training_Data,1)) ceil(Metal_te_y+Standard_Noise*randn(1,1) + Standard_Measure*randn(Number_of_Training_Data,1))];
 Measured_NLJ = [ceil(Electronic_te_x+Standard_Noise*randn(1,1)+Standard_Measure*randn(Number_of_Training_Data,1)) ceil(Electronic_te_y+Standard_Noise*randn(1,1)+Standard_Measure*randn(Number_of_Training_Data,1))];
 
 % Initialize the NLJ to Class1 and Metal to Class2
 Class1 = [NLJ ones(length(NLJ),1)*2];
 Class2 = [NLJ1 ones(length(NLJ1),1)*2];
 Test1 = [Measured_NLJ ones(length(Measured_NLJ),1)*2];
 Class3 = [Metal ones(length(Metal),1)];
 Class4 = [Metal1 ones(length(Metal1),1)];
 Test2 = [Measured_Metal ones(length(Measured_Metal),1)];
%% 
Train(1:50,:) = Class1(1:50,:);
Train(51:100,:) = Class2(1:50,:);
Train(101:150,:) = Class3(1:50,:);
Train(151:200,:) = Class4(1:50,:);

Test(1:50,:) = Test1(1:50,:);
Test(51:100,:) = Test2(1:50,:);
%% shuffle the Train
[n_row,n_col] = size(Train);
shuffle_seq = randperm(n_row);
for i = (1:n_row)
    Train_shuffled(i,:) = Train(shuffle_seq(i),:);
end
%% shuffle the Test
[n_row,n_col] = size(Test);
shuffle_seq = randperm(n_row);
for i = (1:n_row)
    Test_shuffled(i,:) = Test(shuffle_seq(i),:);
end
p_train = Train_shuffled(:,1:2)';
t_train = Train_shuffled(:,3)';
p_test = Test_shuffled(:,1:2)';
t_test = Test_shuffled(:,3);
%% 
t_train=ind2vec(t_train);%% ind2vec function??????????????????????????????????????
t_train_temp=Train(:,3)';
%% 
Spread=1.5;
net = newpnn(p_train,t_train,Spread)
%% 
% 
Y=sim(net,p_train);
% 
Yc=vec2ind(Y);

%% 
figure(1)
subplot(1,2,1)
stem(1:length(Yc),Yc,'bo')
hold on
stem(1:length(Yc),t_train_temp,'r*')
title('PNN training performace')
xlabel('order')
ylabel('classification result')
set(gca,'Ytick',[1:5])
subplot(1,2,2)
H=Yc-t_train_temp;
stem(H)
title('PNN training error')
xlabel('order')


%
Y2=sim(net,p_test);
Y2c=vec2ind(Y2);
figure(2)
stem(1:length(Y2c),Y2c,'b^')
hold on
stem(1:length(Y2c),t_test,'r*')
title('PNN test performance')
xlabel('test order')
ylabel('classification result')
legend('the predict classification ','the labeled classification')
set(gca,'Ytick',[1:5])