%%%%%%%% 
%Start of code% 
%%%%%%%% 
 
% 
%Initialize the input and target vectors 
% 
p = zeros(16,20001); 
t = zeros(26,20001); 
 
% 
%Fill the input and training vectors from the dataset provided 
% 
for i=2:20001 
    for k=1:16 
        p(k,i-1) = data(i,k); 
    end 
    t(data(i,17),i-1) = 1; 
end 
 
net = newff(minmax(p),[21 26],{'logsig' 'logsig'},'traingdm'); 
 
y1 = sim(net,p); 
 
net.trainParam.epochs = 200; 
net.trainParam.show = 1; 
net.trainParam.goal = 0.1; 
net.trainParam.lr = 0.8; 
net.trainParam.mc = 0.2; 
net.divideFcn = 'dividerand'; 
net.divideParam.trainRatio = 0.7; 
net.divideParam.testRatio = 0.2; 
net.divideParam.valRatio = 0.1; 
 
%[pn,ps] = mapminmax(p); 
%[tn,ts] = mapminmax(t); 
 
net = init(net); 
[net,tr] = train(net,p,t); 
 
y2 = sim(net,pn); 
 
%%%%%%%% 
%End of code% 
%%%%%%%% 
