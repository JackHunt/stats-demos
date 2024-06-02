clear all;
clc;

alpha = 100;  % Concentration parameter
K = 2500;     % Number of clusters
weights = stickBreaking(alpha, K);
sum(weights)
bar(weights);