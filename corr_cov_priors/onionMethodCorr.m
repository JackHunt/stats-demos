function omega = onionMethodCorr(D)
%ONIONMETHODCORR Summary of this function goes here
%   Detailed explanation goes here
    omega = ones(D);

    for k = 2 : D
        y = betarnd((k - 1) / 2, (D - k) / 2);
        r = sqrt(y);

        v = randn(k - 1, 1);
        theta = v / norm(v);

        w = r * theta;
        q = sqrtm(omega(1 : k - 1, 1 : k - 1)) * w;
        omega(k, 1 : k - 1) = q';
        omega(1 : k - 1, k) = q;
    end
end

