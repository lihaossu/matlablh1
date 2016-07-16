%% Initialize the Coordination of Training Data (Data Generator)
N = 30;
X = 500 * abs(randn(N,1));
Y = 500 * abs(randn(N,1));
Measured = [X Y];
plot(X,Y,'o')
% axis([0 1000 0 1000])
grid on;

for i=1:N
    if Measured(i,1) <= Measured(i,2)
        Symmetric_Estimation(i) = 0; % NLJD
    elseif Measured(i,1) > Measured(i,2)
        Symmetric_Estimation(i) = 1; % Metal
    end;
end;

sum(Symmetric_Estimation)

NLJD_Index = find(Symmetric_Estimation == 0);
Metal_Index = find(Symmetric_Estimation == 1);


save sample_dense.mat Measured NLJD_Index Metal_Index