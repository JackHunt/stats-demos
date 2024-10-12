%% Clear etc
clear all;
close all;
clc;

%% Define a square matrix and take its eigendecomposition.
A = [4, -2; 
     1, 1];

[V, D] = eig(A);

eigenvalues = diag(D);

eig_1 = V(:,1);
eig_2 = V(:,2);

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

% Eigenvectors
quiver(0, 0, eig_1(1), eig_1(2), 'g', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, eig_2(1), eig_2(2), 'm', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Transformed eigenvectors by A
eig_1_trans = A * eig_1;
eig_2_trans = A * eig_2;

quiver(0, 0, eig_1_trans(1), eig_1_trans(2), ...
    '--g', 'LineWidth', 1, 'MaxHeadSize', 0.5);
quiver(0, 0, eig_2_trans(1), eig_2_trans(2), ...
    '--m', 'LineWidth', 1, 'MaxHeadSize', 0.5);

% Title etc
title('Eigendecomposition');
legend('x', 'y', 'a', 'b', 'Aa', 'Ab','eigvec1', 'eigvec2', ...
       'A * eigvec1', 'A * eigvec2');
hold off;