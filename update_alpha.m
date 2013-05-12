function [flat_alpha, E] = update_alpha(pi_fg, mu_fg, sigma_fg, pi_bg, mu_bg, sigma_bg, U_infinitizer, connection_weights)
	[k_fg, U_fg] = update_k(flat_z, pi_fg, mu_fg, sigma_fg);
	[k_bg, U_bg] = update_k(flat_z, pi_bg, mu_bg, sigma_bg);
	U = [U_bg', U_fg'] + U_infinitizer;
	V = connection_weights; 
	flat_alpha = mexEnergyMin(U, V)';
	disp('Computing E (this might take a while since Kevin did not vectorize it)...');
	E = 0.0;
	for a = 1:length(flat_alpha)
		E = E + U(a, flat_alpha(a) + 1);
		for b = (a+1):length(flat_alpha)
			if flat_alpha(a) ~= flat_alpha(b)
				E = E + V(a, b);
			end;
		end;
	end;
	E,
