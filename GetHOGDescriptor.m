function [HOGDesc] = GetHOGDescriptor(imgPath, x1, y1, x2, y2)
    %GetHOGDescriptor Summary of this function goes here
    %   Get the HOG descriptor for the window in the given image

    img = imread(imgPath);
    img = single(img);
%     img2 = imread(imgPath);

    [x, y, z] = size(img);
    
    x2 = min(x2, x);
    y2 = min(y2, y);
    
    % consider only the image window
    img = img(x1:x2, y1:y2);

    cellSize = 8;
    hog = vl_hog(img, cellSize);
    [dx, dy, dz] = size(hog);
    HOGDesc = transpose(reshape(hog, dx*dy, dz));
    

end
