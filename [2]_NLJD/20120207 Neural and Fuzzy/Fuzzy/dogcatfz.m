% dogcatfz.m - fuzzy control for dog-cat problem
%
% copyright (C) 1996 by Yu Hen Hu
% created: 12/6/96
% last modified: 11/25/2001
%
clear all
clf
echo on
% 1. Define fuzzy sets (fuzzy matrix)
M=[1 .67 .33  0  0   0  0  0   0  0  0   0  0;   % LN fuzzy set
   0 .33 .67  1 .67 .33 0  0   0  0  0   0  0;   % SN fuzzy set
   0  0   0   0 .33 .67 1 .67 .33 0  0   0  0;   % ZO fuzzy set
   0  0   0   0  0   0  0 .33 .67 1 .67 .33 0;   % SP fuzzy set
   0  0   0   0  0   0  0  0   0  0 .33 .67 1];   % LP fuzzy set

[nadj,lensp]=size(M);
ang_range=[-180 180]; 
dangs=(ang_range(2)-ang_range(1))/(lensp-1);
sang = [ang_range(1):dangs:ang_range(2)]; % support for ang
K=1/6;   % dz = k*ang --proportional control
sdz=K*sang;

figure(1),clf
subplot(211),plot(sang,M');ylabel('mu(ang)'),axis([min(sang) max(sang) 0 1])
subplot(212),plot(sdz,M'); ylabel('mu(dz)')
pause

% 2. Initiation
terminate=0; t=0;
tmax=input('Max # of iterations is (default = 99) = '); 
if isempty(tmax), tmax=99; end

v=1;   % cat speed
disp(['The cat runs at a speed of  ' num2str(v) ' m/s,']);
w=input('Enter the dog speed (default = v*1.2) = ');
if isempty(w), w=1.2*v; end

xdog(1)=0; ydog(1)=0;  % initial position of dog
xcat(1)=1; ycat(1)=10; % initial position of cat
azi(1) = 0;   % initially the dog is facing north
dz(1) = 0;

ruledc;  % initialization of the rule set.
% it will define two variables: d and rule
% d - a row vector, with 2 elements. d(1): # of fuzzy sets defined
%  on the input variable, d(2): # of fuzzy sets defined on the output
%  variable.
% rule: a matrix. Each row is a rule. Each row contains d(1) + d(2)
%  elements.  The first d(1) elements specifying which fuzzy set is 
%  used as the anticedent part. The last d(2) elements specifying which
% fuzzy sets in the output control variable are used.
echo off
% press a key to begin simulation
pause
dang(1)=0;

figure(2),
while terminate==0,
t=t+1;
% based on current dog and cat coordinate, figure out the
% relative angle between dog's pursuit direction, and cat's
% current position
% angle varies from -180 to 180 degrees
% absolute angle between dog and cat:  

ang(t) = atan2(ycat(t)-ydog(t),xcat(t)-xdog(t))*180/pi-azi(t);
if ang(t) > 180,  % make sure -pi <= ang(t) <= pi
   ang(t)=ang(t)-360;
elseif ang(t) < -180,
   ang(t)=ang(t)+360;
end

% fuzzify input variable to FLC: ang
a= fuzify(M,ang(t),sang);

% fuzzy inferencing
out = infer(rule,d,M,1,a);

% defuzzification
dz(t+1)=defuz(out,sdz);

% Plant - find new dog/cat location, relative angle
azi(t+1) = azi(t) + dz(t+1);
if azi(t+1) > 180,  % make sure -pi <= azi <= pi
    azi(t+1) = azi(t+1)-360;
elseif azi(t+1) < -180,
   azi(t+1) = azi(t+1)+360;
end
xcat(t+1) = xcat(t) + v;       ycat(t+1) = ycat(t);
xdog(t+1) = xdog(t) + w*cos(azi(t+1)*pi/180);
ydog(t+1) = ydog(t) + w*sin(azi(t+1)*pi/180);

% termination criterion
if abs(xcat(t+1)-xdog(t+1))+abs(ycat(t+1)-ydog(t+1)) <=.1 | t >=tmax,
   terminate=1;
end

% display results every five iterations, or upon termination
if rem(t,5)==0 | terminate==1, 
   subplot(411),plot(xcat,ycat,'+',xdog,ydog,'o'); 
   %legend('Cat','Dog'),
   xlabel('x'),ylabel('y')
   subplot(412),plot(ang),ylabel('angle'),xlabel('time')
   subplot(413),plot(azi),ylabel('azi'),xlabel('time')
   subplot(414),plot(dz),ylabel('dzi'),xlabel('time')
   drawnow
end
pause(0.2)
end % t-loop
