function [desc, x, y, s] = getHOGFeatures(im, blocksize, scalefactor, nx, ny)
% [desc, x, y, s] = getHOGFeatures(im, blocksize, scalefactor, nx, ny)

fprintf('image size: %d %d %d\n',size(im,1),size(im,2),size(im,3));
if(size(im,3)==1)
   im = repmat(im,[1,1,3]);
end

[feat, scale] = featpyramid(double(im), blocksize, scalefactor);

desc = cell(size(feat));
for k = 1:numel(feat)
    
    % average contrast
    %feat{k} = feat{k}(:,:,1:9)+feat{k}(:,:,10:18)+feat{k}(:,:,19:27)+feat{k}(:,:,28:36);
            
    [fh, fw, nval] = size(feat{k});
    [tx, ty] = meshgrid(1:fw, 1:fh);
   
    ind = (ty(1:end-nx+1, 1:end-ny+1)+fh*(tx(1:end-nx+1, 1:end-ny+1)-1));
    ind = ind(:);
    x{k} = (nx/2+tx(ind))*blocksize/scale(k);
    y{k} = (ny/2+ty(ind))*blocksize/scale(k);
    s{k} = ones(size(x{k}))*blocksize/scale(k);
        
    fcol = reshape(single(feat{k}), fh*fw, nval);

    % concatenate values from nx by ny blocks        
    c = 0;
    tmpf = cell(nx*ny, 1);        
    for dx = 1:nx
        for dy = 1:ny
            c=c+1;
            ind = (ty(dx:end-nx+dx, dy:end-ny+dy)+fh*(tx(dx:end-nx+dx, dy:end-ny+dy)-1));
            tmpf{c} = fcol(ind(:), :);  
        end
    end
    desc{k} = cat(2, tmpf{:});
end

[desc, x, y, s] = deal(cat(1, desc{:}), cat(1, x{:}), cat(1, y{:}), cat(1, s{:}));
    
