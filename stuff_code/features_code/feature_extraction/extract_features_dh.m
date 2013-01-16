function extract_feature_dh(imdir, out_dir, filestr)

DO_COLOR_TEXTURE = 1;
DO_HOG = 1;

if(~exist('filestr','var'))
   filestr = '*.jpg';
end

if(~exist('out_dir','var'))
   basedir = fullfile(imdir,'processed/','');
else
   basedir = fullfile(out_dir,'processed/','')
end


if DO_HOG  
%  getHOGNodesScript;
   texture = load('hogClusters.mat');

    outdir = [basedir 'hog'];   
   processDirectory(imdir, filestr, outdir, '_hog.mat', ...
      @processIm2Hog, texture);    
  %assignVisualWords; % script to assign cluster ids
end
  

if DO_COLOR_TEXTURE
   % getColorNodesScript;
   % getHOGNodesScript;
    outdir = [basedir 'tc2'];   
    texture = load('textonClusters.mat');
    color = load('colorClusters.mat');
    processDirectory(imdir, filestr, outdir, '_tc.mat', ...
        @processIm2ColorTexture, color, texture);     
end

