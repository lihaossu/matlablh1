function [new_output,W1,W2,RMS,LR]=backprp(x,t,W1,W2,RMS_Goal,lr,maxcycles)
[inputs,patterns1]=size(x);
[outputs,patterns]=size(t);
[hidden,inputs1]=size(W1);
[outputs1,hidden1]=size(W2);
if outputs1 ~= outputs
    error('Check the W1 dimension and purpose vector')
end
if inputs1 ~= inputs+1
    error('Check the W2 dimension and input vector')
end
if hidden1 ~= hidden+1
    error('W1 is not equal to W2')
end
terms=outputs*patterns; % Errors
RMS=zeros(1,maxcycles); % Setup the Output Vector
LR=zeros(1,maxcycles);
X=[ones(1,patterns); x];
h=logistic(W1*X); % Hidden Layer's output
H=[ones(1,patterns);h]; % Output Layer's input
output=linear(W2*H); % Output Vector
e=t-output; % Output Error
RMS(1)=sqrt(sum(sum(e.^2))/terms); % RMS Error
fprintf('Epoch=1, lr=%f, RMS Error=%f?n',lr,RMS(1))
for i=2:maxcycles
    delta2=e;
    del_W2=lr*delta2*H';
    delta1=h.*(1-h).*(W2(:,2:hidden+1)'*delta2);
    del_W1=lr*delta1*X';
    new_W1=W1+del_W1; % Update the Hidden Layer's Weight
    new_W2=W2+del_W2; % Update the Output Layer's Weight
    new_h=logistic(new_W1*X);
    new_H=[ones(1,patterns);new_h]; % Hidden Layer's output
    new_output=linear(new_W2*new_H);
    new_e=t-new_output; % Output Error
    RMS(i)=sqrt(sum(sum(new_e.^2))/terms); % RMS Error
    if RMS(i)<RMS(i-1) % Increasing the Learning Rate
        W1=new_W1;
        W2=new_W2;
        e=new_e;
        h=new_h;
        H=new_H;
        lr=lr*1.1;
    else lr=lr*.5; % Decreasing the Learning Rate
    end
    LR(i)=lr;
    if RMS(i)<RMS_Goal; break;
    end
    if rem(i,50) ==0
        fprintf('Epoch=%i,lr=%f,RMS Error=%f?n',i,LR(i),RMS(i));
    end
end
RMS=nonzeros(RMS);
LR=nonzeros(LR);