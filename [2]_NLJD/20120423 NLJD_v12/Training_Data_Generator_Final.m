clear all; close all; clc;

%%
k = 3:4:51;
knn_simulation_no = 10;
frame = 10;

%% Asymmetric
Metal_x = 400;
Metal_y = 100;

Electronic_x = 200;
Electronic_y = 900;

%% Symmetric
% Metal_x = 700;
% Metal_y = 300;
% 
% Electronic_x = 300;
% Electronic_y = 700;

%% Parameter
Standard_Training = 50;
Standard_Measure = 30;
Standard_Noise = 2;
Data_Number = 50;
Fuzzy_Data = 1000;

%% Dummy
Fairness_Estimation = zeros(1,knn_simulation_no);
Symmetric_Estimation = zeros(1,knn_simulation_no);
kNN_Class = zeros(1,knn_simulation_no);
fuzzy_Class = zeros(1,knn_simulation_no);

Err_Fairness_Symmetric = zeros(1,knn_simulation_no);
Err_kNN_Class_Symmetric = zeros(1,knn_simulation_no);
Err_fuzzy_Class_Symmetric = zeros(1,knn_simulation_no);
Err_kNN_Class_Fairness = zeros(1,knn_simulation_no);
Err_fuzzy_Class_Fairness = zeros(1,knn_simulation_no);
Err_kNN_Fuzzy = zeros(1,knn_simulation_no);

Acc_Fairness_Symmetric = zeros(1,frame);
Acc_kNN_Class_Symmetric = zeros(1,frame);
Acc_fuzzy_Class_Symmetric = zeros(1,frame);
Acc_kNN_Class_Fairness = zeros(1,frame);
Acc_fuzzy_Class_Fairness = zeros(1,frame);
Acc_kNN_Fuzzy = zeros(1,frame);

Prob_Fairness_Symmetric = zeros(1,length(k));
Prob_kNN_Class_Symmetric = zeros(1,length(k));
Prob_fuzzy_Class_Symmetric = zeros(1,length(k));
Prob_kNN_Class_Fairness = zeros(1,length(k));
Prob_fuzzy_Class_Fairness = zeros(1,length(k));
Prob_kNN_Fuzzy = zeros(1,length(k));

