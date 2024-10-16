function model = train_nb(X, Y)
%TRAIN_NB Fit a Naive Bayes classifier
%   Detailed explanation goes here
    C = unique(Y);
    N = numel(C);
    
    model.priors = zeros(N, 1);
    model.mu = zeros(N, size(X, 2));
    model.sigma = zeros(N, size(X, 2));
    model.classes = C;
    
    for i = 1 : N
        c = C(i);
        X_c = X(Y == c, :);
        
        model.priors(i) = size(X_c, 1) / size(X, 1);
        model.mu(i, :) = mean(X_c);
        model.sigma(i, :) = var(X_c);
    end
end

