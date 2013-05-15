function visualize_grabcut_components(image_basename, image_ext, params_filename, component_dir)
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
	component_str = [image_basename '-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E)];
	mkdir([component_dir '/' component_str]);
	alpha = blah.alpha;
	z = blah.z;
	k_fg = unflatten_alpha(blah.k_fg_list{end}, z);
	k_bg = unflatten_alpha(blah.k_bg_list{end}, z);
	for c = 1:num_components_fg
		msk = zeros(size(z, 1), size(z, 2));
		msk(k_fg == c & alpha == 1) = 1;
		c_z = repmat(msk, [1, 1, 3]) .* z;
		imwrite(c_z, [component_dir '/' component_str '/alpha1-k' int2str(c) '-' image_basename], image_ext);
	end;
	for c = 1:num_components_bg
		msk = zeros(size(z, 1), size(z, 2));
		msk(k_bg == c & alpha == 0) = 1;
		c_z = repmat(msk, [1, 1, 3]) .* z;
		imwrite(c_z, [component_dir '/' component_str '/alpha0-k' int2str(c) '-' image_basename], image_ext);
	end;
