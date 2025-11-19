function plot_n_class_synthetic(data)
%PLOT_N_CLASS_SYNTHETIC Plot the synthetic N class dataset.
%   Detailed explanation goes here
    figure;

    subplot(1, 3, 1);
    scatter(data.train.X(:,1), data.train.X(:,2), [], data.train.Y(:, 1));
    title("Train");

    subplot(1, 3, 2);
    scatter(data.val.X(:,1), data.val.X(:,2), [], data.val.Y(:, 1));
    title("Val");

    subplot(1, 3, 3);
    scatter(data.cal.X(:,1), data.cal.X(:,2), [], data.cal.Y(:, 1));
    title("Cal");
end