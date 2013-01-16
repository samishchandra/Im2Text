

vars = load('posts_scenes_10');
posts = vars.posts;
fprintf('length(posts) = %d\n', length(posts));
% posts is organized in the following format
% {
%     postId,
%     postName,
%     list{sceneType, score}
% }

% cell array containing the distinct scene types
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
