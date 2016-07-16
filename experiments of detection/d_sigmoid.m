function [ output_args ] = d_sigmoid( input_args )
%D_SIGMOID Summary of this function goes here
%   Detailed explanation goes here
    
% y = d_hyperb (x)
% differentiation of hyperbolic function
% x - input data
% y - output data

%%%% Author: 
%%%% ECE, McMaster University
%%%% yxue@grads.mcmaster.ca; yangl7@psychology.mcmaster.ca
%%%% May 11, 2006
%%%% This is a joint work by Yanbo and Le
%%%% For Project of Course of Dr. Haykin: Neural Network

y = (4*exp(2*x))./((1 + exp(2*x)).^2);

%y = (exp(-x)) ./ ((1+exp(-x)).^2) ;


end

