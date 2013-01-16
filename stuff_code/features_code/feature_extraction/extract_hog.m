function hog = processIm2Hog(im, hogNodes)

%% Set parameters


blocksize = 8;
nx = 4; ny = 4;
scalefactor = sqrt(2);
[feat, x, y, s] = getHOGFeatures(im, blocksize, scalefactor, nx, ny);
idx = getNearest(feat, hogNodes.centers);
%x = 2*x;
%y = 2*y;
hog.idx = idx;
hog.x = x;
hog.y = y;
hog.s = s;
