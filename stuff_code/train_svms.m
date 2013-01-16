addpath(genpath('libsvm/matlab'));

categories={'building','grass','road','sky','tree','water'};
histograms = cell(1, length(categories));
clusters = cell(1, length(categories));
tcclusters = cell(1, length(categories));

% for c=1:2
for c=1:length(categories)
    categories{c}
    hogarr = [];
    colarr = [];
    cat = char(categories(c));
    img_dir = strcat('data/', cat);
    
    files = dir(strcat(img_dir,'/*.jpg')); 
    for i=1:length(files)
        filePath = strcat(img_dir, '/',files(i).name);
        % get then name of the file w/o extension
        [~, fileName, ~] = fileparts(filePath);
        box = get_bounding_box(cat, fileName);
        hog = GetHOGDescriptor(filePath, box(1)+1, box(2)+1, box(3)+1, box(4)+1);
        col = GetTcDescriptor(filePath, box(1)+1, box(2)+1, box(3)+1, box(4)+1);
        % if isempty(col)
        %     continue;
        % end

        colarr = [colarr col];
        ncol{i} = length(col(1,:));

        hogarr = [hogarr hog];
        nhog{i} = length(hog(1,:));
    end

    K = 100;
    J = 128;
    display('K means on HOG features');
    [clusters{c}, A] = vl_kmeans(hogarr, K);
    clear hogarr
    display('K means on color features');
    [tcclusters{c}, B] = vl_kmeans(colarr(:,randi(length(colarr),1 , 500000)), J);
    % build hostograms
    n = 1;
    m = 1;
    hist = zeros(length(files), K+J);
    display('building histograms');
    for i=1:length(files)
        assign = A(1,n:n-1+nhog{i});
        color_feat = colarr(:,m:m-1+ncol{i});
        
        n = n + nhog{i};
        m = m + ncol{i};
        for j=1:K
            hist(i,j) = sum(assign == j);
        end
        d = pdist2(transpose(color_feat), transpose(tcclusters{c}), 'euclidean');
        for j=1:length(color_feat)
            [~,ix] = min(d(j,:));
            hist(i,ix+K) = hist(i,ix+K) + 1;
        end
        hist(i,:) = hist(i,:)/norm(hist(i,:));
    end
    hist(isnan(hist)) = 0;
    histograms{c} = hist; 
end 

% for c=1:2
for c=1:length(categories)
    i = [1, 2, 3, 4, 5, 6];
    % i = [1, 2];
    i = i(i~=c);
    neg = [];
    for j=i
        neg = [neg; histograms{j}];
    end
    pos = histograms{c};
    cmd = ['-q -t 0 -b 1'];
    display(strcat('SVM train for', categories(c)));
    cv = svmtrain([ones(length(pos(:,1)), 1); zeros(length(neg(:,1)), 1)], [pos; neg], cmd);
    save(strcat(char(categories(c)),'_svm.mat'), 'cv');
end
save('kmeans_hog_clusters.mat', 'clusters');
save('kmeans_col_clusters.mat', 'tcclusters');
