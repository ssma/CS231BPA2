function scores = eval_grabcut(data_dir, seg_dir, box_dir)
  files = dir([data_dir '/*.*']);
  scores = [];
  num_components_fg = 5;
  num_components_bg = 5;
  beta = 2.0;
  gamma = 10.0;
  use_diagonals = 0;
  epsilon_U_kmeans = 2.0;
  epsilon_U = 2.0;
  epsilon_E = 100.0;
  cachedir = 'grabcut_cache';
  image_basenames = {};
  for i=1:size(files,1)
    if (files(i).isdir) 
      continue
    end
    imfile = [data_dir filesep files(i).name];
    [pathstr, imname, ext] = fileparts(imfile);
        
    % convert the pixel values to [0,1] for each R G B channel.
    im_data = double([imread(imfile)]) / 255;
    size(im_data)
    
    %read bounding box data
    [pathstr, imname, ext] = fileparts(imfile);
    bbfile = [box_dir filesep imname '.txt'];
    fid = fopen(bbfile);
    bbox = [];
    tline = fgetl(fid);
    while ischar(tline)
      bbox = [bbox str2num(tline)];
      tline = fgetl(fid);
    end
    
    %read segmentation data
    segfile = [seg_dir filesep imname '.bmp'];
    seg_data = double([imread(segfile)]) / 255;
    
    %run grabcut
    image_basename = [imname ext];
    image_basenames{end+1} = image_basename;
    alpha = get_alpha(im_data, bbox, num_components_fg, num_components_bg, beta, gamma, use_diagonals, epsilon_U_kmeans, epsilon_U, epsilon_E, image_basename, cachedir);
    size(alpha)
    
    %calculate score
    intersect = sum(sum(alpha .* seg_data > 0))
    union = sum(sum(alpha + seg_data > 0))
    score = intersect / union
    
    scores = [scores; score]
    
    %display our segmentation
    imagesc(repmat(alpha,[1,1,3]) .* im_data)
    
  end
  cachename = [cachedir '/scores-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E) '.mat'];
  save(cachename, 'image_basenames', 'scores');

