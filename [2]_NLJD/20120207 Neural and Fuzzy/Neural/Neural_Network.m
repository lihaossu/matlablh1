%%%%Klimis Symeonidis - Msc signal Processing Communications - Surrey Univertsity%%%%%
%%%Perceptron network for hand gesture classification%%%%%
% Turn on echoing of commands inside the script-file.
echo on
% Clear the workspace (all variables).
% clear all
% load perf24
% Clear command window.
clc
% =========================================================
% =========================================================
% CLASSIFICATION WITH A 2-LAYER PERCEPTRON:
% The first layer acts as a non-linear preprocessor for
% the second layer. The second layer is trained as usual.
pause % Strike any key to continue...
clc
% DEFINING THE CLASSIFICATION PROBLEM
% ===================================
% A matrix P defines 24 19-element input (column) vectors:
% There are 3 examples of % each character, 8 characters, so 3 x 8 = 24 input
% patterns.
% A matrix T defines the categories with target (column)
% vectors. There are 3 numerals and 5 characters so, 8 target vectors in total.
pause % Strike any key to continue...
clc
% Open the files with the input vectors.
fid = fopen('train8.txt','rt');
P1 = fscanf(fid,'%f',[19,inf]);
P=P1;
fid = fopen('testA.txt','rt');
TS1 = fscanf(fid,'%f',[19,inf]);
fid = fopen('test0.txt','rt');
TS2 = fscanf(fid,'%f',[19,inf]);
fid = fopen('test5.txt','rt');
TS3 = fscanf(fid,'%f',[19,inf]);
fid = fopen('testL.txt','rt');
TS4 = fscanf(fid,'%f',[19,inf]);
fid = fopen('testV.txt','rt');
TS5 = fscanf(fid,'%f',[19,inf]);
fid = fopen('testW.txt','rt');
TS6 = fscanf(fid,'%f',[19,inf]);
fid = fopen('testH.txt','rt');
TS7 = fscanf(fid,'%f',[19,inf]);
fid = fopen('test1.txt','rt');
TS8 = fscanf(fid,'%f',[19,inf]);
fid = fopen('testGB.txt','rt');
TS9 = fscanf(fid,'%f',[19,inf]);
% Open the file with the target vectors.
fid = fopen('target8.txt','rt');
T = fscanf(fid,'%f',[8,inf]);
%clc
% DEFINE THE PERCEPTRON
% ========================
% P has 19 elements in each column,
% so each neuron in the hidden layer
% needs 19 inputs.
%R1;
% To maximize the chance that the preprocessing layer
% finds a linearly separable representation for the
% input vectors, it needs a lot of neurons.
% After trying a lot of different network architectures,
% it has been found that the optimal number of neurons for
% the hidden layer is 85.
S1 = 85;
% T has 5 elements in each column,
% so 5 neurons are needed.
S2 = 5;
% INITP generates initial weights
% and biases for the network:
% Initialize pre-processing layer.
[W1,b1] = initp(P,S1);
% Initialize learning layer.
[W2,b2] = initp(S1,T);
pause % Strike any key to train the perceptron...
clc
% TRAINING THE PERCEPTRON
% =======================
% TRAINP trains perceptrons to classify input vectors.
% The first layer is used to preprocess the input vectors:

A1 = simup(P,W1,b1);
% TRAINP is then used to train the second layer to
% classify the preprocessed input vectors A1.
% The TP parameter is needed by the TRAINP function
% to define the number of epochs used.
% The first argument is the display frequency and
% the second is the maximum number of epochs.
TP = [1 500];
pause % Strike any key to start the training...
%Delete everything and also reset all figure properties,
%except position, to their default values.
clf reset
%Open a new Figure (graph window), and return
%the handle to the current figure.
figure(gcf)
%Set figure size.
setfsize(600,300);
% Training begins...
[W2,b2,epochs,errors] = trainp(W2,b2,A1,T,TP);
% ...and finishes.
pause % Strike any key to see a plot of errors...
clc
% PLOTTING THE ERROR CURVE
% ========================
% Here the errors are plotted with
% respect to training epochs:
ploterr(errors);
% If the hidden (first) layer preprocessed the original
% non-linearly separable input vectors into new linearly
% separable vectors, then the perceptron will have 0 errors.
% If the error never reached 0, it means a new
% preprocessing layer should be created
% (perhaps with more neurons).
pause % Strike any key to use the classifier...
clc

% USING THE CLASSIFIER
% ====================
% IF the classifier WORKED we can now try to classify
% the input vectors we like using SIMUP. Lets try the
% input vectors that we have used for training.
% Create a menu, so the user can select a test set.
K = MENU('Choose a file resolution','Test A','Test 0','Test 5','Test L','Test V','Test W','Test H','Test 1','Test GB');
% According to the choice use the appropriate variables.
if K == 1
TS = TS1;
elseif K == 2
TS = TS2;
elseif K == 3
TS = TS3;
elseif K == 4
TS = TS4;
elseif K == 5
TS = TS5;
elseif K == 6
TS = TS6;
elseif K == 7
TS = TS7;
elseif K == 8
TS = TS8;
elseif K == 9
TS = TS9;
else
P = 0;
R1 = 0;
end
a1 = simup(TS,W1,b1); % Preprocess the vector
a2 = simup(a1,W2,b2) % Classify the vector
echo off
disp('End of Hand Gesture Recognition')