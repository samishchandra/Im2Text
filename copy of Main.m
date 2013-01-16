% Main file


fprintf('<START EXECUTION>\n')

imgDir= 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';

postsDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\posts';
postsFile = '0000.txt';
postsFilePath = strcat(postsDir, '\', postsFile);

objDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\objects';
objFile = '0000.txt';
objFilePath = strcat(objDir, '\', objFile);


imgList = dir(strcat(imgDir, '*.jpg'));
%imgList = imgList(1:5);

% objCategories is organized in the following format
% {
%     categoryName,
%     list{postId, fileName, x0, y0, x1, y1, score, histVisualWords{}},
%     clusters{}
% }
objCategories = GetObjCategories(postsFilePath, objFilePath, imgDir);
fprintf('size(objCategories) = %d\n', length(objCategories));

K = 1000;
clusters = {}; %cell(1, length(objCategories));

for i = 1:length(objCategories) % total no of oject categories
    hog = {}; %cell(1, length(objCategories{i}{2}));
    noOfWindows = length(objCategories{i}{2});
    
    for j = 1:noOfWindows % no of files in which object occurred
        cellArr = objCategories{i}{2}{j};
        imgPath = cellArr{2};
        if(exist(imgPath, 'file'))
            desc = HOGDescriptor(imgPath, cellArr{4}, cellArr{3}, cellArr{6}, cellArr{5});
            [x, y, z] = size(desc);
            hog{j} = transpose(reshape(desc, x*y, z));
        else
            fprintf('imgPath = %s, not found!!', imgPath);
        end
    end
    
    mhog = cell2mat(hog);
    
    [clusters{i}, a] = vl_kmeans(mhog, min(K, length(mhog)));
    objCategories{i}{3} = clusters{i};
    
    hist_img = zeros(noOfWindows, K);
    for j=1:noOfWindows
        cellArr = objCategories{i}{2}{j};
        M = vl_ubcmatch(hog{j}, clusters{i});
        for l=1:K
            hist_img(j, l) = sum(M(2,:) == l);
        end
        
        
        
        objCategories{i}{2}{j}{8} = hist_img(j, :);
    end
    
    fprintf('%s, %d\n', objCategories{i}{1}, length(mhog));
%     size(clusters{i})
%     size(hist_img)
%     break
end


fprintf('\nTesting phase\n');
qPostsFile = '0001.txt';
qPostsFilePath = strcat(postsDir, '\', qPostsFile);

qObjFile = '0001.txt';
qObjFilePath = strcat(objDir, '\', qObjFile);

% qObjectCategories is organized in the following format
% {
%     categoryName,
%     list{fileName, x0, y0, x1, y1, score}
% }
qObjectCategories = GetObjCategories(qPostsFilePath, qObjFilePath, imgDir);
fprintf('length(qObjCategories) = %d\n', length(qObjectCategories));

% qPosts is organized in the following format
% {
%     postId,
%     postFile,
%     list{objCategory, x0, y0, x1, y1, score}
% }
qPosts = GetPosts(qObjectCategories);
fprintf('length(qPosts) = %d\n', length(qPosts));

prPosts = {};

for i=1:length(qPosts) % total images
    prPosts{i} = {};
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
            fprintf('clusters not found for category %s\n', objCategoryName);
            continue;
        end
        
        % extract HOG descriptors for the query image
        desc = HOGDescriptor(imgPath, cellArr{3}, cellArr{2}, cellArr{5}, cellArr{4});
        [x, y, z] = size(desc);
        hog = transpose(reshape(desc, x*y, z));
        
        % form the visual word histogram
        hist_window = zeros(1, K);
        M = vl_ubcmatch(hog, clusters);
        for l=1:K
            hist_window(1, l) = sum(M(2,:) == l);
        end
        
        % compute the Euclidean distance between the visual word histograms
        % and thus compute the probability
        for k=1:length(objCategories{objCategoryIndex}{2})
            hist_dbImg = objCategories{objCategoryIndex}{2}{k}{8};
            edist = sqrt(sum((hist_window - hist_dbImg).^2));
            prPosts{i}{end+1}{1} = j;
            prPosts{i}{end}{2} = objCategoryName;
            prPosts{i}{end}{3} = edist;
            prPosts{i}{end}{4} = k;
            prPosts{i}{end}{5} = objCategories{objCategoryIndex}{2}{k}{2};            
        end
     
    end
end



% finalImg = {};
% for i = 1:length(objCategories)
%     for j = 1:length(objCategories{i}{2})
% %         objCategories{i}{2}{j}{2}
%         if(exist(objCategories{i}{2}{j}{2}, 'file'))
%             img = imread(objCategories{i}{2}{j}{2});
%             [x, y, z] = size(img);
% %             fprintf('%d, %d ', x, y);
% %             fprintf('%d, ', objCategories{i}{2}{j}{3});
% %             fprintf('%d, ', objCategories{i}{2}{j}{5});
% %             fprintf('%d, ', objCategories{i}{2}{j}{2});
% %             fprintf('%d \n', objCategories{i}{2}{j}{4});
%             
%             img = img(objCategories{i}{2}{j}{4}:min(x, objCategories{i}{2}{j}{6}), objCategories{i}{2}{j}{3}:min(y, objCategories{i}{2}{j}{5}), :);
% %             fprintf('%f, ', objCategories{i}{2}{j}{6});
%             finalImg{end+1} = img;
%         end
%     end
% end
% 
% 
% length(finalImg)
% for i=1:9
%     subplot(4, 4, i), imshow(finalImg{i+9})
% end
 
% obj = {};
% for i = 1:length(objCategories)
%     obj{i, 1} = objCategories{i}{1};
% end
% obj;

% 

fprintf('\n<END EXECUTION>\n')