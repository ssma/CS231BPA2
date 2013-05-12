function [pi_fg, mu_fg, sigma_fg, pi_bg, mu_bg, sigma_bg] = update_all_pi_mu_sigma(flat_z, flat_alpha, k_fg, k_bg, num_components_fg, num_components_bg)
    [pi_fg, mu_fg, sigma_fg] = update_pi_mu_sigma_one_alpha(flat_z(:, find(flat_alpha == 1)), k_fg(find(flat_alpha == 1)), num_components_fg);
    [pi_bg, mu_bg, sigma_bg] = update_pi_mu_sigma_one_alpha(flat_z(:, find(flat_alpha == 0)), k_bg(find(flat_alpha == 0)), num_components_bg);
