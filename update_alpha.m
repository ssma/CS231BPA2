function [flat_alpha, E] = update_alpha(flat_z, pi_fg, mu_fg, sigma_fg, pi_bg, mu_bg, sigma_bg, U_infinitizer, connection_weights)
	[k_fg, U_fg] = update_k(flat_z, pi_fg, mu_fg, sigma_fg);
	[k_bg, U_bg] = update_k(flat_z, pi_bg, mu_bg, sigma_bg);
	U = [U_bg', U_fg'] + U_infinitizer;
	V = connection_weights; 
	[flat_alpha, E] = mexEnergyMin(U, V);
	flat_alpha = flat_alpha';
	E = E(1,1);
	E,
