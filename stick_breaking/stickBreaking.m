function weights = stickBreaking(alpha, K)
    % stickBreaking simulates the stick-breaking process.
    % 
    % Arguments:
    %   alpha - concentration parameter for the Beta distribution
    %   K - number of breaks (or clusters)
    %
    % Returns:
    %   weights - vector of weights for each part of the stick

    weights = zeros(1, K);  % Initialize the weights vector
    remainingStickLength = 1;  % Start with a stick of unit length

    for i = 1:K
        % Break the stick using a Beta distribution
        breakFraction = betarnd(1, alpha);

        % Assign the weight for this cluster
        weights(i) = remainingStickLength * breakFraction;

        % Update the length of the remaining stick
        remainingStickLength = remainingStickLength - weights(i);
    end
end
