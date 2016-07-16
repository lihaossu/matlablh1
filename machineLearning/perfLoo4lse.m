function [trainRmseMean, testRmseMean, trainRmse, testRmse, time]=perfLoo4lse(A, b, method, plotOpt)
% perfLoo4lse: Leave-one-out cross validation for LSE (least-squares estimate) of A*x=b.
%
%	Usage:
%		[trainRmseMean, testRmseMean, trainRmse, testRmse, time]=perfLoo4lse(A, b, method, plotOpt)
%
%	Example:
%		A=rand(30, 10);
%		dataCount=size(A,1);
%		b=A*[1:size(A,2)]'+0.1*rand(dataCount, 1);
%		plotOpt=1;
%		method=1;
%		subplot(121); [trainRmseMean, testRmseMean, trainRmse, testRmse, time]=perfLoo4lse(A, b, method, plotOpt);
%		method=2;
%		subplot(122); [trainRmseMean2, testRmseMean2, trainRmse2, testRmse2, time2]=perfLoo4lse(A, b, method, plotOpt);

%	Category: Least-squares estimate
%	Roger Jang, 20150401, 20151211

if nargin<1, selfdemo; return; end
if nargin<3, method=1; end
if nargin<4, plotOpt=0; end

[dataCount, feaDim]=size(A);
testRmse=zeros(dataCount, 1);
trainRmse=zeros(dataCount, 1);

myTic=tic;
switch(method)
	case 1		% Batch method, which is slow
		for i=1:dataCount
			hiddenA=A(i,:);
			hiddenB=b(i,:);
			A2=A; A2(i,:)=[];
			b2=b; b2(i,:)=[];
			x=A2\b2;
			trainRmse(i)=norm(b2-A2*x)/sqrt(dataCount-1);
			testRmse(i)=norm(hiddenB-hiddenA*x);
		end
	case 2		% Incremental method
		P=inv(A'*A);
		x=A\b;
		for i=1:dataCount
			a=A(i,:)';
			out=b(i);
			Q=P+(P*a*a'*P)/(1-a'*P*a);
			x2=x-Q*a*(out-a'*x);
			B=A; B(i,:)=[]; c=b; c(i)=[];
			trainRmse(i)=norm(c-B*x2)/sqrt(dataCount-1);
			testRmse(i)=norm(out-a'*x2);
		end
	otherwise
		error('Unknown method!');
end
trainRmseMean=mean(trainRmse);
testRmseMean=mean(testRmse);
time=toc(myTic);

if plotOpt
%	plot(1:dataCount, trainRmse, 1:dataCount, testRmse);
	[sortedTestRmse, index]=sort(testRmse, 'descend');
	sortedTrainRmse=trainRmse(index);
	bar([sortedTrainRmse, sortedTestRmse]);
	legend('Training RMSE', 'Test RMSE', 'location', 'northOutside', 'orientation', 'horizontal');
	title(sprintf('method=%d, time=%g sec, trainRmseMean=%g, testRmseMean=%g', method, time, trainRmseMean, testRmseMean));
	xlabel('Data index (after sorting)'); ylabel('RMSE');
%	xTickLabel=get(gca, 'xTickLabel');
%	set(gca, 'xticklabel', xTickLabel(index));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);