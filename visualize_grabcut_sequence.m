function visualize_grabcut_sequence(image_basename, image_ext, params_filename, sequence_dir)
	cachedir = 'grabcut_cache';
	params = load(params_filename);

	num_components_fg = params.num_components_fg;
	num_components_bg = params.num_components_bg;
	beta = params.beta;
	gamma = params.gamma;
	use_diagonals = params.use_diagonals;
	epsilon_U_kmeans = params.epsilon_U_kmeans;
	epsilon_U = params.epsilon_U;
	epsilon_E = params.epsilon_E;

	cachename = [cachedir '/' image_basename '-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E) '.mat'];
	blah = load(cachename);
	sequence_str = [image_basename '-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E)];
	mkdir([sequence_dir '/' sequence_str]);
	flat_alpha_list = blah.flat_alpha_list;
	z = blah.z;
	for t = 1:length(flat_alpha_list)
		alpha = unflatten_alpha(flat_alpha_list{t}, z);
		gc_z = repmat(alpha, [1, 1, 3]) .* z;
		imwrite(gc_z, [sequence_dir '/' sequence_str '/' int2str(t) '-' image_basename], image_ext);
	end;
