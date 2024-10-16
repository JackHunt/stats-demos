function Y = predict_nb(X, model)
%PREDICT_NB Predict with a naive bayes classifier.
%   Detailed explanation goes here
    N_c = numel(model.classes);
    N_s = size(X, 1);
    N_feat = size(X, 2);
    
    log_probs = zeros(N_s, N_c);
    for i = 1 : N_c
        mu = model.mu(i, :);
        sigma = model.sigma(i, :);
        prior = model.priors(i);
        
        % Calculate log(P(X|C)) + log(P(C)) for each X
        for j = 1 : N_s
            log_p = 0;
            for k = 1:N_feat
                x = X(j, k);
                mu_k = mu(k);
                sigma_k = sigma(k);
                
                ll = -0.5 * log(2 * pi * sigma_k) - ((x - mu_k)^2) / (2 * sigma_k);
                log_p = log_p + ll;
            end

            log_probs(j, i) = log_p + log(prior);
        end
    end
    
    [~, max_idx] = max(log_probs, [], 2);
    Y = model.classes(max_idx);
end

