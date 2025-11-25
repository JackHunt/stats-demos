function data = n_class_synthetic(N, N_feat, N_class, perc_train)
%N_CLASS_SYNTHETIC Generate an N class synthetic dataset.
%   Detailed explanation goes here
    arguments (Input)
        N {mustBePositive}
        N_feat {mustBePositive}
        N_class {mustBePositive}
        perc_train (1,1) {mustBeBetween(perc_train, 0, 1)}
    end

    N_per_class = ceil(N / N_class);
    D = [];
    for k = 1 : N_class
        M = rand(1, N_feat) * 2 * k - rand(1, N_feat) * 10;
        S = eye(N_feat) * rand(1, 1) * 2;%onionMethodCorr(N_feat);

        feat = mvnrnd(M, S, N_per_class);
        label = repmat(k, N_per_class, 1);

        D = [D; [feat label]];
    end

    D = D(randperm(size(D, 1)),:);

    N_train = floor(perc_train * N);
    N_val_cal = floor((N - N_train) / 2);

    encode = @(x) squeeze(onehotencode(categorical(x), N_class));
    
    D_train = D(1 : N_train, :);
    data.train.X = D_train(:, 1 : N_feat);
    data.train.Y = D_train(:, N_feat + 1);
    data.train.Y_onehot = encode(data.train.Y);

    val_start = N_train + 1;
    D_val = D(val_start : val_start + N_val_cal, :);
    data.val.X = D_val(:, 1 : N_feat);
    data.val.Y = D_val(:, N_feat + 1);
    data.val.Y_onehot = encode(data.val.Y);

    cal_start = val_start + N_val_cal + 1;
    D_cal = D(cal_start : cal_start + N_val_cal, :);
    data.cal.X = D_cal(:, 1 : N_feat);
    data.cal.Y = D_cal(:, N_feat + 1);
    data.cal.Y_onehot = encode(data.cal.Y);
end