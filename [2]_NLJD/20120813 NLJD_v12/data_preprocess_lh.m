%%%%%%% Preprocess Data%%%%%%%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

%% Important Parameter
% kNN Factor
% k = 3:4:51;( i don't know if kNN is necessary or not in MLP/RBF )
% Standard Deviation
Standard_Measure = 30;
Standard_Noise = 2;
% Standard deviation of the training data
Training_Standard_Deviation = 50;
% Number of training data (if 50, the Total Traning Data is 100)
Number_of_Training_Data = 50;

%% Initialize the coordination of Training Data (Data Generator)
% Data_Mode = 1; % 1 : Symmetric
  Data_Mode = 2; % 2 : Asymmetric 
 
if Data_Mode == 1
    % Symmetric
    Metal_x = 700; Metal_y = 300;
    Electronic_x = 300; Electronic_y = 700;
elseif Data_Mode == 2
    % Asymmetric
    Metal_x = 400; Metal_y = 100;
    Electronic_x = 200; Electronic_y = 900;
end;

%% Step 0: Generating data 
 Metal = [ceil(Metal_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 
 NLJ = [ceil(Electronic_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
 % Initialize the NLJ to Class1 and Metal to class2
 Class1 = [NLJ ,zeros(length(NLJ),1)];
 Class2 = [Metal ,ones(length(Metal),1)];
 %%==== Process the input data : remove mean and normalize ================
%  mean1 = [mean(Class1(:,1:2)), 0];
%  mean2 = [mean(Class2(:,1:2)), 0];
%   
%  for i = 1:Number_of_Training_Data,
%      Class1(i,:) = Class1(i,:) - mean1;
%      Class2(i,:) = Class2(i,:) - mean2;    
%  end
%  max1 = [max(Class1(:,1:2)), 1];
%  max2 = [max(Class2(:,1:2)), 1];
%  for i = 1:Number_of_Training_Data,
%      Class1(i,:)= Class1(i,:)./max1;
%      Class2(i,:)= Class2(i,:)./max2;
%  end
% Database = [Class1(:,1:2);Class2(:,1:2)];
 figure(1)
 hold
 for j = 1 : Number_of_Training_Data,
     plot(Class1(j,1),Class1(j,2),'b+','LineWidth',1);
     plot(Class2(j,1),Class2(j,2),'ro','LineWidth',1);
 end
 legend('Class1','Class2')
 grid on
 axis([0 1100 0 1100]);
 xlabel('Third Harmonics');
 ylabel('Second Harmonics');
 hold off
 
 
 
 
 
 
 
 
 
 
