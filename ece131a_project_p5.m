clc;
clear;
close all;

%% Problem 5
% Simulation of the binary sensor system

m = 0.5;
S = 0.5;

% Number of binary sensors from Problem 4
nb = 61;

% Stop after observing 200 errors
target_errors = 200;

% Initialize counters
num_errors = 0;
K = 0;

%% Simulation Loop

while num_errors < target_errors
    
    % Count this simulation run
    K = K + 1;
    
    % Generate Gaussian noise samples
    Z = normrnd(0, 1, [1, nb]);
    
    % Generate observations
    X = S + Z;
    
    % Convert observations to binary sensor outputs
    B = X >= 0;
    
    % Compute sufficient statistic
    U = sum(B);
    
    % Majority-vote decision rule
    if U >= 31
        S_hat = 0.5;
    else
        S_hat = -0.5;
    end
    
    % Check whether an error occurred
    if S_hat ~= S
        num_errors = num_errors + 1;
    end
end

%% Compute results

Pe_sim = target_errors / K;

% Theoretical probability from Problem 4
p = normcdf(0.5);
Pe_theory = binocdf(30, nb, p);

%% Display results

fprintf('\n');
fprintf('-----------------------------------\n');
fprintf('Problem 5 Simulation Results\n');
fprintf('-----------------------------------\n');
fprintf('Number of binary sensors n_b = %d\n', nb);
fprintf('Target number of errors = %d\n', target_errors);
fprintf('Total number of simulation runs K = %d\n', K);
fprintf('Estimated error probability = 200/K = %.6e\n', Pe_sim);
fprintf('Theoretical error probability = %.6e\n', Pe_theory);
fprintf('-----------------------------------\n');