% save the object categories for later use

tic

si = 1;
ei = 1;

imgDir= 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';

postsDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\posts\';
postsFiles = dir(strcat(postsDir, '*.txt'));
postsFiles = postsFiles(si:ei);

% read and concatenate all the postsArray
postsArray = cell(1, 5);
for i=1:length(postsFiles)
    fid = fopen(strcat(postsDir, postsFiles(i).name));
    pArray = textscan(fid, '%d %d %d %s %[^\n]');
    fclose(fid);
    for j=1:length(pArray)
        postsArray{j} = [postsArray{j};pArray{j}];
    end
end

objDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\objects\';
objFiles = dir(strcat(objDir, '*.txt'));
objFiles = objFiles(si:ei);

objsArray = cell(1, 8);
for i=1:length(postsFiles)
    fid = fopen(strcat(objDir, objFiles(i).name));
    oArray = textscan(fid, '%d %d %[^\t] %d %d %d %d %f');
    fclose(fid);
    for j=1:length(oArray)
        objsArray{j} = [objsArray{j};oArray{j}];
    end
end

fprintf('#postsArray = %d, #postsArray{1}= %d\n', length(postsArray), length(postsArray{1}));
fprintf('#objsArray = %d, #objsArray{1}= %d\n', length(objsArray), length(objsArray{1}));

objCategories = {};
% objCategories is organized in the following format
% {
%     categoryName,
%     list{fileName, x0, y0, x1, y1, score, histVisualWords{}},
%     clusters{}
% }

for i=1:length(objsArray{1})
    categoryIndex = 0;
    postIndex = 0;

    postId = objsArray{2}(i);
    objCategoryName = objsArray{3}{i};
    x0 = objsArray{4}(i);
    y0 = objsArray{5}(i);
    x1 = objsArray{6}(i);
    y1 = objsArray{7}(i);
    score = objsArray{8}(i);

    % find the categoryIndex by categoryName
    for k=1:length(objCategories)
        if(strcmp(objCategories{k}{1}, objCategoryName) > 0)
            categoryIndex = k;
            break;
        end
    end

    if(categoryIndex == 0)
        objCategories{end+1}{1} = objCategoryName;
        objCategories{end}{2} = {};
        categoryIndex = length(objCategories);
    end

    % find the postIndex by postId, to fetch the filename
    for k=1:length(postsArray{1})
        if(postsArray{1}(k) == postId)
            postIndex = k;
            break;
        end
    end

    if(postIndex <= 0)
        fprintf('Warning!! postId=%d not found\n', postId);
        break;
    end

    % to consider one objectCategory occurrence per image, i.e. not considering two
    % 'chairs' in one image
    fileIndex = 0;
    updateFlag = true;

    for k=1:length(objCategories{categoryIndex}{2})
        if(objCategories{categoryIndex}{2}{k}{1} == postId)
            fileIndex = k;
            break
        end
    end

    if(fileIndex == 0)
        objCategories{categoryIndex}{2}{end+1}{1} = postId;
        fileIndex = length(objCategories{categoryIndex}{2});
    else
         prevScore = objCategories{categoryIndex}{2}{fileIndex}{7};
         if(prevScore > score)
            updateFlag = false;
         end
    end

    % update the fields if the prev score is low, may be better object detection
    % in the image
    if(updateFlag)
        splits = regexp (postsArray{4}(postIndex), '/', 'split');
        fullFilename = splits{length(splits)};

        objCategories{categoryIndex}{2}{fileIndex}{2} = strcat(imgDir, '\', fullFilename{end-1}, '_', fullFilename{end});
        objCategories{categoryIndex}{2}{fileIndex}{3} = x0;
        objCategories{categoryIndex}{2}{fileIndex}{4} = y0;
        objCategories{categoryIndex}{2}{fileIndex}{5} = x1;
        objCategories{categoryIndex}{2}{fileIndex}{6} = y1;
        objCategories{categoryIndex}{2}{fileIndex}{7} = score;
    end
    fprintf('%d\n', i);
end

save(strcat('objCategories_', currentTime()), 'objCategories');
fprintf('saved objCategories!!\n');
fprintf('length(objCategories) = %d\n', length(objCategories));

posts = GetPosts(objCategories);
save(strcat('posts_objCategories_', currentTime()), 'posts');
fprintf('saved posts!!\n');
fprintf('length(posts) = %d\n', length(posts));


toc