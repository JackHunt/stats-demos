%% Clean up etc
clear all;
close all;
clc;

%% Create some demo data.
X = [1.0, 2.1;
     1.5, 1.8;
     2.0, 2.0;
     2.2, 2.5;
     3.1, 3.0;
     3.5, 3.2;
     4.0, 4.1;
     4.5, 3.8];

Y = [0; 0; 0; 0; 1; 1; 1; 1];

%% Fit
model = train_nb(X, Y);
Y_pred = predict_nb(X, model);

%% Compute distributions for test points.
[x1, x2] = meshgrid(linspace(min(X(:, 1)) - 1, max(X(:, 1)) + 1, 100), ...
                            linspace(min(X(:, 2)) - 1, max(X(:, 2)) + 1, 100));
grid = [x1(:), x2(:)];

mu_0 = model.mu(1, :);
sigma_0 = model.sigma(1, :);

mu_1 = model.mu(2, :);
sigma_1 = model.sigma(2, :);

lik_0 = (1 / sqrt(2 * pi * sigma_0(1) * sigma_0(2))) * ...
    exp(-((grid(:, 1) - mu_0(1)).^2 / (2 * sigma_0(1)) + ...
    (grid(:, 2) - mu_0(2)).^2 / (2 * sigma_0(2))));

lik_1 = (1 / sqrt(2 * pi * sigma_1(1) * sigma_1(2))) * ...
    exp(-((grid(:, 1) - mu_1(1)).^2 / (2 * sigma_1(1)) + ...
    (grid(:, 2) - mu_1(2)).^2 / (2 * sigma_1(2))));

pos_0 = lik_0 * model.priors(1);
pos_1 = lik_1 * model.priors(2);

posterior_sum = pos_0 + pos_1;
pos_0 = pos_0 ./ posterior_sum;
pos_1 = pos_1 ./ posterior_sum;

lik_0 = reshape(lik_0, size(x1));
lik_1 = reshape(lik_1, size(x1));
pos_0 = reshape(pos_0, size(x1));
pos_1 = reshape(pos_1, size(x1));

%% Plot.
figure;

subplot(2, 2, 1);
bar([0, 1], [model.priors(1), model.priors(2)], 'FaceColor', [0.7 0.7 0.9]);
title('Prior');
xticks([0 1]);
xlabel('Class');
ylabel('Prior');
ylim([0 1]);

subplot(2, 2, 2);
surf(x1, x2, lik_0, 'EdgeColor', 'none');
hold on;
plot3(X(Y == 0, 1), X(Y == 0, 2), max(lik_0(:)) * ones(size(X(Y == 0, 1))), ...
    'bo', 'MarkerFaceColor', 'b');
title('Likelihood for Class 0');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Likelihood');
view(3);
colorbar;

subplot(2, 2, 3);
surf(x1, x2, lik_1, 'EdgeColor', 'none');
hold on;
plot3(X(Y == 1, 1), X(Y == 1, 2), max(lik_1(:)) * ones(size(X(Y == 1, 1))), ...
    'ro', 'MarkerFaceColor', 'r');
title('Likelihood for Class 1');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Likelihood');
view(3);
colorbar;

subplot(2, 2, 4);
surf(x1, x2, pos_0, 'EdgeColor', 'none');
hold on;
plot3(X(Y == 0, 1), X(Y == 0, 2), max(pos_0(:)) * ones(size(X(Y == 0, 1))), ...
    'bo', 'MarkerFaceColor', 'b');
surf(x1, x2, pos_1, 'EdgeColor', 'none');
plot3(X(Y == 1, 1), X(Y == 1, 2), max(pos_1(:)) * ones(size(X(Y == 1, 1))), ...
    'ro', 'MarkerFaceColor', 'r');
title('Posterior for Class 0 and 1');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Posterior');
view(3);
colorbar;