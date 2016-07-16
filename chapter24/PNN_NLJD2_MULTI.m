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
 Electronic_x1 = 400; Electronic_y1 = 800;
 Training_Standard_Deviation = 50;
 Number_of_Training_Data = 60;
 Metal = [ceil(Metal_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 Metal_1 = [ceil(Metal_x1+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y1+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 NLJ = [ceil(Electronic_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 NLJ_1 = [ceil(Electronic_x1+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y1+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];          
 % Initialize the NLJ to Class1 and Metal to Class2
 Class1 = [NLJ ones(length(NLJ),1)*2];
 Class2 = [Metal ones(length(Metal),1)];
 Class3 = [Metal_1 ones(length(Metal_1),1)];
 Class4 = [[NLJ_1 ones(length(NLJ_1),1)*2];];
 
%%
data(1:60,:) = Class1(1:60,:);
data(61:120,:) = Class2(1:60,:); 
data(121:180,:) = Class3(1:60,:);
data(181:240,:) = Class4(1:60,:);
%% shuffle the data
[n_row,n_col] = size(data);
shuffle_seq = randperm(n_row);
for i = (1:n_row)
    data_shuffled(i,:) = data(shuffle_seq(i),:);
end
Train(1:30,:) = data_shuffled(1:30,:);
Train(31:60,:) = data_shuffled(61:90,:);
Train(61:90,:) = data_shuffled(121:150,:);
Train(91:120,:) = data_shuffled(181:210,:);
Test(1:30,:) = data_shuffled(31:60,:);
Test(31:60,:) = data_shuffled(91:120,:);
Test(61:90,:) = data_shuffled(151:180,:);
Test(91:120,:) = data_shuffled(211:240,:);
%% No shuffled data
% Train(1:30,:) = data(1:30,:);
% Train(31:60,:) = data(61:90,:);
% Train(61:90,:) = data(121:150,:);
% Train(91:120,:) = data(181:210,:);
% Test(1:30,:) = data(31:60,:);
% Test(31:60,:) = data(91:120,:);
% Test(61:90,:) = data(151:180,:);
% Test(91:120,:) = data(211:240,:);
%% shuffle the Train
% [n_row1,n_col1] = size(Train);
% shuffle_seq1 = randperm(n_row1);
% for i = (1:n_row1)
%     Train_shuffled(i,:) = Train(shuffle_seq1(i),:);
% end
% p_train = Train_shuffled(:,1:2)';
% t_train = Train_shuffled(:,3)';

%% shuffle the Test
% [n_row2,n_col2] = size(Test);
% shuffle_seq2 = randperm(n_row2);
% for i = (1:n_row2)
%     Test_shuffled(i,:) = Test(shuffle_seq2(i),:);
% end
% p_test = Test_shuffled(:,1:2)';
% t_test = Test_shuffled(:,3);
%%
p_train = Train(:,1:2)';
t_train = Train(:,3)';
p_test = Test(:,1:2)';
t_test = Test(:,3);

%% 
t_train=ind2vec(t_train);%%
t_train_temp=Train(:,3)';
%% 
Spread=3.5;
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


%%
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

%%
figure(3)
hold on;
        xmin = min(data_shuffled(:,1));
        xmax = max(data_shuffled(:,1));
        ymin = min(data_shuffled(:,2));
        ymax = max(data_shuffled(:,2));
        [x_b,y_b]= meshgrid(xmin:(xmax-xmin)/100:xmax,ymin:(ymax-ymin)/100:ymax);
        
        
n = size(Y2c,2); 
for i = 1:n,
    if Y2c(1,i) == 1
        plot(p_test(1,i),p_test(2,i),'rx');
    end
    if Y2c(1,i) == 2
        plot(p_test(1,i),p_test(2,i),'ko');
    end
end
xlabel('Third Harmonics');ylabel('Second Harmornics');










