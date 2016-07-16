%%

% 
% 
% http://www.matlabsky.com
% Email:sina363@163.com
% http://weibo.com/hgsz2003


%%
clc;
clear all
close all
nntwarn off;
warning off;
%% 
load data
%% 

Train=data(1:23,:);
Test=data(24:end,:);
p_train=Train(:,1:3)';
t_train=Train(:,4)';
p_test=Test(:,1:3)';
t_test=Test(:,4)';

%% 
t_train=ind2vec(t_train);%% ind2vec function??????????????????????????????????????
t_train_temp=Train(:,4)';
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
title('PNN ����ѵ�����Ч��')
xlabel('�������')
ylabel('������')
set(gca,'Ytick',[1:5])
subplot(1,2,2)
H=Yc-t_train_temp;
stem(H)
title('PNN ����ѵ��������ͼ')
xlabel('�������')


%
Y2=sim(net,p_test);
Y2c=vec2ind(Y2);
figure(2)
stem(1:length(Y2c),Y2c,'b^')
hold on
stem(1:length(Y2c),t_test,'r*')
title('PNN �����Ԥ��Ч��')
xlabel('Ԥ���������')
ylabel('������')
set(gca,'Ytick',[1:5])
