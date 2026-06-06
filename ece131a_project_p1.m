clc;
clear;
close all;

%% Problem 1
% Distributed Detection in Gaussian Noise
% P(error) = Q(m*sqrt(n))

m = 0.5;              % Signal amplitude
n = 1:100;            % Number of sensors

% Compute probability of error, using qfunc
Pe = qfunc(m*sqrt(n));

% Error threshold (10^-3)
threshold = 1e-3;

% Find smallest n satisfying Pe < 10^-3
ng = find(Pe < threshold, 1, 'first');

%% Create Figure
figure;

semilogy(n, Pe, 'LineWidth', 2); % using semilogy
hold on;
grid on;

% Threshold line
yline(threshold,'--','10^{-3}','LineWidth',1.5);

% Mark ng
semilogy(ng, Pe(ng), 'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 2);

xlabel('Number of Sensors, n');
ylabel('Probability of Error');
title('Probability of Error vs. Number of Sensors (m = 0.5)');

legend('P_e = Q(0.5\sqrt{n})', ...
       'Threshold', ...
       sprintf('n_g = %d',ng), ...
       'Location','southwest');

%% Displaying Results (print)
fprintf('\n');
fprintf('-----------------------------------\n');
fprintf('Problem 1 Results\n');
fprintf('-----------------------------------\n');
fprintf('Signal amplitude m = %.1f\n',m);
fprintf('Required error probability < 10^-3\n');
fprintf('Minimum number of sensors n_g = %d\n',ng);
fprintf('Probability of error at n_g = %.6e\n',Pe(ng));

if ng > 1
    fprintf('Probability of error at n = %d is %.6e\n', ...
        ng-1, Pe(ng-1));
end
fprintf('-----------------------------------\n');