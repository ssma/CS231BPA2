function [score, accuracy] = visualize_grabcut(params_filename)
  params = load(params_filename);
  num_components_fg = params.num_components_fg;
  num_components_bg = params.num_components_bg;
  beta = params.beta;
  gamma = params.gamma;
  use_diagonals = params.use_diagonals;
  epsilon_U_kmeans = params.epsilon_U_kmeans;
  epsilon_U = params.epsilon_U;
  epsilon_E = params.epsilon_E;
  cachedir = 'grabcut_cache';
  cachename = [cachedir '/scores-num_components_fg=' int2str(num_components_fg) '-num_components_bg=' int2str(num_components_bg) '-beta=' num2str(beta) '-gamma=' num2str(gamma) '-use_diagonals=' int2str(use_diagonals) '-epsilon_U_kmeans=' num2str(epsilon_U_kmeans) '-epsilon_U=' num2str(epsilon_U) '-epsilon_E=' num2str(epsilon_E) '.mat'];
  thingy = load(cachename);
  score = mean(thingy.scores(:));
  accuracy = mean(thingy.accuracies(:));
