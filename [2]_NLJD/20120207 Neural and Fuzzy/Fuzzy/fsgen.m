function M = fsgen(nfs,x)
% Usage: M = fsgen(nfs,x)
% fsgen.m: generate fuzzy sets on support vector x
% nfs: number of fuzzy sets
% x: row vector gives coordinates of univ of discourse
% M is nfs by length(x)
% assume triangular, equal side shape for each fuzzyset
% except half triangles on each side
% copyright(c) 1994-1997 by Yu Hen Hu
% last update: 11/25/97

n=length(x);
slen=x(n)-x(1); % length of universe of discourse
smin=x(1);  
x=(x-smin)/slen; % normalize x to range from 0 to 1
d=1/(nfs-1);  % increment within [0 1]

M=[(1-x/d).*[x<=d]];
if nfs>2,
 for i=2:nfs-1,
   M=[M;(x/d-(i-2)).*[(i-2)*d<= x & x < (i-1)*d] + ...
        (i-x/d).*[(i-1)*d<= x& x <= i*d]];
 end
end
M=[M;(x/d-(nfs-2)).*[1-d < x]];

