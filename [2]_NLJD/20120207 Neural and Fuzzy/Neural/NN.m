hidden=5;
x=P1;
tt=T1;
[inputs,patterns1]=size(x);
[outputs,patterns]=size(tt);
if patterns1 ~= patterns
    error('Check your input pattern and output pattern')
end
fprintf('?n Network Status: ?n?n');
fprintf('Input Neuron : %0.f ?n',inputs);
fprintf('Hidden Neuron : %0.f ?n',hidden);
fprintf('Output Neuron : %0.f ?n',outputs);
fprintf('Tranining : %0.f ?n?n',patterns);


% Initiate Weight Vector
W1=0.5*randn(hidden,inputs+1); % Weight (between Input and Hidden)
W2=0.5*randn(outputs,hidden+1); % Weight (between Hidden and Output)

% Make a Neural Network and Tranining
[new_output W1 W2 RMS LR]=backprp(x,tt,W1,W2,RMS_Goal,lr,maxcycles);

% Tranining Error
subplot(2,1,1);
semilogy(RMS);
title('BP Training Error');
ylabel('RMS Error')

subplot(2,1,2);
plot(LR)
ylabel('Learning Rate')
xlabel('Iteration');

% Failure
cycles=length(RMS);
if cycles == maxcycles
    fprintf('?n?n *** Stop the BP Training, Failure!');
    fprintf('?n*** RMS = %e ?n?n',min(RMS))
else
    
    % Success
    fprintf('?n*** Stop the BP after %0.f epoch! ***',cycles)
    fprintf('?n*** RMS = %e ?n?n',min(RMS))
end
