function U = get_U_for_one_component(flat_z, pi, mu, sigma)
%Note: For this function, pi, mu, and sigma are just for ONE component
    U = -1.0 * log(pi) * ones(1, size(flat_z, 2));
    diff = flat_z - repmat(reshape(mu, size(flat_z, 1), 1), 1, size(flat_z, 2));
    qf = 0.5 * ones(1, size(flat_z, 1)) * (diff .* (inv(sigma) * diff));
    U = U + qf + 0.5 * log(det(sigma));
