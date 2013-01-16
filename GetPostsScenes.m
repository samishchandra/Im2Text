function [postsScenes] = GetPostsScenes(postsArray, scenesArray, imgDir)
    % Used to retrieve the scene types
    
%     tic
% 
%     fprintf('#postsArray = %d, #postsArray{1}= %d\n', length(postsArray), length(postsArray{1}));
%     fprintf('#scenesArray = %d, #scenesArray{1}= %d\n', length(scenesArray), length(scenesArray{1}));

    postsScenes = {};
    % postsScenes is organized in the following format
    % {
    %     postId,
    %     postName,
    %     list{sceneType, score}
    %     scene vector
    % }

    for i=1:length(postsArray{1})
        postId = postsArray{1}(i);
        postName = postsArray{4}{i};
        postsScenes{i}{1} = postId;

        splits = regexp (postName, '/', 'split');
        postsScenes{i}{2} = strcat(imgDir, '\', splits{end-1}, '_', splits{end});

        postsScenes{i}{3} = {};

        % find the sceneTypes by postId
        for k=1:length(scenesArray{1})
            if(scenesArray{2}(k) == postId)
                postsScenes{i}{3}{end+1}{1} = scenesArray{3}{k}; % sceneType
                postsScenes{i}{3}{end}{2} = scenesArray{4}(k); % score
            end
        end
%         fprintf('%d\n', i);

    end

    % compute the scene vector for each post
    vars = load('sceneTypes', 'sceneTypes');
    sceneTypes = vars.sceneTypes;
    lenSceneTypes = length(sceneTypes);

    for i=1:length(postsScenes)

        postsScenes{i}{4} = zeros(1, lenSceneTypes);

        for j=1:length(postsScenes{i}{3})
            cellArr = postsScenes{i}{3}{j};
            sceneType = cellArr{1};
            score = cellArr{2};
            [x, y] = ismember(sceneType, sceneTypes);
            postsScenes{i}{4}(y) = score;
        end
%         fprintf('%d\n', i);
    end


    save(strcat('postsScenes_', currentTime()), 'postsScenes');
%     fprintf('saved postsScenes!!\n');
%     fprintf('length(postsScenes) = %d\n', length(postsScenes));

    % 
    % for i=1:length(postsScenes)
    %     if(length(postsScenes{i}{3})>1)
    %         imgName = regexp(postsScenes{i}{2}, '\', 'split');
    %         fprintf('%d, %d, %s\n', i, postsScenes{i}{1}, imgName{end});
    %         break;
    %     end
    % end

    
%     toc
    

end

