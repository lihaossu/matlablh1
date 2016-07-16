function out = dsFeaVsIndexPlot(DS)
%dsFeaVsIndexPlot: Plot of feature vs. data index
%
%	Usage:
%		out = dsFeaVsIndexPlot(DS)
%
%	Description:
%		out = dsFeaVsIndexPlot(DS) plot featuers vs. data index.
%
%	Example:
%		DS=prData('iris');
%		dsFeaVsIndexPlot(DS);
%
%	See also dsFeaVsIndexPlot.

%	Category: Dataset visualization
%	Roger Jang, 20041209

if nargin<1, selfdemo; return, end

[featureNum, dataNum]=size(DS.input);
distinctClass = elementCount(DS.output);
classNum = length(distinctClass);
plotNum = featureNum;
side = ceil(sqrt(plotNum));
side1=side; side2=side;
if plotNum<side*(side-1)
	side1=side-1;
end
k = 1;
for i = 1:side1
	for j = 1:side2
		if k <= plotNum,
			subplot(side1, side2, k);
			for p=1:classNum
				index=find(DS.output==distinctClass(p));
				line(index, DS.input(k,index), 'marker', '.', 'lineStyle', 'none', 'color', getColor(p));
			end
			box on; axis([-inf inf -inf inf]);
			xlabel('Data index');
			if isfield(DS, 'inputName')
				ylabel(['x', num2str(k), ': ', DS.inputName{k}]);
			else
				ylabel(['x', num2str(k)]);
			end
			k = k+1;
		end
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
