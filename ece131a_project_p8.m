clc;
clear;
close all;

%% Problem 8
% Optimize modified threshold for the 62-sensor binary system

m = 0.5;
nb = 61;                    % 61 standard sensors
p = normcdf(m);             % P(B = 1 | S = 0.5)
q = 1 - p;

%% Reference probabilities

Pe_61 = binocdf(30, 61, p);     % Standard 61 sensors
Pe_63 = binocdf(31, 63, p);     % Standard 63 sensors

%% Search over gamma

gamma_values = -3:0.001:3;
Pe_modified = zeros(size(gamma_values));

for k = 1:length(gamma_values)

    gamma = gamma_values(k);

    % Modified sensor probabilities
    a = 1 - normcdf(gamma - m);   % P(B_mod = 1 | S = 0.5)
    b = 1 - normcdf(gamma + m);   % P(B_mod = 1 | S = -0.5)

    Pe = 0;

    for u = 0:nb

        % Probability of u ones from standard sensors
        P_u_pos = binopdf(u, nb, p);
        P_u_neg = binopdf(u, nb, q);

        % Modified sensor output c = 0
        P_pos_0 = P_u_pos * (1 - a);
        P_neg_0 = P_u_neg * (1 - b);

        % Modified sensor output c = 1
        P_pos_1 = P_u_pos * a;
        P_neg_1 = P_u_neg * b;

        % ML/Bayes error contribution with equal priors
        Pe = Pe + 0.5 * min(P_pos_0, P_neg_0);
        Pe = Pe + 0.5 * min(P_pos_1, P_neg_1);

    end

    Pe_modified(k) = Pe;

end

%% Find optimum

[Pe_opt, idx] = min(Pe_modified);
gamma_opt = gamma_values(idx);

%% Display results

fprintf('\n');
fprintf('-----------------------------------\n');
fprintf('Problem 8 Results\n');
fprintf('-----------------------------------\n');
fprintf('Standard Pe for 61 sensors = %.12e\n', Pe_61);
fprintf('Optimal modified threshold gamma = %.6f\n', gamma_opt);
fprintf('Modified Pe for 62 sensors = %.12e\n', Pe_opt);
fprintf('Standard Pe for 63 sensors = %.12e\n', Pe_63);
fprintf('-----------------------------------\n');

%% Plot

figure;
plot(gamma_values, Pe_modified, 'LineWidth', 2);
hold on;
grid on;

plot(gamma_opt, Pe_opt, 'o', 'MarkerSize', 8, 'LineWidth', 2);
yline(Pe_61, '--', 'Standard 61 Sensors', 'LineWidth', 1.5);
yline(Pe_63, '--', 'Standard 63 Sensors', 'LineWidth', 1.5);

xlabel('Modified Sensor Threshold, gamma');
ylabel('Probability of Error');
title('Problem 8: Modified 62-Sensor Error Probability');

legend('Modified 62-Sensor System', ...
       sprintf('Optimal gamma = %.3f', gamma_opt), ...
       'Standard 61 Sensors', ...
       'Standard 63 Sensors', ...
       'Location', 'best');