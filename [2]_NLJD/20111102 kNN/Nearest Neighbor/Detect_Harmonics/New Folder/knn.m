% X: matrix of regressors excluding a constant, N by K
% S: N by kn matrix,
%      S(i,:): observation indices for kn nearest neighbors to X(i,:)
% kn: number of nearest neighbors
% svar: X(:,svar) will be used for sorting.
% normal: Normalize each variables if normal==1

function S = knn(X,kn,svar,normal)

[N,K] = size(X);

% Normalizing
if normal == 1
    SD = std(X);
    X = X./repmat(SD,N,1);
end

% Sorting
[SVAR,Is] = sort(X(1:N,svar)); % Is: indices after sorting
clear SVAR;

X = X(Is,1:K);   % Sorted data

% Now, let's find kn nearest neighbors.
% Let S be the set of nearest neighbors for an observation i
% Let ks be the number of observations in S.
% First, we add observation i to S, and set ks = 1.
% Then, for j=1, 2, ...., N, we do the followings.
%       (1) Add i+j to S until ks = kn
%       (2) After we get ks = kn, we check abs( X(i,svar) - X(i+j,svar) )
%       and || X(i,1:K) - X(i+j, 1:K) ||.
%         ==>  if abs( X(i,svar) - X(i+j,svar) ) > maxdi, then forget it.
%              if || X(i,1:K) - X(i+j, 1:K) || < maxdi, then do the
%              replacement.
%       (3) Do the same for i-j.

S = zeros(N,kn);
dist = zeros(N,kn);

for i=1:N
    ks=1;
    S(i,ks)=i;
    
    for j=1:N
        if i+j <= N
            if ks < kn
                S(i,ks+1) = i+j;
                dist(i,ks+1) = sqrt((X(i,1:K)-X(i+j,1:K))*(X(i,1:K)-X(i+j,1:K))');
                [maxdi,M] = max(dist(i,1:ks+1));
                ks = ks+1;
            elseif abs(X(i,svar)-X(i+j,svar)) <= maxdi
                djp = sqrt((X(i,1:K)-X(i+j,1:K))*(X(i,1:K)-X(i+j,1:K))');
                if (djp < maxdi)
                    S(i,M) = i+j;
                    dist(i,M) = djp;
                    [maxdi,M] = max(dist(i,1:kn));
                end
            end
        end
       
        if i-j >= 1
            if ks < kn
                S(i,ks+1) = i-j;
                dist(i,ks+1) = sqrt((X(i,1:K)-X(i-j,1:K))*(X(i,1:K)-X(i-j,1:K))');
                [maxdi,M] = max(dist(i,1:ks+1));
                ks = ks+1;
            elseif abs(X(i,svar)-X(i-j,svar)) <= maxdi
                djn = sqrt((X(i,1:K)-X(i-j,1:K))*(X(i,1:K)-X(i-j,1:K))');
                if (djn < maxdi)
                    S(i,M) = i-j;
                    dist(i,M) = djn;
                    [maxdi,M] = max(dist(i,1:kn));
                end
            end
        end
    end
    % Now, we need to recover the original order
    S(i,1:kn) = Is(S(i,1:kn),1)';
end
[SS,Ir] = sort(S(1:N,1));
clear SS;
S=S(Ir,1:kn);