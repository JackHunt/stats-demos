clear all;
clc;

alpha = 20;  % Concentration parameter
K = 250;     % Number of clusters
weights = stickBreaking(alpha, K);
bar(weights);