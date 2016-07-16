clear all; close all; clc;

%% First
Electronic_x = 200; Electronic_y = 500;

%% Second
Metal_x = 500; Metal_y = 700;

%% Average of two point (Metal, Electronic)
Average_Axis = [(Electronic_x+Metal_x)/2 (Electronic_y+Metal_y)/2];

%% Parallel (m=1)
m = 1; % gradient
x = 0:1:1000;

% An equation of first degree (Electronics and Metal)
Electronic = m*(x-Electronic_x) + Electronic_y;
Metal = m*(x-Metal_x) + Metal_y;

% Intersection gradient (New_m) and Line (IL) of two point (Metal, Electronic)
New_m = (Metal_y - Electronic_y) / (Metal_x - Electronic_x);
IL = New_m * (x - Average_Axis(1)) + Average_Axis(2);


% Orthogonal gradient against IL (Intersection Line)
Ort_m = -1 / New_m;
% Orthogonal Line
Orthogonal_Line = Ort_m*(x-Average_Axis(1)) + Average_Axis(2);

%% Plot
plot(Electronic_x,Electronic_y,'bs','LineWidth',5);
hold on;
plot(Metal_x,Metal_y,'ro','LineWidth',5);
hold on;
plot(x,Electronic,'b-')
hold on
plot(x,Metal,'r-')
hold on
plot(x,IL,'g-')
hold on
plot(x,Orthogonal_Line,'c-','LineWidth',2)
 
legend('Electronic','Metal','Electronic (m=1)','Metal (m=1)','Electronic-Metal','Decision Boundary');
grid on;

figPosition = 1;
axis([0 1000 0 1000]);
set(figPosition,'Position', [300, 300, 625, 600]);
hold on

