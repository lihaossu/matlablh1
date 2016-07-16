function [center, U] = FCM_NLJD(Database)

data_n = size(Database, 1);
cluster_n = 2;
default_options = [2;	% exponent for the partition matrix U
    10;	% max. number of iteration
    1;	% min. amount of improvement
    0];	% info display during iteration

    options = default_options;

expo = options(1);		% Exponent for U
max_iter = options(2);		% Max. iteration
min_impro = options(3);		% Min. improvement
display = options(4);		% Display info or not

obj_fcn = zeros(max_iter, 1);	% Array for objective function

U = initfcm(cluster_n, data_n);			% Initial fuzzy partition
% Main loop
for i = 1:max_iter,
    
    [U, center, obj_fcn(i)] = stepfcm(Database, U, cluster_n, expo);
    if display,
        fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
    end
    % check termination condition
    if i > 1,
        if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
    end
end