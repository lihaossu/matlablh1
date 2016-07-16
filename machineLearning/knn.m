function [nnIndex, nnDistance] = knn(mat1, mat2, opt, showPlot)
% knn: KNN (k-nearest-neighbor) search
%
%	Usage:
%		[nnIndex, nnDistance] = knn(mat1, mat2, opt)
%
%	Description:
%		nnIndex = knn(mat1, mat2) returns the results of KNN search, where
%			mat1: the test vectors (represented by columns)
%			mat2: the vectors to be searched (represented by columns)
%			nnIndex: the KNN indices into mat2 (each column is the result of each column in mat1)
%		[nnIndex, nnDistance] = knn(mat1, mat2) returns the KNN indices together with their distances (sorted)
%		[...] = knn(mat1, mat2, opt) takes extra options for KNN search, with
%			opt.method: Method for distance computation
%			opt.nnCount: K in KNN
%			opt.skipIndex: Skip index into mat2 (Used for cross-validation)
%
%	Example:
%		mat1=[2 2; 4 6];	% Columns 3 and 5 of mat2
%		mat2=[3 4 2 3 2; 2 2 4 5 6];
%		opt=knn('defaultOpt');
%		opt.nnCount=3;
%		opt.skipIndex=[5];
%		pairwiseDist=distPairwise(mat1, mat2);
%		[nnIndex, nnDistance]=knn(mat1, mat2, opt);
%		disp(nnIndex), disp(nnDistance), disp(pairwiseDist)
%
%	Category: K-nearest-neighbor classifier
%	Roger Jang, 20151218

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin<2 && ischar(mat1) && strcmpi(mat1, 'defaultOpt')
	nnIndex.method=2;
	nnIndex.nnCount=1;
	nnIndex.skipIndex=[];
	return
end
if nargin<3|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<4, showPlot=0; end

[nnIndex, nnDistance]=knnMex(mat1, mat2, opt.method, opt.nnCount, opt.skipIndex);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
