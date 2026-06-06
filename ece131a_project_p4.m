clc;
clear;
close all;

%% Problem 4
% Comparison of Full-Precision and Binary Sensors

m = 0.5;

% Probability that a binary sensor outputs 1 when S = 0.5
p = normcdf(0.5);

% Full precision sensor values
n_full = 1:100;
Pe_full = qfunc(m .* sqrt(n_full));

% Binary sensor values (odd n only)
n_binary = 1:2:99;
Pe_binary = zeros(size(n_binary));

for k = 1:length(n_binary)

    n = n_binary(k);

    % Error occurs when majority vote is incorrect
    threshold = (n - 1)/2;

    Pe_binary(k) = binocdf(threshold, n, p);

end

% Find smallest odd n such that Pe < 10^-3
target = 1e-3;

index = find(Pe_binary < target, 1, 'first');

nb = n_binary(index);

%% Plot

figure;

semilogy(n_full, Pe_full, 'LineWidth', 2);
hold on;
grid on;

semilogy(n_binary, Pe_binary, 'o-', 'LineWidth', 2);

yline(target,'--','10^{-3}','LineWidth',1.5);

semilogy(nb,Pe_binary(index),'s',...
    'MarkerSize',8,...
    'LineWidth',2);

xlabel('Number of Sensors, n');
ylabel('Probability of Error');
title('Probability of Error for Full-Precision and Binary Sensor Systems');

legend('Full-Precision Sensors',...
       'Binary Sensors',...
       'Threshold = 10^{-3}',...
       sprintf('n_b = %d',nb),...
       'Location','southwest');

%% Results

fprintf('\n');
fprintf('-----------------------------------\n');
fprintf('Problem 4 Results\n');
fprintf('-----------------------------------\n');
fprintf('p = %.6f\n', p);
fprintf('Minimum odd number of binary sensors n_b = %d\n', nb);
fprintf('Probability of error at n_b = %.6e\n', Pe_binary(index));

if index > 1
    fprintf('Probability of error at previous odd n = %d is %.6e\n', ...
        n_binary(index-1), Pe_binary(index-1));
end

fprintf('-----------------------------------\n');