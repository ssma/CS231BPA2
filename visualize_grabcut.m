function visualize_grabcut(data_dir, grabcut_dir)
  files = dir([data_dir '/*.*']);
  num_components_fg = 5;
  num_components_bg = 5;
  beta = 2.0;
  gamma = 10.0;
  use_diagonals = 0;
  epsilon_U_kmeans = 2.0;
  epsilon_U = 2.0;
  epsilon_E = 100.0;
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
    imwrite(gc_z, [grabcut_dir '/foregrounds/' image_basename], ext(2:end));
    imwrite(d.alpha, [grabcut_dir '/masks/' image_basename], ext(2:end));
  end