%%
progressbar;
for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
            Metal = [ceil(Metal_x+Standard_Training*randn(Data_Number,1))...
                ceil(Metal_y+Standard_Training*randn(Data_Number,1))];
            NLJ = [ceil(Electronic_x+Standard_Training*randn(Data_Number,1))...
                ceil(Electronic_y+Standard_Training*randn(Data_Number,1))];
            
            %         %% Class1 Plot
            %                                     for idx_Class1 = 1:size(NLJ,1)
            %                                         plot(NLJ(idx_Class1,1),NLJ(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',3);
            %                                         hold on;
            %                                     end;
            %
            %                                     %% Class2 Plot
            %                                     for idx_Class2 = 1:size(Metal,1)
            %                                         plot(Metal(idx_Class2,1),Metal(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',3);
            %                                         hold on;
            %                                     end;
            %                                     %
            %                             plot(Measured(1),Measured(2),'go','LineWidth',2,'MarkerSize',3);
            %
            %                         xlabel('Third Harmonics');
            %                         ylabel('Second Harmonics');
            %
            
            Class1 = [NLJ zeros(length(NLJ),1)];
            Class2 = [Metal ones(length(Metal),1)];
            
            %             axis([0 1000 0 1000])
            %             grid on
            
            A = ceil(sum(Class1(:,1:2))/length(Class1));
            B = ceil(sum(Class2(:,1:2))/length(Class2));
            C = ceil(A+B)/2;
            
            
            %% Faireness D/L
            xv11 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];
            yv11 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];
            
            % Symmetric DL
            xv00 = [0; C(1)+C(2); C(1)+C(2); 0];
            yv00 = [0; C(1)+C(2); C(1)+C(2); 0];
            
            %% Fuzzy Logic
            % Generate Database for Fuzzy
            Measured_rand = repmat(C,Fuzzy_Data,1) + 100.*randn(Fuzzy_Data,2);
            Database = [Class1(:,1:2); Class2(:,1:2); Measured_rand];
            
            % Execute Fuzzy
            [center,U,objFcn] = fcm_1(Database,2);
            maxU = max(U);
            index1 = find(U(1,:) == maxU);
            index2 = find(U(2,:) == maxU);
            
            % Make a Cluster
            if Database(index1,1) > Database(index1,2) % NLJD
                fuzzy_cluster1 = Database(index2,1:2);
                fuzzy_cluster2 = Database(index1,1:2);
            elseif Database(index1,1) <= Database(index1,2) % NLJD
                fuzzy_cluster1 = Database(index1,1:2);
                fuzzy_cluster2 = Database(index2,1:2);
            end;
            
            % Figure for one time _ Fuzzy
            %                                 plot(Database(:,1), Database(:,2),'o');
            %                                 hold on;
            %                                 line(fuzzy_cluster1(:,1),fuzzy_cluster1(:,2),'marker','*','color','g');
            %                                 line(fuzzy_cluster2(:,1),fuzzy_cluster2(:,2),'marker','*','color','r');
            %                                 plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
            %                                 hold off;
            %                                 grid on;
            %
            %             Measured = 1000*rand(1,2);
            Measured = ceil(C+Standard_Measure*randn(1,2));
            Measured_Noise = Measured + ceil(Standard_Noise*randn(1,2));
            
            if Measured(1) <= Measured(2)
                Symmetric_Estimation = 1; % NLJD
            elseif Measured(1) > Measured(2)
                Symmetric_Estimation = 0; % Metal
            end;
            
            % Fairness DL
            rd = Measured(1); nd = Measured(2);
            in11 = inpolygon(nd,rd,xv11,yv11);
            if in11 == 0
                Fairness_Estimation = 1; % NLJD
            elseif in11 == 1
                Fairness_Estimation = 0; % Metal
            end;
            
            % Fuzzy DL
            Fuzzy_Estimation = kNN(k(length(k)),Measured,fuzzy_cluster1,fuzzy_cluster2);
            
            % kNN
            kNN_Estimation = kNN(k(idx_k),Measured_Noise,Class1(:,1:2),Class2(:,1:2));
            
            Err(idx_simulation) = xor(Fuzzy_Estimation,kNN_Estimation);
            
            % Progress Bar
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
        end;
        Err_frame(idx_frame) = sum(Err);
        
    end;
    Acc(idx_k) = sum(Err_frame);
    
end;
Prob = Acc / knn_simulation_no / frame * 100;
bar(k,Prob);
axis([0 54 0 100])
grid on

figure
%% Class1 Plot
for idx_Class1 = 1:size(NLJ,1)
    plot(NLJ(idx_Class1,1),NLJ(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',3);
    hold on;
end;

%% Class2 Plot
for idx_Class2 = 1:size(Metal,1)
    plot(Metal(idx_Class2,1),Metal(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',3);
    hold on;
end;
%
plot(Measured(1),Measured(2),'go','LineWidth',2,'MarkerSize',3);

xlabel('Third Harmonics');
ylabel('Second Harmonics');
hold on;
grid on;
axis([0 1000 0 1000])
%% Plot Fairness
% plot(yv11,xv11,'color','r','LineWidth',2)
% hold on;
%% Plot Symmetric
% plot(xv00,yv00,'b:','LineWidth',2)
% grid on;
% axis([C(1)-C(2) C(1)+C(2) C(2)-C(2) C(2)+C(2)])
% hold on;
%% Plot Fuzzy
% plot(Database(:,1), Database(:,2),'o');
% hold on;
% line(fuzzy_cluster1(:,1),fuzzy_cluster1(:,2),'marker','*','color','g');
% line(fuzzy_cluster2(:,1),fuzzy_cluster2(:,2),'marker','*','color','r');
% plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
% hold off;
% grid on;