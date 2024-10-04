%% Clear env and set sim params.
clear;
clc;

dt = 0.1;
T = 0:dt:10;

% Corkscrew rad, angular and linear velocities (in Z).
R = 5;
omega = 2;
vz = 0.5;

% Measurement and process noise.
z_sigma = 0.25;
q_sigma = 0.1;

%% Motion & noise model.
% Constant vel state transition.
F = [1 0 0 dt 0  0;
     0 1 0 0  dt 0;
     0 0 1 0  0  dt;
     0 0 0 1  0  0;
     0 0 0 0  1  0;
     0 0 0 0  0  1];

% Measurement matrix.
H = [1 0 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 0 0 0];

% Process noise cov.
% https://arxiv.org/pdf/2005.00844 - Eqn 15
Q = q_sigma^2 * [dt^4 / 4 0 0 dt^3 / 2 0 0;
           0 dt^4 / 4 0 0 dt^3 / 2 0;
           0 0 dt^4 / 4 0 0 dt^3 / 2;
           dt^3 / 2 0 0 dt^2 0 0;
           0 dt^3 / 2 0 0 dt^2 0;
           0 0 dt^3 / 2 0 0 dt^2];

% Initial state & cov estimate.
x_est = [0; 0; 0; 0; 0; 0];
P_est = eye(6);

%% Simulate & estimate.
x_est_hist = zeros(6, length(T));
x_true_hist = zeros(6, length(T));
z_meas_hist = zeros(3, length(T));
P_est_hist = zeros(6, length(T));

for i = 1:length(T)
    theta = omega * T(i);
    x_true = [R * cos(theta); % x
              R * sin(theta); % y
              vz * T(i); % z
              -R * omega * sin(theta); % x vel
              R * omega * cos(theta); % y vel
              vz]; % z vel
    
    % Get a "measurement" by perturbing x_true.
    z_meas = H * x_true + z_sigma * randn(3, 1);
    
    % Predict and update KF.
    [x_pred, P_pred] = kalman_predict(x_est, P_est, F, Q);
    [x_est, P_est, S, K] = kalman_update(z_meas, x_pred, H, P_pred, R);
    
    % Store results
    x_est_hist(:, i) = x_est;
    x_true_hist(:, i) = x_true;
    z_meas_hist(:, i) = z_meas;
    P_est_hist(:, i) = diag(P_est);
end

%% Plot with 95% CI.
figure;

% X
subplot(3,1,1);
kalman_plot_1d(x_true_hist(1, :), ...
    x_est_hist(1, :), ...
    z_meas_hist(1, :), ...
    P_est_hist(1, :), T);
xlabel('Time [s]');
ylabel('X position');
title('Corkscrew Trajectory: X');

% Y
subplot(3,1,2);
kalman_plot_1d(x_true_hist(2, :), ...
    x_est_hist(2, :), ...
    z_meas_hist(2, :), ...
    P_est_hist(2, :), T);
xlabel('Time [s]');
ylabel('Y position');
title('Corkscrew Trajectory: Y');

% Z
subplot(3,1,3);
kalman_plot_1d(x_true_hist(3, :), ...
    x_est_hist(3, :), ...
    z_meas_hist(3, :), ...
    P_est_hist(3, :), T);
xlabel('Time [s]');
ylabel('Z position');
title('Corkscrew Trajectory: Z');