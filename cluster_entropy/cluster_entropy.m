%% Clear & configure.
clear all;
close all;
clc;

n_clusters = 3;
cluster_size = 100;
corruption_rate = 0.4;

%% Create data.
data = [];
labels = [];
for i = 1 : n_clusters
    center = rand(1, 2) * 10;
    cluster_data = center + randn(cluster_size, 2);
    data = [data; cluster_data];
    labels = [labels; repmat(i, cluster_size, 1)];
end

%% Cluster.
[correct_cluster_idx, ~] = kmeans(data, n_clusters);

%% Corrupt some clusters.
corrupted_cluster_idx = correct_cluster_idx;
num_corrupted = floor(corruption_rate * length(corrupted_cluster_idx));
corrupt_indices = randperm(length(corrupted_cluster_idx), num_corrupted);
for idx = corrupt_indices
    corrupted_cluster_idx(idx) = randi([1 n_clusters]);
end

%% Compute entropy.
[correct_inter_entropy, correct_intra_entropy] = entropy_analysis( ...
    data, correct_cluster_idx, n_clusters);
[corrupted_inter_entropy, corrupted_intra_entropy] = entropy_analysis( ...
    data, corrupted_cluster_idx, n_clusters);

fprintf('Correct Clustering:\n');
fprintf('Inter-cluster Entropy: %.4f\n', correct_inter_entropy);
fprintf('Intra-cluster Entropy: %.4f\n', correct_intra_entropy);

fprintf('\nCorrupted Clustering:\n');
fprintf('Inter-cluster Entropy: %.4f\n', corrupted_inter_entropy);
fprintf('Intra-cluster Entropy: %.4f\n', corrupted_intra_entropy);

%% Visualise.
figure;
subplot(1, 2, 1);
gscatter(data(:,1), data(:,2), correct_cluster_idx);
title('Correct Clustering');
xlabel('Feature 1');
ylabel('Feature 2');

subplot(1, 2, 2);
gscatter(data(:,1), data(:,2), corrupted_cluster_idx);
title('Corrupted Clustering');
xlabel('Feature 1');
ylabel('Feature 2');