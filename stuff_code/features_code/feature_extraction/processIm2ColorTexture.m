function processIm2ColorTexture(inname, outname, varargin)

%% Set parameters

colorNodes = varargin{1};
textonNodes = varargin{2};

%% Read image
im = im2double(imread(inname));

%% Classify surfaces

textonim = uint16(getTextonImage(im, textonNodes));

if(size(im,3)==3)
   colorim = uint16(getColorImage(im, colorNodes));
else
   colorim = [];
end
save(outname, 'textonim', 'colorim');
