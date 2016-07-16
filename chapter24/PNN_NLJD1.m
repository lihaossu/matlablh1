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
 Training_Standard_Deviation = 50;
 Number_of_Training_Data = 50;
 Metal = [ceil(Metal_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 NLJ = [ceil(Electronic_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
            
 % Initialize the NLJ to Class1 and Metal to Class2
 Class1 = [NLJ ones(length(NLJ),1)*2];
 Class2 = [Metal ones(length(Metal),1)];
%% 
data(1:50,:) = Class1(1:50,:);
data(51:100,:) = Class2(1:50,:); 
Train(1:25,:) = data(1:25,:);
Train(26:50,:) = data(51:75,:);
Test(1:25,:) = data(26:50,:);
Test(26:50,:) = data(76:100,:);
p_train = Train(:,1:2)';
t_train = Train(:,3)';
p_test = Test(:,1:2)';
t_test = Test(:,3);
%% 
t_train=ind2vec(t_train);%% ind2vec function??????????????????????????????????????
t_train_temp=Train(:,3)';
%% 
Spread=1.5;
net=newpnn(p_train,t_train,Spread)
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
set(gca,'Ytick',[1:5])