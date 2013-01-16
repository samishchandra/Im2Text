function codewords = load_codewords;

   feat_dir = fileparts(which('extract_vectors.m'));
   codewords.col_nodes =load(fullfile(feat_dir, 'colorClusters.mat'));
   codewords.tex_nodes = load(fullfile(feat_dir, 'textonClusters.mat'));
   codewords.hog_nodes = load(fullfile(feat_dir, 'hogClusters.mat'));