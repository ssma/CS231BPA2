function alpha = get_alpha(im_data, bbox, num_components_fg, num_components_bg, beta, gamma, use_diagonals, epsilon_U_kmeans, epsilon_U, epsilon_E, image_basename, cachedir)

% grabcut algorithm
disp('grabcut algorithm');

stream0 = RandStream('mt19937ar','Seed',0);
RandStream.setDefaultStream(stream0);

%num_components_fg = 5;
%num_components_bg = 5;
pi_fg = {0.2, 0.2, 0.2, 0.2, 0.2};
pi_bg = {0.2, 0.2, 0.2, 0.2, 0.2};
mu_fg = {zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1)};
mu_bg = {zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1)};
sigma_fg = {eye(3), eye(3), eye(3), eye(3), eye(3)};
sigma_bg = {eye(3), eye(3), eye(3), eye(3), eye(3)};
%beta = 2.0;
%gamma = 10.0;
%use_diagonals = 0;
%epsilon_U_kmeans = 2;
%epsilon_U = 2;
%epsilon_E = 100;
z = im_data;
flat_z = flatten_z(z);
connection_weights = get_connection_weights(z, beta, gamma, use_diagonals);
[flat_alpha, U_infinitizer] = init_alpha(z, bbox);

k_fg = random('unid', num_components_fg * ones(1, size(flat_z, 2)));
k_bg = random('unid', num_components_bg * ones(1, size(flat_z, 2)));

last_E = inf;
U_list_list = {};
pi_fg_list = {};
pi_bg_list = {};
mu_fg_list = {};
mu_bg_list = {};
sigma_fg_list = {};
sigma_bg_list = {};
k_fg_list = {};
k_bg_list = {};
flat_alpha_list = {};
flat_alpha_list{end+1} = flat_alpha;
[pi_fg, mu_fg, sigma_fg, k_fg, pi_bg, mu_bg, sigma_bg, k_bg, U_list] = update_GMM(flat_z, flat_alpha, pi_fg, mu_fg, sigma_fg, k_fg, num_components_fg, pi_bg, mu_bg, sigma_bg, k_bg, num_components_bg, epsilon_U_kmeans, 1);
pi_fg_list{end+1} = pi_fg;
pi_bg_list{end+1} = pi_bg;
mu_fg_list{end+1} = mu_fg;
mu_bg_list{end+1} = mu_bg;
sigma_fg_list{end+1} = sigma_fg;
sigma_bg_list{end+1} = sigma_bg;
k_fg_list{end+1} = k_fg;
k_bg_list{end+1} = k_bg;
U_list_list{end+1} = U_list;
E_list = [];
while true,
	[pi_fg, mu_fg, sigma_fg, k_fg, pi_bg, mu_bg, sigma_bg, k_bg, U_list] = update_GMM(flat_z, flat_alpha, pi_fg, mu_fg, sigma_fg, k_fg, num_components_fg, pi_bg, mu_bg, sigma_bg, k_bg, num_components_bg, epsilon_U, 0);
	U_list_list{end+1} = U_list;
	pi_fg_list{end+1} = pi_fg;
	pi_bg_list{end+1} = pi_bg;
	mu_fg_list{end+1} = mu_fg;
	mu_bg_list{end+1} = mu_bg;
	sigma_fg_list{end+1} = sigma_fg;
	sigma_bg_list{end+1} = sigma_bg;
	k_fg_list{end+1} = k_fg;
	k_bg_list{end+1} = k_bg;
	[flat_alpha, E] = update_alpha(flat_z, pi_fg, mu_fg, sigma_fg, pi_bg, mu_bg, sigma_bg, U_infinitizer, connection_weights);
	flat_alpha_list{end+1} = flat_alpha;
	E_list = [E_list, E];
	last_E - E,
	if last_E - E < epsilon_E
		break;
	end;
	last_E = E;
end;

alpha = unflatten_alpha(flat_alpha, z);

cachename = [cachedir '/' image_basename '-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E) '.mat'];

save(cachename, 'U_list_list', 'E_list', 'k_fg_list', 'k_bg_list', 'flat_alpha_list', 'pi_fg_list', 'pi_bg_list', 'mu_fg_list', 'mu_bg_list', 'sigma_fg_list', 'sigma_bg_list', 'z', 'alpha', 'connection_weights', 'U_infinitizer');

% INITIALIZE THE FOREGROUND & BACKGROUND GAUSSIAN MIXTURE MODEL (GMM)
% 
% while CONVERGENCE
%     
%     UPDATE THE GAUSSIAN MIXTURE MODELS
%     
%     MAX-FLOW/MIN-CUT ENERGY MINIMIZATION
%     
%     IF THE ENERGY DOES NOT CONVERGE
%         
%         break;
%     
%     END
% end
