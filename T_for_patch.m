clear;clc;close all;
box=[0 20 20 0; 0 0 20 20];
hold on;
h.box= patch(0,0,'b','erasemode','xor'); 
xlim([-10,1000]); ylim([-10,1000])
axis equal
for i = 1: 1000
    xb=box+i;
    set(h.box, 'xdata', xb(1,:), 'ydata', xb(2,:))
    drawnow;
end


% clear;clc;close all;
% box=[0 20 20 0; 0 0 20 20];
% hold on;
% h.box = animatedline('MaximumNumPoints',80,'Color','b');
% xlim([-10,1000]); ylim([-10,1000])
% axis equal
% for i = 1: 1000
%     xb=box+i;
%     addpoints(h.box,xb(1,:),xb(2,:));   
%     drawnow;
% end


% clear; clc; close all;
% box=[0 20 20 0; 0 0 20 20];
% h.box= patch(0,0,'b'); 
% xlim([-10,1000]); ylim([-10,1000]);
% axis equal
% drawnow();
% set(gca, 'xlimmode', 'manual', 'ylimmode', 'manual')
% hold on;
% for i = 1: 1000
%     xb=box+i;
%     set(h.box, 'xdata', xb(1,:), 'ydata', xb(2,:))
%     drawnow;
% end
% box=[0 20 20 0; 0 0 20 20];
% h.box= patch(0,0,'b'); 
% xlim([-10,1000]); ylim([-10,1000]);
% hold on;
% for i = 1: 1000
%     xb=box+i;
%     set(h.box, 'xdata', xb(1,:), 'ydata', xb(2,:))
%     drawnow;
% end