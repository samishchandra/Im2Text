function [HOGDesc] = HOGDescriptor(imgPath, x1, y1, x2, y2, splitSize)
    %GetHOGDescriptor Summary of this function goes here
    %   Get the HOG descriptor for the window in the given image

    img = imread(imgPath);
    img = single(img);
%     img2 = imread(imgPath);

    [x, y, z] = size(img);
    
    if(x1>x)
        x1 = 1;
    end
    if(y1>y)
        y1 = 1;
    end
    
    x2 = min(x2, x);
    y2 = min(y2, y);
%     fprintf('sizex= %d, sizey=%d, %d, %d, %d, %d\n', x, y, x1, x2, y1, y2);
    
    % consider only the image window
    img = img(x1:x2, y1:y2);
    x1=1;y1=1;
    [x2, y2, z] = size(img);

    cellSize = 8;
    hog = vl_hog(img, cellSize);
    [dx, dy, dz] = size(hog);
    HOGDesc = {};
    HOGDesc{end+1} = transpose(reshape(hog, dx*dy, dz));
    
    width = x2 - x1;
    height = y2 - y1;
%     HOGDesc{end+1} = [HOGDesc{end}];
%     index = length(HOGDesc);
    
    for i=1:splitSize
        for j=1:splitSize
            sx1 = int32(x1 + ((i-1) * width/splitSize));
            sx2 = int32(x1 + (i * width/splitSize));
            sy1 = int32(y1 + ((j-1) * height/splitSize));
            sy2 = int32(y1 + (j * height/splitSize));
            img1 = img(sx1:sx2, sy1:sy2);
%             img3 = img2(sx1:sx2, sy1:sy2);
            hog = vl_hog(img1, cellSize);
            [dx, dy, dz] = size(hog);
%             subplot(splitSize, splitSize, splitSize*(i-1) + j), imshow(img3)
            HOGDesc{end+1} = transpose(reshape(hog, dx*dy, dz));
        end
    end
end
