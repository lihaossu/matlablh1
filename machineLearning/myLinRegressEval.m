function [inSideResult, looResult, inR2, outR2, model] = myLinRegressEval(feaMat, targetVal, usePca, plotOpt)
% input params
%       feaMat: feature, each column is an observation
%       targetVal: groundtruth
%       usePca: 1 for yes, other for no
%       plotOpt: display inside-test model, 0 for no, other for yes
%       NOTE: when 'feaMat' is a structure containing 'input' and 'output',
%             the other params are ignored or set to be 'no'.
% output params
%       inSideResult/looResult: result of inside test or LOO
%       inR2/outR2: r-square of inside test or LOO
%       model: model of inside test
%       NOTE: when when 'feaMat' is a structure,
%             'inSideResult' means r-square of LOO, and other output params
%             should be ignored.

if(nargin==0)
    selfdemo;
    return;
end

% ==== for inputSelect，第一個參數就是整個 DS
if(isstruct(feaMat))
    TMP = feaMat;
    feaMat = TMP.input;
    targetVal = TMP.output;
    usePca = 0;
    plotOpt = 0;
else
    if(nargin==2)
        usePca = 0;
        plotOpt = 0;
    elseif(nargin==3)
        plotOpt = 0;
    end
end

dataNum = size(feaMat,2);
looResult = zeros(1, dataNum);

% ==== inside test
%fprintf('processing inside...\n');
if(usePca==1)
    A = [ones(dataNum,1) pca(feaMat-mean(feaMat, 2)*ones(1, dataNum))'];
else
    A = [ones(dataNum,1) feaMat'];
end
b = targetVal';
x = A\b;
inSideResult = (A*x)';
model = x;
% 範圍限制
inSideResult(inSideResult>max(targetVal)) = max(targetVal);
inSideResult(inSideResult<min(targetVal)) = min(targetVal);
if(plotOpt)
    disp(x);
end
inR2 = myRsquare(targetVal/10, inSideResult/10);

for i = 1:dataNum
    %fprintf('processing outdide %d/%d...\n', i, dataNum);
    if(usePca==1)
        data1 = feaMat(:,[1:i-1 i+1:end]);
        m = mean(data1, 2);
        [data2, eigVec] = pca(data1-mean(data1, 2)*ones(1, dataNum-1));
        A = [ones(dataNum-1,1) data2'];
    else
        A = [ones(dataNum-1,1) feaMat(:,[1:i-1 i+1:end])'];
    end
    b = targetVal([1:i-1 i+1:end])';
    x = A\b;
    if(usePca==1)
        vec = eigVec'*(feaMat(:,i)-m);
        looResult(i) = [1 vec']*x;
    else
        looResult(i) = [1 feaMat(:,i)']*x;
    end
    if(looResult(i)>max(b))
        looResult(i) = max(b);
    elseif(looResult(i)<min(b))
        looResult(i) = min(b);
    end
end
outR2 = myRsquare(targetVal/10, looResult/10);

if(exist('TMP','var')) % for inputSelect
    inSideResult = outR2;
end

function selfdemo
DS.input = rand(2,10);
DS.output = rand(1,10);
rsquare = myLinRegressEval(DS);
fprintf('rsquare: %f\n', rsquare);
