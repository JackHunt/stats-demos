function [x_pred, P_pred] = kalman_predict(x, P, F, Q)
%KALMAN_PREDICT Prediction stage of a linear KF.
%   Detailed explanation goes here
    x_pred = F * x;
    P_pred = F * P * F' + Q;
end

