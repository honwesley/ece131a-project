clc;
clear;
close all;

%% Problem 8
% Optimize the extra sensor in the even n case
% Use 61 standard binary sensors and 1 modified binary sensor

m = 0.5;

% Number of standard binary sensors from Problem 4
nb = 61;

% Probability for a standard binary sensor when S = 0.5
p = normcdf(m);

% Probability of error for standard 61-sensor system
Pe_61 = binocdf((nb - 1)/2, nb, p);

% Probability of error for standard 63-sensor system
Pe_63 = binocdf((nb + 1)/2, nb + 2, p);

%% Search over possible threshold values gamma

gamma_values = -3:0.001:3;
Pe_modified = zeros(size(gamma_values));

for k = 1:length(gamma_values)
    gamma = gamma_values(k);
    Pe_modified(k) = modified_error_probability(gamma, nb, m, p);
end

%% Find optimal gamma

[Pe_opt, index] = min(Pe_modified);
gamma_opt = gamma_values(index);

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

%% Plot probability of error versus gamma

figure;
plot(gamma_values, Pe_modified, 'LineWidth', 2);
hold on;
grid on;

plot(gamma_opt, Pe_opt, 'o', 'MarkerSize', 8, 'LineWidth', 2);
yline(Pe_61, '--', 'Standard 61 Sensors', 'LineWidth', 1.5);
yline(Pe_63, '--', 'Standard 63 Sensors', 'LineWidth', 1.5);

xlabel('Modified Sensor Threshold, \gamma');
ylabel('Probability of Error');
title('Probability of Error vs. Modified Sensor Threshold');

legend('Modified 62-Sensor System', ...
       sprintf('\\gamma_{opt} = %.3f', gamma_opt), ...
       'Standard 61 Sensors', ...
       'Standard 63 Sensors', ...
       'Location', 'best');

%% Local function

function Pe = modified_error_probability(gamma, nb, m, p)

    % nb standard sensors and 1 modified sensor
    % Standard sensors use threshold 0
    % Modified sensor uses threshold gamma

    q = 1 - p;

    % Modified sensor probabilities under each hypothesis
    a = 1 - normcdf(gamma - m);   % P(B_mod = 1 | S = 0.5)
    b = 1 - normcdf(gamma + m);   % P(B_mod = 1 | S = -0.5)

    Pe = 0;

    % u = number of ones from the nb standard sensors
    for u = 0:nb

        % Probability of u ones under S = 0.5
        P_u_pos = nchoosek(nb,u) * p^u * q^(nb-u);

        % Probability of u ones under S = -0.5
        P_u_neg = nchoosek(nb,u) * q^u * p^(nb-u);

        % c = output of modified sensor, either 0 or 1
        for c = 0:1

            if c == 1
                P_c_pos = a;
                P_c_neg = b;
            else
                P_c_pos = 1 - a;
                P_c_neg = 1 - b;
            end

            % Joint probabilities under each hypothesis
            P_pos = P_u_pos * P_c_pos;
            P_neg = P_u_neg * P_c_neg;

            % Equal priors: Bayes error contribution is min likelihood
            Pe = Pe + 0.5 * min(P_pos, P_neg);

        end
    end
end