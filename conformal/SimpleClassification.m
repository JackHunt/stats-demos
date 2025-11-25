%% Setup etc
clear all;
close all;
clc;

%addpath("../corr_cov_priors/") % For onion method

D = 2;
N = 10000;
K = 3;
PERC_TRAIN = 0.7;

alpha = 0.1; % 90% confidence.

%% Get data.
D = n_class_synthetic(N, D, K, PERC_TRAIN);
plot_n_class_synthetic(D);

%% Train a classifier and predict.
net = patternnet(4, 'trainscg');

X_train = D.train.X';
Y_train = D.train.Y_onehot';
[net, tr] = train(net, X_train, Y_train);

X_val = D.val.X';
Y_val = D.val.Y;
Y_pred_val_softmax = net(X_val)';
[~, Y_pred_val] = max(Y_pred_val_softmax, [], 2);

figure;
confusionchart(Y_pred_val, Y_val);

%% Compute q_hat on Calibration Data.
X_cal = D.cal.X';
Y_cal = D.cal.Y;
Y_pred_cal_softmax = net(X_cal)';

% conformity_scores = 1 - Y_pred_cal_softmax;
n = size(X_cal, 2);
idx = sub2ind(size(Y_pred_cal_softmax), (1:n)', Y_cal); 
conformity_scores = 1 - Y_pred_cal_softmax(idx);

q_level = ceil((n + 1) * (1 - alpha)) / n;
q_hat = quantile(conformity_scores, q_level)

%% Compute Prediction Sets and Empirical Coverage.
pred_sets = Y_pred_val_softmax >= 1 - q_hat
empirical_coverage = mean(pred_sets(:, Y_pred_val)')