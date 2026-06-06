clc;
clear;
close all;

%% Problem 7
% Verify that P_e(n) = P_e(n+1) for odd n

p = normcdf(0.5);

odd_n = [1 3 5 11 21 41 61];

fprintf('\n');
fprintf('-------------------------------------------------\n');
fprintf('Problem 7 Verification\n');
fprintf('-------------------------------------------------\n');
fprintf('p = %.6f\n\n', p);

for k = 1:length(odd_n)

    n = odd_n(k);

    % Probability of error for odd n
    Pe_n = binocdf((n-1)/2, n, p);

    % Probability of error for even n+1
    % Ties broken in favor of m
    Pe_np1 = 0.5 * ...
        ( binocdf((n-1)/2, n+1, p) + ...
          1 - binocdf((n-1)/2, n+1, 1-p) );

    fprintf('n = %2d    Pe(n)   = %.12e\n', n, Pe_n);
    fprintf('n = %2d    Pe(n+1) = %.12e\n', n+1, Pe_np1);
    fprintf('Difference = %.12e\n\n', abs(Pe_n - Pe_np1));

end

fprintf('-------------------------------------------------\n');