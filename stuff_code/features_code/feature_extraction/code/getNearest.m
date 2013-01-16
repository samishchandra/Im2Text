function idx = getNearest(data, centers)
% idx = getNearest(data, centers)

if 0 && exist('getNearest_mex', 'file')
    idx = getNearest_mex(int32(size(data, 1)), int32(size(data, 2)), ...
        int32(size(centers, 1)), double(data)', double(centers)');
    idx = idx(:);
else

    if 0   
        idx = kdtreeidx(double(centers), double(data));
    end
        
    centers = centers';
    centerssq = sum(centers.^2, 1);

    idx = zeros(size(data, 1), 1);
    for k = 1:size(data, 1)
        dist = centerssq - 2*data(k, :) * centers;
        [tmp, idx(k)] = min(dist);
    end

end