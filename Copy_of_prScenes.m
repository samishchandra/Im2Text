tic

fprintf('\nTesting phase!!\n');

vars = load('posts_scenes_10');
posts_scenes = vars.posts;
posts_scenes = posts_scenes(1:100);

% posts_scenes is organized in the following format
% {
%   postId,
%   postName,
%   list{sceneName, score},
%   26 dimensional vector of scores
% }
fprintf('length(posts_scenes)=%d\n', length(posts_scenes));


vars = load('posts_scenes_20');
qPosts_scenes = vars.posts;
qPosts_scenes = qPosts_scenes(1:100);

fprintf('length(qPosts_scenes)=%d\n', length(qPosts_scenes));


prPosts = {};
% prPosts is organised in the following format
% {
%     postId,
%     postName,
%     sceneVector,
%     list{probability, postId, postName, sceneVector}
% }


for i=1:length(qPosts_scenes) % total posts
    prPosts{i}{1} = qPosts_scenes{i}{1};
    prPosts{i}{2} = qPosts_scenes{i}{2};
    prPosts{i}{3} = qPosts_scenes{i}{4};
    prPosts{i}{4} = {};
    qSceneVector = qPosts_scenes{i}{4};
    
    for j=1:length(posts_scenes)
        sceneVector = posts_scenes{j}{4};
        edist = sqrt(sum((qSceneVector - sceneVector).^2));
        prPosts{i}{4}{j}{1} = edist;
        prPosts{i}{4}{j}{2} = posts_scenes{j}{1};
        prPosts{i}{4}{j}{3} = posts_scenes{j}{2};
        prPosts{i}{4}{j}{4} = posts_scenes{j}{4};
    end
    fprintf('%d\n', i);
%     break
end

save(strcat('prPosts_scenes_', currentTime()), 'prPosts');
 
% vars  = load('prPosts_scenes_20121232504');
% objCategories = vars.prPosts;


% 
% post = prPosts{1};
% results = {};
% prPosts{1}{1}, prPosts{1}{2}
% for i=1:length(post{4})
%     s = post{4}{i};
%     results{end+1, 1} = sprintf('%f \t %d \t %s\n', s{1},  s{2}, s{3});
% end
% 

toc

