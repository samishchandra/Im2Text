fprintf('\n<START OF EXECUTION>\n')

tic

fprintf('\nTesting phase!!\n');

debugFlag = true;
splitSize = 2;
K = 1000;

% vars  = load('objCategories_clustered_20121232504');
% objCategories = vars.objCategories;
fprintf('length(objCategories) = %d\n', length(objCategories));


if(~debugFlag)
    fprintf('Running in non-debug mode!!\n');
    imgDir= 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';

    postsDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\posts';
    
    qPostsFile = '0001.txt';
    qPostsFilePath = strcat(postsDir, '\', qPostsFile);

    qObjFile = '0001.txt';
    qObjFilePath = strcat(objDir, '\', qObjFile);

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
            prPosts{i}{3}{j}{7}{k}{1} = edist;
            prPosts{i}{3}{j}{7}{k}{2} = objCategories{objCategoryIndex}{2}{k}{1};
            prPosts{i}{3}{j}{7}{k}{3} = objCategories{objCategoryIndex}{2}{k}{2};
        end 
    end
    fprintf('%d\n', i);
%     break
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
