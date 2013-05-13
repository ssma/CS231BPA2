function scores = eval_grabcut(data_dir, seg_dir, box_dir)
  files = dir([data_dir '/*.*']);
  scores = [];
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
    alpha = get_alpha(im_data, bbox);
    size(alpha)
    
    %calculate score
    intersect = sum(sum(alpha .* seg_data > 0))
    union = sum(sum(alpha + seg_data > 0))
    score = intersect / union
    
    scores = [scores; score]
    
    %display our segmentation
    imagesc(repmat(alpha,[1,1,3]) .* im_data)
    
  end
