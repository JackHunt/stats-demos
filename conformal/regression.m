%% Setup.
clear all;
close all;
clc;

rng(1);

alpha = 0.1;
split = 0.2;

%% Load data.
load carsmall

X = Horsepower;
Y = MPG;
D = table(X, Y);

n = height(D);
idx = randperm(n);

n_train = round((1.0 - split) * n);
n_cal = round(split * 0.5 * n);

idx_train = idx(1 : n_train);
idx_cal = idx(n_train + 1 : n_train + n_cal);
idx_test = idx(n_train + n_cal + 1 : end);

D_train = sortrows(D(idx_train, :), "X");
D_cal = sortrows(D(idx_cal, :), "X");
D_test = sortrows(D(idx_test, :), "X");

%% Fit a Random Forest.
forest = TreeBagger(200, D_train, "Y", "Method", "regression");

%% Calibrate for CP.
tau = [alpha / 2 0.5 1.0 - alpha / 2];

pred_cal = quantilePredict(forest, D_cal.X, "Quantile", tau);
nonconformity_cal = max( ...
    [pred_cal(:,1) - D_cal.Y, D_cal.Y - pred_cal(:, 3)], [], 2);

n_cal = length(nonconformity_cal);
q = ceil((1 - alpha) * (n_cal + 1)) / (n_cal + 1);
q_hat = quantile(nonconformity_cal, q);

%% Predict.
pred_test = quantilePredict(forest, D_test.X, "Quantile", tau);

lower_bound = pred_test(:, 1) - q_hat;
upper_bound = pred_test(:, 3) + q_hat;

coverage = mean((D_test.Y >= lower_bound) & (D_test.Y <= upper_bound));
fprintf("Empirical coverage: %.2f\n", coverage);

%% Plot
figure;
plot(D_train.X, D_train.Y, ".", "DisplayName", "Train Data");

hold on
plot(D_test.X, D_test.Y, "*", "DisplayName", "Test Data");

hold on
plot(D_cal.X, D_cal.Y, "*", "DisplayName", "Cal Data");

hold on
errorbar(D_test.X, pred_test(:, 2), upper_bound - lower_bound, ...
    "vertical", "*", "DisplayName", "Predictions")

legend("Location", "NorthWest");

axis tight
title("Random Forest Quantile Regression")
hold off

%% Print predictions.
for n = 1 : size(D_test.X, 1)
    fprintf("Y = %d, Y_pred = %d, lower=%d, upper=%d\n", ...
        D_test.Y(n), pred_test(n, 2), pred_test(n, 1), pred_test(n, 3));
end