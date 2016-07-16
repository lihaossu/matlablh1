function out=infer(rule,d,B,product,a1,a2)
% Usage: out=infer(rule,d,B,product,a1,a2)
% rulebase.m
% Input:  fuzzy representation of antecedent variables
% Output: fuzzy representation of consequent variable
% rule: a nrule by (d(1)+d(2)+d(3)+1) rule matrix. 
%  Each row is a rule. Each row consists of 5 parts
%  var1 (1 by d(1)) var2 (1x d(2)) &? (1), output (1 x d(3)), weight
%  The &? column = 1 if var2 is to be ignored for that rule
% d: 1x3 vector specifying # of fuzzy sets (adjetives, linguistic var)
%   defined on each universe of discouse
%   d(1): no fuzzy sets of input 1
%   d(2): no fuzzy sets of input 2 if nargin=6, no fuzzy set of output
%           if only 5 input argument (missing a2)
%   d(3): no fuzzy sets of ouput
%   weight: the weighting of each rule
% B is the output variable fuzzy matrix, each row is a fuzzy set
%  defined on that output variable, # of columns = # of elements in
%  the corresponding discrete support (universe of discourse).
%  is dout by len(support)
% product=1 if Kosko's max-product rule is used.
%        =0 if usual max-min rule is used.
% a1 (a2) is the activation of fuzzy variables 1 (2) and is a row vector
% a1 (a2) has the same dim. d(1)  (d(2)) as that of var1 (var2). 
%   d(3) is the # of fuzzy sets defined on the output variable
% if there are only 5 input argument (missing a2), 
%    only one input variable is used.  there will be no d(2).
% out is the output fuzzy variable after combining all rules.
%
% Copyright (C) by Yu Hen Hu 1996
% Last modify 12/5/96

if nargin==5,
   oneinput=1;  dout=d(2);
else
   oneinput=0;  dout=d(3);
end
[nrule,tr]=size(rule);
[db,nofz]=size(B);  % db=dout, nofz: no of output fuzzy sets

In1=rule(:,1:d(1)).*(ones(nrule,1)*a1); % In1 is nrule by d(1)
A1=max(In1')';   % A1 is nrule by 1
if oneinput==1,  % only one input variable
   ruleact=A1.*rule(:,tr);  
   tmp=diag(ruleact)*rule(:,d(1)+2:tr-1); % tmp is nrule by dout
else  % there is a second input variable
    In2=rule(:,d(1)+1:d(1)+d(2)).*(ones(nrule,1)*a2); % In2 is nrule by d(2)
    A2=max([In2 rule(:,d(1)+d(2)+1)]')'; % A2 is nrule by 1
    % if var2 is not in the rule, the &? bit will be set to 1 
    ruleact=min([A1 A2]')'.*rule(:,tr);
    tmp=diag(ruleact)*rule(:,d(1)+d(2)+2:tr-1); 
      % tmp is nrule by dout
      % is the activation of each rule
end
%figure(2),stem(ruleact);title('rule activation')
act=max(tmp);    % act is 1 by dout: activation of each output fuzzy set
if product==1,
    out=max(diag(act)*B);  % max(tmp) is the activation for each adj of
    % the output variable the * means Kosko's product rule is used.
elseif product==0,
    out=max(min(act'*ones(1,nofz),B));
end
