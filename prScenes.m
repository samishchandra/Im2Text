tic

fprintf('<START OF EXECUTION>\n');

imgDir= 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';
postsFilename = 'C:\Users\KSC\Desktop\filenames.txt';
qPostsFilename = 'C:\Users\KSC\Desktop\qfilenames.txt';


[postsArray, scenesArray] = LoadPostsAndScenesArray(postsFilename);

[postsScenes] = GetPostsScenes(postsArray, scenesArray, imgDir);
% postsScenes is organized in the following format
% {
%   postId,
%   postName,
%   list{sceneName, score},
%   26 dimensional vector of scores
% }
fprintf('Computed postsScenes!!');
fprintf('length(postsScenes)=%d\n', length(postsScenes));



fprintf('\nTesting phase!!\n');


[qPostsArray, qScenesArray] = LoadPostsAndScenesArray(qPostsFilename);

[qPostsScenes] = GetPostsScenes(qPostsArray, qScenesArray, imgDir);
% qPostsScenes is organized in the following format
% {
%   postId,
%   postName,
%   list{sceneName, score},
%   26 dimensional vector of scores
% }
fprintf('Computed qPostsScenes!!');
fprintf('length(qPostsScenes)=%d\n', length(qPostsScenes));


prPostsScenes = {};
% prPostsScenes is organised in the following format
% {
%     postId,
%     postName,
%     sceneVector,
%     list{probability, postId, postName, sceneVector}
% }


for i=1:length(qPostsScenes) % total posts
    prPostsScenes{i}{1} = qPostsScenes{i}{1};
    prPostsScenes{i}{2} = qPostsScenes{i}{2};
    prPostsScenes{i}{3} = qPostsScenes{i}{4};
    prPostsScenes{i}{4} = {};
    qSceneVector = qPostsScenes{i}{4};
    
    for j=1:length(postsScenes)
        sceneVector = postsScenes{j}{4};
        edist = sqrt(sum((qSceneVector - sceneVector).^2));
        prPostsScenes{i}{4}{j}{1} = edist;
        prPostsScenes{i}{4}{j}{2} = postsScenes{j}{1};
        prPostsScenes{i}{4}{j}{3} = postsScenes{j}{2};
        prPostsScenes{i}{4}{j}{4} = postsScenes{j}{4};
    end
    fprintf('%d\n', i);
%     break
end

save(strcat('prPostsScenes_', currentTime()), 'prPostsScenes');
 
% vars  = load('prPostsScenes_20121232504');
% objCategories = vars.prPostsScenes;



post = prPostsScenes{1};
results = {};
prPosts{1}{1}, prPostsScenes{1}{2}
for i=1:length(post{4})
    s = post{4}{i};
    results{end+1, 1} = sprintf('%f \t %d \t %s\n', s{1},  s{2}, s{3});
end


fprintf('\n<END OF EXECUTION>\n')

toc