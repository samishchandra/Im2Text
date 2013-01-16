% Main file

fprintf('<START OF EXECUTION>\n');

imgDir= 'D:\Dropbox\Study\Fall12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';
postsFilename = 'C:\Users\KSC\Desktop\filenames.txt';
qPostsFilename = 'C:\Users\KSC\Desktop\qfilenames.txt';

fid = fopen(postsFilename);
postsFilenames = textscan(fid, '%s');
fclose(fid);
fprintf('#filenames = %d\n', length(postsFilenames{1}));

fid = fopen(qPostsFilename);
qPostsFilenames = textscan(fid, '%s');
fclose(fid);
fprintf('#filenames = %d\n', length(qPostsFilenames{1}));

tic
fprintf('Loading required arrays...\n');
[posts, objs, scenes] = LoadArrays();
fprintf('Arrays loaded!!\n');
toc

% objProbabilities is organised in the following format
% list
% {
%     postId,
%     postName,
%     list{objCategoryName, x0, y0, x1, y1, score, list{edist, postId, postName}}
% }
tic
fprintf('Computing Object probabilities...\n');
[objProbabilities] = GetObjProbabilities(posts, objs, postsFilenames{1}, qPostsFilenames{1}, imgDir);
fprintf('Completed Object probabilities!!\n')
toc

objProb = {};
objResult = {};
for i=1:length(objProbabilities)
    for j=1:length(objProbabilities{i}{3})
        obj = objProbabilities{i}{3}{j};
        objName = obj{1};
        for k=1:length(objProbabilities{i}{3}{j}{7})
            objMatch = objProbabilities{i}{3}{j}{7}{k};
            objResult{end+1, 1} = sprintf('%f, %s, %s, %d\n', objMatch{1}, objName, objMatch{3}, objMatch{2});
            objProb{end+1}{1} = objMatch{1};
            objProb{end}{2} = objName;
            objProb{end}{3} = objMatch{3};
            objProb{end}{4} = objMatch{2};
        end
    end
end

objResult = sort(objResult);
fprintf('%s', objResult{:})

% sceneProbabilities is organised in the following format
% {
%     postId,
%     postName,
%     sceneVector,
%     list{probability, postId, postName, sceneVector}
% }
tic
fprintf('Computing Scene probabilities...\n');
[sceneProbabilities] = GetSceneProbabilities(posts, scenes, postFilenames{1}, qPostsFilenames{1}, imgDir);
fprintf('Completed Scene probabilities!!\n')
toc

scenesProb = {};
scenesResult = {};
for i=1:length(sceneProbabilities)
    for j=1:length(sceneProbabilities{i}{4})
        sceneMatch = sceneProbabilities{i}{4}{j};
        scenesResult{end+1}{1} = sprintf('%f, %s, %d\n', sceneMatch{1}, sceneMatch{3}, sceneMatch{2});
        scenesProb{end+1}{1} = sceneMatch{1};
        scenesProb{end}{2} = sceneMatch{3};
        scenesProb{end}{3} = sceneMatch{2};
    end
end

scenesResult = sort(scenesResult);
fprintf('%s', scenesResult{:})



fprintf('\n<END OF EXECUTION>\n')

toc

