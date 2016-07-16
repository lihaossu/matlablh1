function y=defuz(out,support)
% Usage: y=defuz(out,support)
% calculate centroid of output of the fuzzy set out defined
%  on the discrete support "support"
% out and support should have the same dimension
%
% copyright (C) 1996 by Yu Hen Hu
% created 12/5/96

y=sum(out.*support)/sum(out);
