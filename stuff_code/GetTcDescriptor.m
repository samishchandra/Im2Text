function [col, tex] = GetTcDescriptor(imgPath, x1, y1, x2, y2)

im = imread(imgPath);

[y, x, z] = size(im);
x2 = min(x2, x);
y2 = min(y2, y);

im = im(y1:y2, x1:x2, :);

if(size(im,3)==3)
    [L, a, b] = rgb2lab(im);
    col = single(cat(2, L(:)/2, a(:), b(:))/100); 
else
    col = [];
end

col = transpose(col);
tex = [];

% imclose(im);
