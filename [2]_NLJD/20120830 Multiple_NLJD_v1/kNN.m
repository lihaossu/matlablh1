%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       2011.10.28
%%% k-NN Algorithm ver. 1
%%% "Design Basic k-NN" 
%%% Soongsil University
%%% Kwangyul Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function class = kNN(k,Measured,Class1,Class2)

%% Define the Class
NoSpecialFunc = 2;
% Class1 = rand(25,NoSpecialFunc);
% Class2 = rand(25,NoSpecialFunc);

%% Measured Data
% Measured = ceil(10*rand(1,NoSpecialFunc));

%% k-NN Factor
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
class = classifying - 1;
NeighborMaxNumber;

%% Graph
% figure
% % Class1 Plot
% for idx_Class1 = 1:size(Class1,1)
%     plot(Class1(idx_Class1,1),Class1(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',3);
%     hold on;
% end;
% 
% % Class2 Plot
% for idx_Class2 = 1:size(Class2,1)
%     plot(Class2(idx_Class2,1),Class2(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',3);
%     hold on;
% end;
% 
% hold on;
% Neighbors Plot
% for idx_neighborsInd = 1:size(neighborsInd)
%     plot(Samples(neighborsInd,1),Samples(neighborsInd,2), ...
%         'co','LineWidth',2,'MarkerSize',5);
%     hold on;
% end;
% 
% % Measured Data Plot
% plot(Measured(1),Measured(2),'go','LineWidth',2,'MarkerSize',3);
% grid on;
% axis([0 20 0 20]);
% xlabel('Second Harmonics');
% ylabel('Third Harmonics');