%% knncEval
% K-nearest neighbor classifier (KNNC)
%% Syntax
% * 		[computedClass, overallComputedClass, nnIndex, knncMat]=knncEval(testSet, knncPrm)
%% Description
%
% <html>
% <p>computedClass = knncEval(testSet, knncPrm) returns the results of KNNC, where
% 	<ul>
% 	<li>testSet: the test set
% 	<li>knncPrm: parameters for KNNC
% 		<ul>
% 		<li>knncPrm.k: the value of k for k-nearest neighbor classification
% 		</ul>
% 	<li>computedClass: output vector by KNNC
% 	</ul>
% <p>[computedClass, logLike, recogRate hitIndex, nnIndex] = knncEval(testSet, knncPrm) returns extra info:
% 	<ul>
% 	<li>testSet: the test set
% 	<li>logLike: log likelihood for each of the test set
% 	<li>recogRate: recognition rate
% 	<li>hitIndex: index of correctly classified test pairs
% 	<li>nnIndex: index of knncPrm.input that are closest to testSet.input
% 	</ul>
% </html>
%% Example
%%
%
[trainSet, testSet]=prData('iris');
trainNum=size(trainSet.input, 2);
testNum =size(testSet.input, 2);
fprintf('Use of KNNC for Iris data:\n');
fprintf('\tSize of train set (odd-indexed data) = %d\n', trainNum);
fprintf('\tSize of test set (even-indexed data) = %d\n', testNum);
knncTrainPrm.method='none';
knncPrm=knncTrain(trainSet, knncTrainPrm);
fprintf('\tRecognition rates as K varies:\n');
kMax=15;
for k=1:kMax
	knncPrm.k=k;
	computed=knncEval(testSet, knncPrm);
	correctCount=sum(testSet.output==computed);
	recogRate(k)=correctCount/testNum;
	fprintf('\t%d-NNC ===> RR = 1-%d/%d = %.2f%%.\n', k, testNum-correctCount, testNum, recogRate(k)*100);
end
plot(1:kMax, recogRate*100, 'b-o'); grid on;
title('Recognition rates of Iris data using KNN classifier');
xlabel('K'); ylabel('Recognition rates (%)');
