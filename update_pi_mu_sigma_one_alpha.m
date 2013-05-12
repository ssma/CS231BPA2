function [pi, mu, sigma] = update_pi_mu_sigma_one_alpha(flat_z, k, num_components)
    min_component_size = 0;
    pi = {};
    mu = {};
    sigma = {};
    for c = 1:num_components
	if length(find(k == c)) >= min_component_size
	        pi{c} = length(find(k == c)) / (1.0 * length(k));
	        mu{c} = mean(flat_z(:, find(k == c)), 2);
	        sigma{c} = cov(flat_z(:, find(k == c))');
	else
		pi{c} = 0.0;
		mu{c} = zeros(size(flat_z, 1), 1);
		sigma{c} = eye(size(flat_z, 1));
	end;
    end;
