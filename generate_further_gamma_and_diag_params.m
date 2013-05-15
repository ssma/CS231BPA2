param_dir = 'params';
prefix = 'gamma_and_diag';
t = 11;
num_components_fg = 5;
num_components_bg = 5;
beta = 55.8276;
epsilon_U_kmeans = 2.0;
epsilon_U = 2.0;
epsilon_E = 100.0;
for use_diagonals = 0:1
	for gamma = [50.0, 200.0]
		params_filename = [param_dir '/' prefix int2str(t) '.mat'];
		save(params_filename, 'num_components_fg', 'num_components_bg', 'beta', 'epsilon_U_kmeans', 'epsilon_U', 'epsilon_E', 'use_diagonals', 'gamma');
		t = t + 1;
	end;
end;
