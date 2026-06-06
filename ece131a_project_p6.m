clc;
clear;
close all;

%% Problem 6
% Cost comparison for full-precision and binary sensors
% at multiple probability of error thresholds

m = 0.5;

% Binary sensor probability
p = normcdf(0.5);

% Search range for number of sensors
n_max = 1000;
n_full = 1:n_max;
n_binary = 1:2:n_max;   % odd n only for binary sensors

%% Compute probability of error for full-precision sensors

Pe_full = qfunc(m .* sqrt(n_full));

%% Compute probability of error for binary sensors

Pe_binary = zeros(size(n_binary));

for k = 1:length(n_binary)
    
    n = n_binary(k);
    
    % For odd n, majority vote error when U <= (n-1)/2
    threshold = (n - 1)/2;
    
    Pe_binary(k) = binocdf(threshold, n, p);
    
end

%% Thresholds to test

targets = [1e-3, 1e-4, 1e-5, 1e-6];

fprintf('\n');
fprintf('---------------------------------------------------------------\n');
fprintf('Problem 6 Cost Comparison\n');
fprintf('---------------------------------------------------------------\n');
fprintf('Target Pe\tFull n\tFull Cost\tBinary n\tBinary Cost\tCheaper\n');
fprintf('---------------------------------------------------------------\n');

for j = 1:length(targets)
    
    target = targets(j);
    
    % Find minimum full-precision sensors
    idx_full = find(Pe_full < target, 1, 'first');
    ng = n_full(idx_full);
    
    % Find minimum binary sensors
    idx_binary = find(Pe_binary < target, 1, 'first');
    nb = n_binary(idx_binary);
    
    % Costs
    cost_full = ng;
    cost_binary = 0.5 * nb;
    
    % Determine cheaper system
    if cost_binary < cost_full
        cheaper = 'Binary';
    elseif cost_full < cost_binary
        cheaper = 'Full';
    else
        cheaper = 'Tie';
    end
    
    fprintf('%.0e\t\t%d\t%.1f\t\t%d\t\t%.1f\t\t%s\n', ...
        target, ng, cost_full, nb, cost_binary, cheaper);
end

fprintf('---------------------------------------------------------------\n');

%% Plot cost required versus target probability

full_costs = zeros(size(targets));
binary_costs = zeros(size(targets));

for j = 1:length(targets)
    
    target = targets(j);
    
    idx_full = find(Pe_full < target, 1, 'first');
    idx_binary = find(Pe_binary < target, 1, 'first');
    
    full_costs(j) = n_full(idx_full);
    binary_costs(j) = 0.5 * n_binary(idx_binary);
    
end

figure;
semilogx(targets, full_costs, 'o-', 'LineWidth', 2);
hold on;
grid on;

semilogx(targets, binary_costs, 's-', 'LineWidth', 2);

set(gca, 'XDir', 'reverse');

xlabel('Target Probability of Error');
ylabel('Total Cost');
title('Cost Required to Achieve Different Error Probability Thresholds');

legend('Full-Precision Sensors', ...
       'Binary Sensors', ...
       'Location', 'northwest');