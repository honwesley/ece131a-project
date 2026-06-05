clc;
clear;
close all;

% ECE 131A Extra Credit Project
% Problem 1
% Distributed Detection in Gaussian Noise

% Given signal amplitude
m = 0.5;

% Number of sensors from 1 to 100
n = 1:100;

% Probability of error formula:
% Pe = P(S_hat ~= S) = Q(m*sqrt(n))
Pe = qfunc(m .* sqrt(n));

% Plot probability of error using semilogy
figure;
semilogy(n, Pe, 'LineWidth', 2);
grid on;
hold on;

% Plotting the threshold line Pe = 10^-3
threshold = 1e-3;
yline(threshold, '--', 'P_e = 10^{-3}', 'LineWidth', 1.5);

% Find the smallest n such that Pe < 10^-3
ng = find(Pe < threshold, 1, 'first');

% Mark first valid point
semilogy(ng, Pe(ng), 'o', 'MarkerSize', 8, 'LineWidth', 2);

% Labeling the graph
xlabel('Number of sensors n');
ylabel('Probability of Error P(\hat{S} \neq S)');
title('Probability of Error vs. Number of Sensors for m = 0.5');

% Legend
legend('P_e = Q(0.5\sqrt{n})', 'Threshold = 10^{-3}', ...
       'First n below threshold', 'Location', 'southwest');

% Print results in Command Window
fprintf('Problem 1 Results:\n');
fprintf('m = %.2f\n', m);
fprintf('Smallest number of sensors needed: n_g = %d\n', ng);
fprintf('P_error at n_g = %d is %.6e\n', ng, Pe(ng));
fprintf('P_error at n_g - 1 = %d is %.6e\n', ng-1, Pe(ng-1));