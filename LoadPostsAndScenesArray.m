function [resultPosts, resultScenes] = LoadPostsAndScenesArray(postsArray, scenesArray, postFilenames)
    % return the postsArray and objsArray for the given filenames in the given
    % filePath

    %     fid = fopen(filePath);
    %     postFilenames = textscan(fid, '%s');
    %     fclose(fid);
    %     fprintf('#filenames = %d\n', length(postFilenames{1}));

    %     vars = load('postsArray');
    %     postsArray = vars.postsArray;
    % 
    %     vars = load('scenesArray');
    %     scenesArray = vars.scenesArray;

    [x, postsIndex] = ismember(postFilenames, postsArray{4});

    %     pArray = textscan(fid, '%d %d %d %s %[^\n]');
    % 1	342	512	http://static.flickr.com/2723/4385058960_b0f291553e.jpg	A wooden chair in the living room

    resultPosts = cell(1, 5);
    for i=1:length(postsIndex)
        resultPosts{1}(end+1, 1) = postsArray{1}(postsIndex(i));
        resultPosts{2}(end+1, 1) = postsArray{2}(postsIndex(i));
        resultPosts{3}(end+1, 1) = postsArray{3}(postsIndex(i));
        resultPosts{4}{end+1, 1} = postsArray{4}{postsIndex(i)};
        resultPosts{5}{end+1, 1} = postsArray{5}{postsIndex(i)};
    end

    postIds = resultPosts{1};

    [scenesBit, x] = ismember(scenesArray{2}, postIds);

    % oArray = textscan(fid, '%d %d %[^\t] %f');
    % 31776	32001	river	-0.131021

    resultScenes = cell(1, 4);
    for i=1:length(scenesBit)
        if(scenesBit(i) == 1)
            resultScenes{1}(end+1, 1) = scenesArray{1}(i);
            resultScenes{2}(end+1, 1) = scenesArray{2}(i);
            resultScenes{3}{end+1, 1} = scenesArray{3}{i};
            resultScenes{4}(end+1, 1) = scenesArray{4}(i);
        end
    end
    
end

