function [] = kalman_plot_1d(x_true, x_est, z, P_est, t)
%KALMAN_PLOT_1D Plot the true, estimated and measured values of a variable.
%   Variable is scalar valued. Also plotted are 95% CI's.
    plot(t, x_true, 'r', ...
        t, x_est, 'b--', ...
        t, z, 'g.');
    
    hold on;
    fill([t, fliplr(t)], [x_est + 2 * sqrt(P_est), ...
        fliplr(x_est - 2 * sqrt(P_est))], ...
        'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
    
    legend('True', 'Estimated', 'Measured', '95% CI');
end
