function [inter_entropy, intra_entropy] = entropy_analysis(data, cluster_idx, n_clusters)
    cluster_counts = histcounts(cluster_idx, 1:(n_clusters + 1));
    inter_entropy = calculate_entropy(cluster_counts);
    
    intra_entropy = 0;
    for i = 1 : n_clusters
        cluster_data = data(cluster_idx == i, :);
        if ~isempty(cluster_data)
            dist = pdist2(cluster_data, cluster_data);
            avg_dist = mean(dist, 2);
            intra_entropy = intra_entropy + calculate_entropy(avg_dist);
        end
    end
    intra_entropy = intra_entropy / n_clusters;
end