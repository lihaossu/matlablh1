function a= fuzify(M,xstar,support)
% Usage: a= fuzify(M,xstar,support)
% rule activation strength evaluation
% given an input xstar, return activation vector a
% M is the fuzzy set matrix defined on the same universe
%  of discourse. Each row of M is a fuzzy set (adjative)
%  each column of M is a particular value in the UoD.
%  here discrete support is assumed and the total number of
%  elements in the support is the same as the # of columns
%  in M
% support is the vector representing elements in the support.
% If xstar falls outside the range of support, an error is reported
% If xstar falls between two elements of supports, a linear 
%   interpolation is performed.
% a is a row vector with the same dimension as # of rows in M
%
% Copyright (C) 1996 by Yu hen Hu
% Last modification: 12/5/96

n=length(support);
[m1,n1]=size(M);
if n~=n1,
  error(' column # of M not equal # elements in support, abort')
end
if xstar < support(1) 
   a=M(:,1)';
elseif xstar > support(n),
   a=M(:,n1)';
elseif support(1) <= xstar <= support(n),
   ml=max(find(support<=xstar));
   if xstar==support(ml), % xstar is one member of support
     a=M(:,ml)';
   else % use interpolation
     alpha=(xstar-support(ml))/(support(ml+1)-support(ml));
     a=alpha*M(:,ml+1)'+(1-alpha)*M(:,ml)';
   end
end
