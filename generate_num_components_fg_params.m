param_dir = 'params';
prefix = 'num_components_fg';
t = 1;
beta = 55.8276;
num_components_bg = 5;
epsilon_U_kmeans = 2.0;
epsilon_U = 2.0;
epsilon_E = 100.0;
gamma = 100.0;
use_diagonals = 0;
for num_components_fg = [3, 4, 2]
	params_filename = [param_dir '/' prefix int2str(t) '.mat'];
	save(params_filename, 'num_components_fg', 'num_components_bg', 'beta', 'epsilon_U_kmeans', 'epsilon_U', 'epsilon_E', 'use_diagonals', 'gamma');
	t = t + 1;
end;
