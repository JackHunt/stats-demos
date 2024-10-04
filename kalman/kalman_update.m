function [x_est, P_est, S, K] = kalman_update(z, x, H, P, R)
%KALMAN_UPDATE Update stage of a linear KF.
%   Detailed explanation goes here
    y_residual = z - H * x;
    S = H * P * H' + R;
    K = P * H' / S;

    x_est = x + K * y_residual;
    P_est = (eye(6) - K * H) * P;
end
