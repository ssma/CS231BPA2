function [pi, mu, sigma] = update_pi_mu_sigma_one_alpha(flat_z, k, num_components)
    pi = {};
    mu = {};
    sigma = {};
    for c = 1:num_components
        pi{c} = length(find(k == c)) / (1.0 * length(k));
        mu{c} = mean(flat_z(:, find(k == c)), 2);
        sigma{c} = cov(flat_z(:, find(k == c))');
    end;
