% knndemo.m - demonstration of k-nearest neighbor classifier
% call knn.m
% (C) 2001 by Yu Hen Hu
% created: 10/10/2001
% Last modified: 9/28/2010

clear all; close all; clc;
% load training and testing file
load iris_tra.txt; load iris_tes.txt;

% feature dimension = 4, target dimension = 3
Pr=iris_tra(:,1:4); Tr=iris_tra(:,5:7);
Pt=iris_tes(:,1:4); Tt=iris_tes(:,5:7);
disp('Using Iris data set, feature dimension = 4, 3 classes');

for k=1:17,
    [Cmat,C_rate(k)]=knn(Pr,Tr,Pt,Tt,k);
    disp([int2str(k) '-nearest neighbor classifier, confusion matrix = '])
    Cmat
end

figure(1),clf
stem([1:17],100-C_rate),title('Classification error rate vs. k')
xlabel('k-nearest neighbors')
ylabel('% classification error')