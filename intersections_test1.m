gauss1=rand(5,2);
x1=gauss1(1:5,1);
y1=gauss1(1:5,2);
gauss2=rand(5,2);
x2=gauss2(1:5,1);
y2=gauss2(1:5,2);
n1 = length(x1) - 1;
n2 = length(x2) - 1;
% Determine the conbinations of i and j where the rectangle enclosing the 
% i'th line segment of curve 1 overlaps with the rectangle enclosing the
% j'th line segment of curve 2.
[i,j] = find(repmat(min(x1(1:end-1),x1(2:end)),1,n2) <= ...
    repmat(max(x2(1:end-1),x2(2:end)).',n1,1) & ...
    repmat(max(x1(1:end-1),x1(2:end)),1,n2) >= ...
    repmat(min(x2(1:end-1),x2(2:end)).',n1,1) & ...
    repmat(min(y1(1:end-1),y1(2:end)),1,n2) <= ...
    repmat(max(y2(1:end-1),y2(2:end)).',n1,1) & ...
    repmat(max(y1(1:end-1),y1(2:end)),1,n2) >= ...
    repmat(min(y2(1:end-1),y2(2:end)).',n1,1));
i = reshape(i,[],1);
j = reshape(j,[],1);
% Find segments pairs which have at least one vertex = NaN and remove them.
% This line is a fast way of finding such segment pairs. We take advantage
% of the fact that NaNs propagate through calculations, in particular
% subtraction (in the calculation of dxy1 and dxy2, which we need
% anyway) and addition.
% At the same time we can remove redundant combinations of i and j in the
% case of finding intersections of a line with itself.