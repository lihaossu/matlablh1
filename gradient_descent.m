function [xopt,fopt, niter,gnorm,dx] = gradient_descent(varargin)
if nargin==0
    x0=[3 3]';
elseif nargin==1
    x0=varargin(1);
else
    error('Incorrect number of input arguments.')
end
% termination tolerance
tol = 1e-6;

% maximum number of allow iterations
maxiter = 1000;

% minimum allowed perturbation
dxmin = 1e-6;

% step size

