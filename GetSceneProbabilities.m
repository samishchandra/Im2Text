function [sceneProbabilities] = GetSceneProbabilities(posts, scenes, postFilenames, qPostsFilenames, imgDir)
    % Get the probabilities of images based on scene estimation
   
    [postsArray, scenesArray] = LoadPostsAndScenesArray(posts, scenes, postFilenames);
    
    fprintf('#postsArray = %d, #postsArray{1}= %d\n', length(postsArray), length(postsArray{1}));
    fprintf('#scenesArray = %d, #scenesArray{1}= %d\n', length(scenesArray), length(scenesArray{1}));
    
    [postsScenes] = GetPostsScenes(postsArray, scenesArray, imgDir);
    % postsScenes is organized in the following format
    % {
    %   postId,
    %   postName,
    %   list{sceneName, score},
    %   26 dimensional vector of scores
    % }
    fprintf('Computed postsScenes!!\n');
    fprintf('length(postsScenes)=%d\n', length(postsScenes));


    fprintf('\nTesting phase!!\n');

    [qPostsArray, qScenesArray] = LoadPostsAndScenesArray(posts, scenes, qPostsFilenames);

    fprintf('#qPostsArray = %d, #qPostsArray{1}= %d\n', length(qPostsArray), length(qPostsArray{1}));
    fprintf('#qScenesArray = %d, #qScenesArray{1}= %d\n', length(qScenesArray), length(qScenesArray{1}));
    
    [qPostsScenes] = GetPostsScenes(qPostsArray, qScenesArray, imgDir);
    % qPostsScenes is organized in the following format
    % {
    %   postId,
    %   postName,
    %   list{sceneName, score},
    %   26 dimensional vector of scores
    % }
    fprintf('Computed qPostsScenes!!\n');
    fprintf('length(qPostsScenes)=%d\n', length(qPostsScenes));

    e = 2.718;
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
            prPostsScenes{i}{4}{j}{1} = e^(-edist);
            prPostsScenes{i}{4}{j}{2} = postsScenes{j}{1};
            prPostsScenes{i}{4}{j}{3} = postsScenes{j}{2};
            prPostsScenes{i}{4}{j}{4} = postsScenes{j}{4};
        end
        fprintf('%d\n', i);
    %     break
    end
    fprintf('Computed probabilities scenes in the query images!!');
    
    save(strcat('prPostsScenes_', currentTime()), 'prPostsScenes');

    % vars  = load('prPostsScenes_20121232504');
    % objCategories = vars.prPostsScenes;

    sceneProbabilities = prPostsScenes;
% 
% 
%     post = prPostsScenes{1};
%     results = {};
%     prPosts{1}{1}, prPostsScenes{1}{2}
%     for i=1:length(post{4})
%         s = post{4}{i};
%         results{end+1, 1} = sprintf('%f \t %d \t %s\n', s{1},  s{2}, s{3});
%     end

end

