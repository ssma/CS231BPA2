function [k, U] = update_k(flat_z, pi, mu, sigma)
%Note: This gives you the k that you would get from ONE of the GMM's for ALL pixels - that's why we don't take alpha as an argument.
    num_components = length(pi);
    U = [];
    for c = 1:num_components
        U = [U ; get_U_for_one_component(flat_z, pi{c}, mu{c}, sigma{c})];
    end;
    [U, k] = min(U, [], 1);
