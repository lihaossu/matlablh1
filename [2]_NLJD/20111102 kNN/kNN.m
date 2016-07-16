%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       2011.10.28
%%% k-NN Algorithm ver. 1
%%% "Design Basic k-NN"
%%% Soongsil University
%%% Kwangyul Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

%% Define the Class
NoSpecialFunc = 2;
% Class1 = rand(25,NoSpecialFunc);
% Class2 = rand(25,NoSpecialFunc);

Metal_x = 700;
Metal_y = 300;

Electronic_x = 300;
Electronic_y = 700;

%% Parameter
Standard_Training = 50;
Standard_Measure = 30;
Standard_Noise = 2;
Data_Number = 50;
Fuzzy_Data = 1000;

%%
Class1 = [ceil(Metal_x+Standard_Training*randn(Data_Number,1))...
    ceil(Metal_y+Standard_Training*randn(Data_Number,1))];
Class2 = [ceil(Electronic_x+Standard_Training*randn(Data_Number,1))...
    ceil(Electronic_y+Standard_Training*randn(Data_Number,1))];

%% Measured Data
% Measured = rand(1,NoSpecialFunc);
A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

% Symmetric DL
xv00 = [0; C(1)+C(2); C(1)+C(2); 0];
yv00 = [0; C(1)+C(2); C(1)+C(2); 0];


Measured = ceil(C+Standard_Measure*randn(1,2));

%% k-NN Factor
k = 5;
if k > size(Class1,1) + size(Class2,1)
    error('Check your number of k')
end;

%% Calculation
% Count the Class
NoClass1 = size(Class1,1);
NoClass2 = size(Class2,1);
NoSamples = NoClass1 + NoClass2;

% Rearrange the Samples and Measured Matrix
Samples = [Class1;Class2];
TrueClass = [zeros(NoClass1,1)+1;zeros(NoClass2,1)+2;];
MeasuredMatrix = repmat(Measured,NoSamples,1);

% Euclidean Distance
dist = sqrt((Samples(:,1)-MeasuredMatrix(:,1)).^2 + (Samples(:,2)-MeasuredMatrix(:,2)).^2);

% Another Method (Distance)
% absDiff = abs(Samples-MeasuredMatrix);
% absDiff = absDiff.^2;
% dist = sum(absDiff,2);

% Sort the Distance
[Y,I] = sort(dist);

% Cut the Closest Class by k
neighborsInd = I(1:k);

% Show the Closest TrueClass and their Index
neighbors = TrueClass(neighborsInd);
Neighbors1 = find(neighbors == 1);
Neighbors2 = find(neighbors == 2);

joint = [size(Neighbors1,1);size(Neighbors2,1)];
[NeighborMaxNumber classifying] = max(joint);
classifying
NeighborMaxNumber

%% Graph
% Class1 Plot
for idx_Class1 = 1:size(Class1,1)
    plot(Class1(idx_Class1,1),Class1(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',7);
    hold on;
end;

% Class2 Plot
for idx_Class2 = 1:size(Class2,1)
    plot(Class2(idx_Class2,1),Class2(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',7);
    hold on;
end;

% Neighbors Plot
for idx_neighborsInd = 1:size(neighborsInd)
    plot(Samples(neighborsInd,1),Samples(neighborsInd,2), ...
        'co','LineWidth',2,'MarkerSize',15);
    hold on;
end;

% Measured Data Plot
plot(Measured(1),Measured(2),'go','LineWidth',7,'MarkerSize',2);
grid on;
axis([0 1000 0 1000]);
%% Plot Symmetric
hold on;
plot(xv00,yv00,'b:','LineWidth',2)
grid on;
axis([C(1)-C(2) C(1)+C(2) C(2)-C(2) C(2)+C(2)])