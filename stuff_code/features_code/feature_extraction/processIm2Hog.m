function processIm2Hog(inname, outname, varargin)

%% Set parameters

hogNodes = varargin{1};


im = imread(inname);
%im = imresize(im, 0.5);

blocksize = 8;
nx = 4; ny = 4;
scalefactor = sqrt(2);
[feat, x, y, s] = getHOGFeatures(im, blocksize, scalefactor, nx, ny);
idx = getNearest(feat, hogNodes.centers);
%x = 2*x;
%y = 2*y;
save(outname, 'idx', 'x', 'y', 's');
