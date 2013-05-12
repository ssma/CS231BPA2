function [pi_fg, mu_fg, sigma_fg, k_fg, pi_bg, mu_bg, sigma_bg, k_bg] = update_GMM(flat_z, flat_alpha, pi_fg, mu_fg, sigma_fg, k_fg, num_components_fg, pi_bg, mu_bg, sigma_bg, k_bg, num_components_bg, epsilon, restrict_to_kmeans)
    last_U = inf;
    while True,
        [pi_fg, mu_fg, sigma_fg, pi_bg, mu_bg, sigma_bg] = update_all_pi_mu_sigma(flat_z, flat_alpha, k_fg, k_bg, num_components_fg, num_components_bg);
        if restrict_to_kmeans,
            for c = 1:num_components_fg
                pi_fg{c} = 1.0 / num_components_fg;
                sigma_fg{c} = eye(size(flat_z, 1));
            end;
            for c = 1:num_components_bg
                pi_bg{c} = 1.0 / num_components_bg;
                sigma_bg{c} = eye(size(flat_z, 1));
            end;
        end;
        [k_fg, U_fg] = update_k(flat_z, pi_fg, mu_fg, sigma_fg);
        [k_bg, U_bg] = update_k(flat_z, pi_bg, mu_bg, sigma_bg);
        U = sum(U_fg(find(flat_alpha == 1))) + sum(U_bg(find(flat_alpha == 0)));
        U,
        if U > last_U - epsilon
            break;
        end;
        last_U = U;
    end;
