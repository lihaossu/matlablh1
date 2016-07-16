% function [data, data_shuffled] = data_base(Data_Mode,Number_of_Training_Data)
% A function to generate the data_sample include 
% where Input:
%         rad  - central radius of the half moon
%        width - width of the half moon
%           d  - distance between two half moon
%      n_samp  - total number of the samples
%       Output:
%         data - output data
%data_shuffled - shuffled data
% For example
% halfmoon(10,2,0,1000) will generate 1000 data of 
% two half moons with radius [9-11] and space 0.

%% Initialize the Coordination of Training Data(Data Generator)
%1 :Symmetric, 2 : Asymmetric
Data_Mode = 2;
if Data_Mode == 1
    % Symmetric
    Metal_x = 700; Metal_y = 300;% modify the distance between Metal_x and Metal_y can change the Degree of Precison in MLP.And also we can generate the total data by randon (lh) 
    Electronic_x = 300; Electronic_y = 700;
elseif Data_Mode == 2
    % Asymmetric
    Metal_x = 400; Metal_y = 100;
    Electronic_x = 200; Electronic_y = 900;
end;

%% Important Prameter
Number_of_Training_Data
Training_Standard_Deviation
Standard_Measure
Standard_Noise
frame = 10; % the times of data collection 

for idx_frame = 1: frame
    %Generate the Metal and NLJ training Data
  Metal = [ceil(Metal_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
  NLJ = [ceil(Electronic_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))]; 
  % label
  Class1 = [NLJ zeros(length(NLJ),1)];
  Class2 = [Metal ones(length(Metal),1)];
  % Test data
  % Calculate the center of total training data
  A = ceil(sum(Class1(:,1:2))/length(Class1));
  B = ceil(sum(Class2(:,1:2))/length(Class2));
  C = ceil(A+B)/2;
  % Measure the concealed-device
  Measured = ceil(C+Standard_Measure*randn(1,2));
  Measured_Noise = Measured + ceil(Standard_Noise*randn(1,2));
  fuzzy_Data = 100;
  Measured_rand = repmat(C,fuzzy_Data,1) + 100.*randn(fuzzy_Data,2);
  Database = 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

