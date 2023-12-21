clear all;
close all;
clc;

N = 2500;

omega = ones(N, 3, 3);

for n = 1 : N
    omega(n, 1:3, 1:3) = onionMethodCorr(3);
end

xs = omega(1 : N, 1, 2);
ys = omega(1 : N, 1, 3);
zs = omega(1 : N, 2, 3);

scatter3(xs, ys, zs);