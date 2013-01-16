function [pr] = test_img(imagePath)

addpath(genpath('./libsvm/matlab/'));
K = 100;
J = 128;

categories={'building','grass','road','sky','tree','water'};

win_size = [150 150];
xy = [1 1];

kcenters = load('kmeans_hog_clusters.mat');
col_centers = load('kmeans_col_clusters.mat');

pr_prediction = zeros(1, length(categories));

while 1
    % test proability over a coarsely sampled grid
    img = imread(imagePath);
    [x y ~] = size(img);
    xy2 = xy + win_size;

    for c=1:length(categories)
        centers = kcenters.clusters{c};
        c_centers = col_centers.tcclusters{c};
        hist = zeros(1,K+J);
        hog = GetHOGDescriptor(imagePath, xy(1), xy(2), xy2(1), xy2(2));
        col = GetTcDescriptor(imagePath, xy(1), xy(2), xy2(1), xy2(2));
        % calculate the nearest center that each feature belongs to 
        for i=1:length(hog(1,:))
            d = pdist2(transpose(hog(:,i)), transpose(centers), 'euclidean');
            [~,i] = min(d);
            hist(i) = hist(i) + 1;
        end
        d = pdist2(transpose(col), transpose(c_centers), 'euclidean');
        for j=1:length(col)
            [~,ix] = min(d(j,:));
            hist(ix+K) = hist(ix+K) + 1;
        end

        hist = hist/norm(hist);
        svm = load(strcat(char(categories(c)), '_svm.mat'));
        [p_label, acc, pr_values] = svmpredict([2], hist, svm.cv, ['-b 1', '-q']);

        ix = find(svm.cv.Label == 1);
        if pr_prediction(c) < pr_values(1, ix)
            pr_prediction(c) = pr_values(1,ix);
            window{c} = [xy(2),xy(1),xy2(2),xy2(1)];
            % xy, xy2
            % pr_values(1,ix)
        end
    end

    % window moving logic
    xy(1) = xy(1) + idivide(win_size(1), int32(2));
    if (xy(1) + win_size(1)) >= x
        xy(1) = 1;
        xy(2) = xy(2) + idivide(win_size(2), int32(2));
        if (xy(2) + win_size(2))  >= y
            break
        end
    end
end
pr = pr_prediction;
celldisp(window);
