%% svmcEval
% Evaluation of SVM (support vector machine) classifier
%% Syntax
% * 		computedClass=svmcTrain(DS, cPrm)
% * 		[computedClass, ~, recogRate, hitIndex]=svmcEval(DS, cPrm)
%% Description
%
% <html>
% <p>computedClass=svmcEval(DS, cPrm) returns values of SVM (support vector machine) classifier based on the given dataset DS and the SVM model cPrm.
% <p>Note that this function calls the mex files of libsvm directly, which are available at "http://www.csie.ntu.edu.tw/~cjlin/libsvm/".
% </html>
%% Example
%%
%
DS=prData('iris');
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
[svmPrm, logLike1, recogRate1]=svmcTrain(trainSet);
[computedClass, logLike2, recogRate2, hitIndex]=svmcEval(testSet, svmPrm);
fprintf('Inside recog. rate = %g%%\n', recogRate1*100);
fprintf('Outside recog. rate = %g%%\n', recogRate2*100);
%% See Also
% <svmTrain_help.html svmTrain>.
