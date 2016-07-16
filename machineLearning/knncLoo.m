function [recogRate, computed, nearestIndex] = knncLoo(DS, knncPrm, plotOpt)
%knncLoo: Leave-one-out recognition rate of KNNC
%
%	Usage:
%		recogRate=knncLoo(DS)
%		recogRate=knncLoo(DS, knncPrm)
%		recogRate=knncLoo(DS, knncPrm, plotOpt)
%		[recogRate, computed, nearestIndex]=knncLoo(...)
%
%	Description:
%		recogRate=knncLoo(DS) returns the recognition rate of the KNNC over the dataset DS based on the leave-one-out criterion.
%		recogRate=knncLoo(DS, knncPrm) uses the KNNC parameters in knncPrm for the computation.
%		recogRate=knncLoo(DS, knncPrm, plotOpt) plots the results if the dimension of the dataset is 2.
%		[recogRate, computed, nearestIndex]=knncLoo(...) also returns the computed class and the nearest index of each data instance.
%
%	Example:
%		DS=prData('iris');
%		DS.input=DS.input(3:4, :);	% Use the last 2 dims for plotting
%		knncPrm.k=1;
%		plotOpt=1;
%		tic
%		[recogRate, computed, nearestIndex] = knncLoo(DS, knncPrm, plotOpt);
%		fprintf('Elapsed time = %g sec\n', toc);
%		fprintf('Recog. rate = %.2f%% for %s dataSet\n', 100*recogRate, DS.dataName);
%
%	See also knncEval, knncTrain.

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19970628, 20040928

if nargin<1, selfdemo; return; end
if nargin<2||isempty(knncPrm), knncPrm.k=1; end
if nargin<3, plotOpt=0; end

[dim, dataNum] = size(DS.input);
nearestIndex = zeros(1, dataNum);
computed = zeros(size(DS.output));
batchSize=round(dataNum/10);
useMex=1;
if useMex	% Use mex file
	for i=1:dataNum
		if rem(i, batchSize)==0, fprintf('%d/%d\n', i, dataNum); end
		nnIndex=knnMex(DS.input(:,i), DS.input, 2, knncPrm.k, i);
		computed(i)=mode(DS.output(nnIndex));
	end
else	% Original M-file implementation
	for i=1:dataNum
		if rem(i, batchSize)==0, fprintf('%d/%d\n', i, dataNum); end
		looData = DS;
		looData.input(:,i) = [];
		looData.output(:,i) = [];
		looData.k = knncPrm.k;
		TS.input=DS.input(:,i);
		TS.output=DS.output(:,i);
		[computed(i), junk, junk, junk, tmp]=knncEval(TS, looData);
		nearestIndex(i) = tmp(1);
		if nearestIndex(i)>=i,
			nearestIndex(i)=nearestIndex(i)+1;
		end
	end
end
hitIndex=find(DS.output==computed);
recogRate=length(hitIndex)/dataNum;

if plotOpt && dim==2
	dsScatterPlot(DS);
	axis image; box on
	missIndex=1:dataNum;
	missIndex(hitIndex)=[];
	% display these points
	for i=1:length(missIndex),
		line(DS.input(1,missIndex(i)), DS.input(2,missIndex(i)), 'marker', 'x', 'color', 'k');
	end
	titleString = sprintf('%d leave-one-out error points denoted by "x".', length(missIndex));
	title(titleString);
	h=findobj(gca, 'type', 'line');
	set(h, 'markersize', 10);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
