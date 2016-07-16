%% knn
% KNN (k-nearest-neighbor) search
%% Syntax
% * 		[nnIndex, nnDistance] = knn(mat1, mat2, opt)
%% Description
%
% <html>
% <p>nnIndex = knn(mat1, mat2) returns the results of KNN search, where
% 	<ul>
% 	<li>mat1: the test vectors (represented by columns)
% 	<li>mat2: the vectors to be searched (represented by columns)
% 	<li>nnIndex: the KNN indices into mat2 (each column is the result of each column in mat1)
% 	</ul>
% <p>[nnIndex, nnDistance] = knn(mat1, mat2) returns the KNN indices together with their distances (sorted)
% <p>[...] = knn(mat1, mat2, opt) takes extra options for KNN search, with
% 	<ul>
% 	<li>opt.method: Method for distance computation
% 	<li>opt.nnCount: K in KNN
% 	<li>opt.skipIndex: Skip index into mat2 (Used for cross-validation)
% 	</ul>
% </html>
%% Example
%%
%
mat1=[2 2; 4 6];	% Columns 3 and 5 of mat2
mat2=[3 4 2 3 2; 2 2 4 5 6];
opt=knn('defaultOpt');
opt.nnCount=3;
opt.skipIndex=[5];
pairwiseDist=distPairwise(mat1, mat2);
[nnIndex, nnDistance]=knn(mat1, mat2, opt);
disp(nnIndex), disp(nnDistance), disp(pairwiseDist)
