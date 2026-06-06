clc;
clear;
close all;

%% Problem 2
% Simulation of full-precision sensor system

m = 0.5;                  % Signal amplitude
S = 0.5;                  % Transmitted signal for simulation
ng = 39;                  % Number of sensors calculated from p1

target_errors = 200;      % Stop simulation after 200 errors
num_errors = 0;           % Error counter
K = 0;                    % Total simulation runs

%% Simulation Loop

while num_errors < target_errors
    
    % Increase simulation run counter
    K = K + 1;
    
    % Generate ng independent Gaussian noise samples
    Z = normrnd(0, 1, [1, ng]);
    
    % Generate sensor observations
    X = S + Z;
    
    % Compute sufficient statistic
    T = mean(X);
    
    % Decision rule
    if T >= 0
        S_hat = 0.5;
    else
        S_hat = -0.5;
    end
    
    % Check if an error occurred
    if S_hat ~= S
        num_errors = num_errors + 1;
    end
end

%% Compute Error Probability

Pe_sim = target_errors / K;
Pe_theory = qfunc(m * sqrt(ng));

%% Display Results

fprintf('\n');
fprintf('-----------------------------------\n');
fprintf('Problem 2 Simulation Results\n');
fprintf('-----------------------------------\n');
fprintf('Number of sensors n_g = %d\n', ng);
fprintf('Target number of errors = %d\n', target_errors);
fprintf('Total number of simulation runs K = %d\n', K);
fprintf('Estimated error probability = 200/K = %.6e\n', Pe_sim);
fprintf('Theoretical error probability = %.6e\n', Pe_theory);
fprintf('-----------------------------------\n');