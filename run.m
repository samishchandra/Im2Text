% Run file

tic

fprintf('<START OF EXECUTION>\n')

debugFlag = false;

imgDir= 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';

postsDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\posts';
postsFile = '0000.txt';
postsFilePath = strcat(postsDir, '\', postsFile);

objDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\objects';
objFile = '0000.txt';
objFilePath = strcat(objDir, '\', objFile);


% objCategories is organized in the following format
% list
% {
%     categoryName,
%     list{postId, fileName, x0, y0, x1, y1, score, histVisualWords{}},
%     clusters{}
% }

if(~debugFlag)
    fprintf('Running in non-debug mode!!\n');
    objCategories = GetObjCategories(postsFilePath, objFilePath, imgDir);
    fprintf('length(objCategories) = %d\n', length(objCategories));
else
    fprintf('Running in debug mode!!\n');
    load('objCategories_10', 'objCategories');
    fprintf('length(objCategories) = %d\n', length(objCategories));
end

splitSize = 2; % used for creating spatial pyramid histogram
K = 1000;

for i = 1:length(objCategories) % total no of oject categories
    hog = {};
    hogDesc = {};
    clusters = {};
    noOfWindows = length(objCategories{i}{2});
    
    for j = 1:noOfWindows % no of files in which object occurred
        cellArr = objCategories{i}{2}{j}; % represents one window
        imgPath = cellArr{2};
        if(exist(imgPath, 'file'))
            hogDesc{j} = HOGDescriptor(imgPath, cellArr{4}, cellArr{3}, cellArr{6}, cellArr{5}, splitSize);
            hog{j} = hogDesc{j}{1};
        else
            imgName = regexp(imgPath, '\', 'split');
            fprintf('File not found!! imgName=%s, postId=%d, categoryName=%s\n', imgName{end}, cellArr{1}, objCategories{i}{1});
        end
    end
    
    % cluster using kmeans
    mhog = cell2mat(hog);
    [clusters, a] = vl_kmeans(mhog, min(K, length(mhog)));
    objCategories{i}{3} = clusters;
    
    for j=1:noOfWindows
        hist_img = [];
        cellArr = objCategories{i}{2}{j};
        % compute histogram of visual words for spatial pyramids
        for i1=1:length(hogDesc{j})
            hist = zeros(1, K);
            M = vl_ubcmatch(hogDesc{j}{i1}, clusters);
            for l=1:K
                hist(1, l) = sum(M(2,:) == l);
            end
            hist_img = [hist_img hist];
        end
        
        objCategories{i}{2}{j}{8} = hist_img./sumabs(hist_img);
    end
    
    fprintf('%s, %d\n', objCategories{i}{1}, length(mhog));
%     size(clusters)
%     size(hist_img)
%     break
end
fprintf('\nCompleted K-means clustering!!\n');

save(strcat('objCategories_clustered_', currentTime()), 'objCategories');
 
% vars  = load('objCategories_clustered_20121232504');
% objCategories = vars.objCategories;



fprintf('\nTesting phase!!\n');
qPostsFile = '0001.txt';
qPostsFilePath = strcat(postsDir, '\', qPostsFile);

qObjFile = '0001.txt';
qObjFilePath = strcat(objDir, '\', qObjFile);

if(~debugFlag)
    fprintf('Running in non-debug mode!!\n');
    qObjectCategories = GetObjCategories(qPostsFilePath, qObjFilePath, imgDir);
    qPosts = GetPosts(qObjectCategories);
else
    fprintf('Running in debug mode!!\n');
    vars = load('objCategories_20');
    qObjectCategories = vars.objCategories;
    vars = load('posts_objs_20');
    qPosts = vars.posts;
end


% qObjectCategories is organized in the following format
% list
% {
%     categoryName,
%     list{fileName, x0, y0, x1, y1, score}
% }

% qPosts is organized in the following format
% list
% {
%     postId,
%     postName,
%     list{objCategoryName, x0, y0, x1, y1, score}
% }

prPosts = {};
% prPosts is organised in the following format
% list
% {
%     postId,
%     postName,
%     list{objCategoryName, x0, y0, x1, y1, score, list{edist, postId, postName}}
% }



fprintf('length(qObjCategories) = %d\n', length(qObjectCategories));
fprintf('length(qPosts) = %d\n', length(qPosts));

for i=1:length(qPosts) % total images
    prPosts{i} = qPosts{i};
    imgPath = qPosts{i}{2};
    
    for j=1:length(qPosts{i}{3}) % total windows/objects detected in the image
        cellArr = qPosts{i}{3}{j};
        objCategoryName = cellArr{1};
        
        % get the corresponding clusters for the category
        objCategoryIndex =0;
        clusters = {};
        
        for k=1:length(objCategories)
            if(strcmp(objCategories{k}{1}, objCategoryName) > 0)
                objCategoryIndex = k;
                clusters = objCategories{k}{3};
                break;
            end
        end
        
        if(objCategoryIndex == 0)
            fprintf('clusters not found for category=%s, postId=%d\n', objCategoryName, qPosts{i}{1});
            continue;
        end
        
        prPosts{i}{3}{j}{7} = {};
        
        % extract HOG descriptors for the query image
        try
            hogDesc = HOGDescriptor(imgPath, cellArr{3}, cellArr{2}, cellArr{5}, cellArr{4}, splitSize);
        catch
            continue;
        end
        
        % form the visual word histogram
        hist_window = [];
        for i1=1:length(hogDesc)
            hist = zeros(1, K);
            M = vl_ubcmatch(hogDesc{i1}, clusters);
            for l=1:K
                hist(1, l) = sum(M(2,:) == l);
            end
            hist_window = [hist_window hist];
        end
        
        hist_window = hist_window./sumabs(hist_window);
        
        % compute the Euclidean distance between the visual word histograms
        % and thus compute the probability
        for k=1:length(objCategories{objCategoryIndex}{2})
            hist_dbImg = objCategories{objCategoryIndex}{2}{k}{8};
            edist = sqrt(sum((hist_window - hist_dbImg).^2));
            prPosts{i}{3}{j}{end}{k}{1} = edist;
            prPosts{i}{3}{j}{end}{k}{2} = objCategories{objCategoryIndex}{2}{k}{1};
            prPosts{i}{3}{j}{end}{k}{3} = objCategories{objCategoryIndex}{2}{k}{2};            
        end 
    end
    fprintf('%d\n', i);
end


save(strcat('prPosts_objCategories_', currentTime()), 'prPosts');
 
% vars  = load('prPosts_objCategories_20121232504');
% objCategories = vars.prPosts;

% 
% result= {};
% prPosts{1}{1}, prPosts{1}{2}
% for i=1:length(prPosts{1}{3})
%     object = prPosts{1}{3}{i};
%     for j=1:length(object{7})
%         result{end+1, 1} = sprintf('%s \t %f \t %d \t %s\n', object{1},  object{7}{j}{1}, object{7}{j}{2}, object{7}{j}{3});
%     end
% end



fprintf('\n<END OF EXECUTION>\n')

toc
