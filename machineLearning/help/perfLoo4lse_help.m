%% perfLoo4lse
% Leave-one-out cross validation for LSE (least-squares estimate) of A*x=b.
%% Syntax
% * 		[trainRmseMean, testRmseMean, trainRmse, testRmse, time]=perfLoo4lse(A, b, method, plotOpt)
%% Description
%
% <html>
% </html>
%% Example
%%
%
A=rand(30, 10);
dataCount=size(A,1);
b=A*[1:size(A,2)]'+0.1*rand(dataCount, 1);
plotOpt=1;
method=1;
subplot(121); [trainRmseMean, testRmseMean, trainRmse, testRmse, time]=perfLoo4lse(A, b, method, plotOpt);
method=2;
subplot(122); [trainRmseMean2, testRmseMean2, trainRmse2, testRmse2, time2]=perfLoo4lse(A, b, method, plotOpt);
