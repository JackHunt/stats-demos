%% Setup.
clear all;
close all;
clc;
rng(1);

%% Load Data.
load carbig
x = Weight; % in lbs
y = MPG;

%% Fit linear model.
m = fitlm(x, y);

disp(m)

%% Predict.
[x_sorted, sort_idx] = sort(x);
y_sorted = y(sort_idx);

[ypred, ci] = predict(m, x_sorted, ...
    'Prediction', 'curve');

[ypred_pi, pi_int] = predict(m, x_sorted, ...
    'Prediction', 'observation');

%% Plot.
fig = figure;
plot(x_sorted, y_sorted, 'ko');

hold on;
plot(x_sorted, ypred, 'r-', 'LineWidth', 1.5);

plot(x_sorted, ci(:,1), 'b--');
plot(x_sorted, ci(:,2), 'b--');

plot(x_sorted, pi_int(:,1), ...
    'color', [1, 0, 1], ...
    'LineStyle', '--');

plot(x_sorted, pi_int(:,2), ...
    'color', [1, 0, 1], ...
    'LineStyle', '--');

xlabel('Weight');
ylabel('MPG');
title('MPG vs Weight');
legend({'Data', 'Fit', '95% CI', '', '95% PI', ''}, ...
    'Location', 'northeast');