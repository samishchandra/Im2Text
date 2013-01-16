% save the scene types for later use

tic

si = 11;
ei = 20;

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

sceneDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\scenes\';
sceneFiles = dir(strcat(sceneDir, '*.txt'));
sceneFiles = sceneFiles(si:ei);

scenesArray = cell(1, 4);
for i=1:length(postsFiles)
    fid = fopen(strcat(sceneDir, sceneFiles(i).name));
    oArray = textscan(fid, '%d %d %[^\t] %f');
    fclose(fid);
    for j=1:length(oArray)
        scenesArray{j} = [scenesArray{j};oArray{j}];
    end
end

fprintf('#postsArray = %d, #postsArray{1}= %d\n', length(postsArray), length(postsArray{1}));
fprintf('#scenesArray = %d, #scenesArray{1}= %d\n', length(scenesArray), length(scenesArray{1}));

posts = {};
% posts is organized in the following format
% {
%     postId,
%     postName,
%     list{sceneType, score}
%     
% }

for i=1:length(postsArray{1})
    postId = postsArray{1}(i);
    postName = postsArray{4}{i};
    posts{i}{1} = postId;
    
    splits = regexp (postName, '/', 'split');
    posts{i}{2} = strcat(imgDir, '\', splits{end-1}, '_', splits{end});
    
    posts{i}{3} = {};

    % find the sceneTypes by postId
    for k=1:length(scenesArray{1})
        if(scenesArray{2}(k) == postId)
            posts{i}{3}{end+1}{1} = scenesArray{3}{k}; % sceneType
            posts{i}{3}{end}{2} = scenesArray{4}(k); % score
        end
    end
    fprintf('%d\n', i);
    
end

vars = load('sceneTypes', 'sceneTypes');
sceneTypes = vars.sceneTypes
lenSceneTypes = length(sceneTypes);

for i=1:length(posts)

	posts{i}{4} = zeros(1, lenSceneTypes);

    for j=1:length(posts{i}{3})
    	cellArr = posts{i}{3}{j};
    	sceneType = cellArr{1};
    	score = cellArr{2};
    	[x, y] = ismember(sceneType, sceneTypes);
    	posts{i}{4}(y) = score;
    end
    fprintf('%d\n', i);
end


save(strcat('posts_scenes_', num2str(ei)), 'posts');
fprintf('saved posts!!\n');
fprintf('length(posts) = %d\n', length(posts));

toc

% 
% for i=1:length(posts)
%     if(length(posts{i}{3})>1)
%         imgName = regexp(posts{i}{2}, '\', 'split');
%         fprintf('%d, %d, %s\n', i, posts{i}{1}, imgName{end});
%         break;
%     end
% end


