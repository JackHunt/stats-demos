%% Setup
clear all;
close all;
clc;

rng(1);

alpha = 0.1;
split = 0.4;

%% Load data
load fisheriris
X_cal = meas;
Y_test = species;
Y_test = categorical(Y_test);

cv = cvpartition(Y_test, "HoldOut", split);
X_train = X_cal(training(cv), :);
Y_train = Y_test(training(cv));

X_rem = X_cal(test(cv), :);
Y_rem = Y_test(test(cv));

cv2 = cvpartition(Y_rem, "HoldOut", 0.5);
X_test = X_rem(test(cv2), :);
Y_test = Y_rem(test(cv2));

X_cal = X_rem(training(cv2), :);
Y_cal = Y_rem(training(cv2));

%% Train SVM
svm = fitcecoc(X_train, Y_train);

Y_pred = predict(svm, X_train);

figure;
confusionchart(confusionmat(Y_train, Y_pred), categories(Y_train));
title("Post Train Confusion Matrix");

%% Calibrate for Conformal Prediction
[labels_cal, scores_cal] = predict(svm, X_cal);
nonconformity_cal = 1 - softmax(scores_cal);

n_cal = size(nonconformity_cal, 1);
q = ceil((1 - alpha) * (n_cal + 1)) / (n_cal);
q_hat = quantile(nonconformity_cal, q);

figure;
confusionchart(confusionmat(Y_cal, labels_cal), categories(Y_cal));
title("Calibration Confusion Matrix");

%% Do Conformal Prediction
[labels_test, scores_test] = predict(svm, X_test);
nonconformity_test = 1 - softmax(scores_test);

C = nonconformity_test <= q_hat;

for n = 1 : size(X_test, 1)
    C_n = svm.ClassNames(find(C(n, :) > 0));
    C_str = sprintf("{%s}", strjoin(cellstr(C_n), ", "));
    fprintf("Y = %s, C = %s\n", Y_test(n), C_str);
end

figure;
confusionchart(confusionmat(Y_test, labels_test), categories(Y_test));
title("Test Confusion Matrix");