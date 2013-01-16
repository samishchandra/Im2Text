% getHOGNodesScript

load '~/data/pascal08/val_records.mat';

imdir = '/home/dhoiem/data/pascal08/VOCdevkit/VOC2008/JPEGImages';

blocksize = 8;
nx = 4;
ny = 4;
scalefactor = sqrt(2);

fn = dir(fullfile(imdir, '*.jpg'));
fn = {fn.name};

nimages = 100;
npts = 1000;

rp = randperm(numel(fn));
rp = rp(1:nimages);

feat = cell(nimages, 1);
for f = 1:numel(rp)
    
    if mod(f, 25)==0
        disp(num2str(f))
    end
    
    im = imread(fullfile(imdir, fn{f}));
        
    [tmp, bbox] = getObjectBBoxes(rec(f), []);        
    
    [feat{f}, x, y, s] = getHOGFeatures(im, blocksize, scalefactor, nx, ny);
           
    bx = bbox([1 1 3 3 1]);
    by = bbox([2 4 4 2 2]);
    % object keypoints 
    ind = inpolygon(x, y, bx, by);      
    % add roughly equal number of other keypoints
    ind = ind | rand(size(ind))<sum(ind)/numel(ind); 
    
    feat{f} = feat{f}(ind, :);
    
    if size(feat{f}, 1)>npts
        pts = randperm(size(feat{f}, 1));
        feat{f} = feat{f}(pts(1:npts), :);
    end
end
    
data = cat(1, feat{:});
disp(num2str(size(data)))

nsplits = 8;
nrepeat = 3;
maxnodes = 1000;
varianceTarget = 0.99;
[centers, idx2] = kmeans_fast2(data, maxnodes, nrepeat);
%siftNodes = hierarchicalKmeans(data, nsplits, nrepeat, maxnodes, varianceTarget);
save '~/data/pascal08_final/features/hogClusters.mat' centers