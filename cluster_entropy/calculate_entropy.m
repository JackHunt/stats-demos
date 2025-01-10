function H = calculate_entropy(data)
    n = sum(data);
    p = data / n;
    p(p == 0) = [];
    H = -sum(p .* log2(p));
end