% 
% [postsArray, objsArray] = LoadPostsAndObjsArray(postsFilename);
% 
% [objCategories] = GetObjCategories(postsArray, objsArray, imgDir);
% % objCategories is organized in the following format
% % list
% % {
% %     categoryName,
% %     list{postId, fileName, x0, y0, x1, y1, score, histVisualWords{}},
% %     clusters{}
% % }
% fprintf('Computed objCategories!!');
% 
% splitSize = 2; % used for creating spatial pyramid histogram
% K = 1000;
% e = 2.718;
% 
% for i = 1:length(objCategories) % total no of oject categories
%     hog = {};
%     hogDesc = {};
%     clusters = {};
%     noOfWindows = length(objCategories{i}{2});
%     
%     for j = 1:noOfWindows % no of files in which object occurred
%         cellArr = objCategories{i}{2}{j}; % represents one window
%         imgPath = cellArr{2};
%         if(exist(imgPath, 'file'))
%             hogDesc{j} = HOGDescriptor(imgPath, cellArr{4}, cellArr{3}, cellArr{6}, cellArr{5}, splitSize);
%             hog{j} = hogDesc{j}{1};
%         else
%             imgName = regexp(imgPath, '\', 'split');
%             fprintf('File not found!! imgName=%s, postId=%d, categoryName=%s\n', imgName{end}, cellArr{1}, objCategories{i}{1});
%         end
%     end
%     
%     % cluster using kmeans
%     mhog = cell2mat(hog);
%     [clusters, a] = vl_kmeans(mhog, min(K, length(mhog)));
%     objCategories{i}{3} = clusters;
%     
%     for j=1:noOfWindows
%         hist_img = [];
%         cellArr = objCategories{i}{2}{j};
%         % compute histogram of visual words for spatial pyramids
%         for i1=1:length(hogDesc{j})
%             hist = zeros(1, K);
%             M = vl_ubcmatch(hogDesc{j}{i1}, clusters);
%             for l=1:K
%                 hist(1, l) = sum(M(2,:) == l);
%             end
%             hist_img = [hist_img hist];
%         end
%         
%         objCategories{i}{2}{j}{8} = hist_img./sumabs(hist_img);
%     end
%     
%     fprintf('%s, %d\n', objCategories{i}{1}, length(mhog));
% %     size(clusters)
% %     size(hist_img)
% %     break
% end
% fprintf('\nCompleted K-means clustering!!\n');
% 
% save(strcat('objCategories_clustered_', currentTime()), 'objCategories');
%  
% % vars  = load('objCategories_clustered_20121232504');
% % objCategories = vars.objCategories;
% 
% 
% 
% fprintf('\nTesting phase!!\n');
% 
% [qPostsArray, qObjsArray] = LoadPostsAndObjsArray(qPostsFilename);
% 
% [qObjectCategories] = GetObjCategories(qPostsArray, qObjsArray, imgDir);
% % qObjectCategories is organized in the following format
% % list
% % {
% %     categoryName,
% %     list{fileName, x0, y0, x1, y1, score}
% % }
% fprintf('Computed query objCategories!!');
% 
% qPosts = GetPosts(qObjectCategories);
% % qPosts is organized in the following format
% % list
% % {
% %     postId,
% %     postName,
% %     list{objCategoryName, x0, y0, x1, y1, score}
% % }
% fprintf('Computed query posts!!');
% 
% prPosts = {};
% % prPosts is organised in the following format
% % list
% % {
% %     postId,
% %     postName,
% %     list{objCategoryName, x0, y0, x1, y1, score, list{edist, postId, postName}}
% % }
% 
% 
% fprintf('length(qObjCategories) = %d\n', length(qObjectCategories));
% fprintf('length(qPosts) = %d\n', length(qPosts));
% 
% 
% for i=1:length(qPosts) % total images
%     prPosts{i} = qPosts{i};
%     imgPath = qPosts{i}{2};
%     
%     for j=1:length(qPosts{i}{3}) % total windows/objects detected in the image
%         cellArr = qPosts{i}{3}{j};
%         objCategoryName = cellArr{1};
%         
%         % get the corresponding clusters for the category
%         objCategoryIndex =0;
%         clusters = {};
%         
%         for k=1:length(objCategories)
%             if(strcmp(objCategories{k}{1}, objCategoryName) > 0)
%                 objCategoryIndex = k;
%                 clusters = objCategories{k}{3};
%                 break;
%             end
%         end
%         
%         if(objCategoryIndex == 0)
%             fprintf('clusters not found for category=%s, postId=%d\n', objCategoryName, qPosts{i}{1});
%             continue;
%         end
%         
%         prPosts{i}{3}{j}{7} = {};
%         
%         % extract HOG descriptors for the query image
%         try
%             hogDesc = HOGDescriptor(imgPath, cellArr{3}, cellArr{2}, cellArr{5}, cellArr{4}, splitSize);
%         catch
%             continue;
%         end
%         
%         % form the visual word histogram
%         hist_window = [];
%         for i1=1:length(hogDesc)
%             hist = zeros(1, K);
%             M = vl_ubcmatch(hogDesc{i1}, clusters);
%             for l=1:K
%                 hist(1, l) = sum(M(2,:) == l);
%             end
%             hist_window = [hist_window hist];
%         end
%         
%         hist_window = hist_window./sumabs(hist_window);
%         
%         % compute the Euclidean distance between the visual word histograms
%         % and thus compute the probability
%         for k=1:length(objCategories{objCategoryIndex}{2})
%             hist_dbImg = objCategories{objCategoryIndex}{2}{k}{8};
%             edist = sqrt(sum((hist_window - hist_dbImg).^2));
%             prPosts{i}{3}{j}{end}{k}{1} = e^(-edist);
%             prPosts{i}{3}{j}{end}{k}{2} = objCategories{objCategoryIndex}{2}{k}{1};
%             prPosts{i}{3}{j}{end}{k}{3} = objCategories{objCategoryIndex}{2}{k}{2};
%         end 
%     end
%     fprintf('%d\n', i);
% end
% fprintf('Computed probabilities for each window in the query images!!');
% 
% save(strcat('prPosts_objCategories_', currentTime()), 'prPosts');
%  
% % vars  = load('prPosts_objCategories_20121232504');
% % objCategories = vars.prPosts;
% 
% % 
% % result= {};pr
% % prPosts{1}{1}, prPosts{1}{2}
% % for i=1:length(prPosts{1}{3})
% %     object = prPosts{1}{3}{i};
% %     for j=1:length(object{7})
% %         result{end+1, 1} = sprintf('%s \t %f \t %d \t %s\n', object{1},  object{7}{j}{1}, object{7}{j}{2}, object{7}{j}{3});
% %     end
% % end
% 
% 
% 
