function [trainRmse, testRmse, theta]=lseTrainTest(A, b, trainingIndex)
% lseTrainTest: Training & test procedure for LSE
%
%	Usage:
%		[trainRmse, testRmse, theta]=lseTrainTest(A, b, trainingIndex)
%

%	Category: Least-squares estimate
%	Roger Jang, 20150825

if nargin<3, trainingIndex=1:2:size(A,1); end

A1=A(trainingIndex, :); b1=b(trainingIndex);		% Training data
A2=A; A2(trainingIndex,:)=[]; b2=b; b2(trainingIndex)=[];	% Test data
theta=A1\b1;
trainRmse=norm(A1*theta-b1)/sqrt(size(A1,1));
testRmse =norm(A2*theta-b2)/sqrt(size(A2,1));
