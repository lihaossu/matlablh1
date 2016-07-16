% ruledc.m
% (C) 1996-2001 by Yu Hen Hu
%
% the inference rule set with one input variable, one output variable
% Last Modification: 12/1/97
% Last modified: 11/25/2001

d = [5 5]; % 5 input adj for Input fuzzy var ang,
           % 5 output adj for output fuzzy var dz
%              ang         &?          dz           weight
%       LN  SN  ZO  SP  LP     LN  SN  ZO  SP  LP
rule=[   1   0   0   0   0  1   1   0   0   0   0   1; % if ang is LN then dz is LN
         0   1   0   0   0  1   0   1   0   0   0   1; % if ang is SN then dz is SN
         0   0   1   0   0  1   0   0   1   0   0   1; % if ang is ZO then dz is ZO
         0   0   0   1   0  1   0   0   0   1   0   1; % if ang is SP then dz is SP
         0   0   0   0   1  1   0   0   0   0   1   1]; % if ang is LP then dz is LP

