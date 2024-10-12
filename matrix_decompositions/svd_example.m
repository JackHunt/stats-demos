%% Clear etc
clear all;
close all;
clc;

%% Define a square matrix and take its SVD.
A = [4, -2; 
     1, 1];

[U, S, V] = svd(A);

% Extract singular values and vectors
singular_values = diag(S);
u_1 = U(:,1);
u_2 = U(:,2);
v_1 = V(:,1);
v_2 = V(:,2);

%% Define a couple of vectors.
a = [1; 1];
b = [0.5; 2];

%% Plot.
figure;
hold on;
grid on;
axis equal;

% Basis vectors
quiver(0, 0, 1, 0, 'r', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, 0, 1, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Vectors a and b
quiver(0, 0, a(1), a(2), 'c', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, b(1), b(2), 'p', 'LineWidth', 1, 'MaxHeadSize', 0.5);

a_trans = A * a;
b_trans = A * b;

quiver(0, 0, a_trans(1), a_trans(2), '--c', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, b_trans(1), b_trans(2), '--p', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Right singular vectors (columns of V)
quiver(0, 0, v_1(1), v_1(2), 'g', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, v_2(1), v_2(2), 'm', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Transformed right singular vectors (U * singular values)
v_1_trans = S(1,1) * u_1;
v_2_trans = S(2,2) * u_2;

quiver(0, 0, v_1_trans(1), v_1_trans(2), '--g', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, v_2_trans(1), v_2_trans(2), '--m', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Left singular vectors (columns of U) - after transformation
quiver(0, 0, u_1(1), u_1(2), '--b', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, u_2(1), u_2(2), '--r', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Title etc
title('Singular Value Decomposition (SVD)');
legend('x', 'y', 'a', 'b', 'Aa', 'Ab', 'v_1 (Right Singular Vector 1)', 'v_2 (Right Singular Vector 2)', ...
       'U * Sigma * v_1', 'U * Sigma * v_2', 'u_1 (Left Singular Vector 1)', 'u_2 (Left Singular Vector 2)');
hold off;