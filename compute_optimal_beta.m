function beta = compute_optimal_beta(data_dir)
  files = dir([data_dir '/*.*']);
  square_diffs = [];
  for i=1:size(files,1)
    if (files(i).isdir) 
      continue
    end
    imfile = [data_dir filesep files(i).name];
    [pathstr, imname, ext] = fileparts(imfile);
    imname,
    z = double([imread(imfile)]) / 255;
    connection_weights = get_connection_weights(z, 1.0, 1.0, 1);
    square_diffs = [square_diffs; -1.0 * log(connection_weights(:, 3))];
  end
  beta = 1.0 / (2.0 * mean(square_diffs(:)));
