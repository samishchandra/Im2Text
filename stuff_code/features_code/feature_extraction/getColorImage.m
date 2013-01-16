function colorim = getColorImage(im, colorNodes)
% colim = getColorImage(im, colorNodes)

[L, a, b] = rgb2lab(im);

%L = (L - mean(L(:)));% / std(L);
%a = (a - mean(a(:)));% / std(a);
%b = (b - mean(b(:)));% / std(b);        

feat = single(cat(2, L(:)/2, a(:), b(:))/100); 

%idx = getNearestHierarchy(feat, colorNodes);
% leafnum = zeros(numel(colorNodes), 1);
% leafnum([colorNodes.isleaf]) = 1:sum([colorNodes.isleaf]);
% idx = leafnum(idx);

idx = getNearest(feat, colorNodes.centers);

colorim = reshape(idx, [size(im, 1) size(im, 2)]);
