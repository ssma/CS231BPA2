function visualize_grabcut(data_dir, params_filename, grabcut_dir)
  params = load(params_filename);
  files = dir([data_dir '/*.*']);
  num_components_fg = params.num_components_fg;
  num_components_bg = params.num_components_bg;
  beta = params.beta;
  gamma = params.gamma;
  use_diagonals = params.use_diagonals;
  epsilon_U_kmeans = params.epsilon_U_kmeans;
  epsilon_U = params.epsilon_U;
  epsilon_E = params.epsilon_E;
  cachedir = 'grabcut_cache';
  for i=1:size(files,1)
    if (files(i).isdir) 
      continue
    end
    imfile = [data_dir filesep files(i).name];
    [pathstr, imname, ext] = fileparts(imfile);
        
    %run grabcut
    image_basename = [imname ext];
    cachename = [cachedir '/' image_basename '-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E) '.mat'];
    d = load(cachename);
    gc_z = repmat(d.alpha, [1, 1, 3]) .* d.z;
    param_str = ['grabcut_visualizations-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E)];
    mkdir([grabcut_dir '/' param_str]);
    mkdir([grabcut_dir '/' param_str '/foregrounds']);
    mkdir([grabcut_dir '/' param_str '/masks']);
    imwrite(gc_z, [grabcut_dir '/' param_str '/foregrounds/' image_basename], ext(2:end));
    imwrite(d.alpha, [grabcut_dir '/' param_str '/masks/' image_basename], ext(2:end));
  end
