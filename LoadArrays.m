function [postsArray, objsArray, scenesArray] = LoadArrays()
    % used to load the precomputed arrays
    
    vars = load('postsArray');
    postsArray = vars.postsArray;

    vars = load('objsArray');
    objsArray = vars.objsArray;
    
    vars = load('scenesArray');
    scenesArray = vars.scenesArray;
    
    fprintf('#posts = %d, #posts{1}= %d\n', length(postsArray), length(postsArray{1}));
    fprintf('#objs = %d, #objs{1} = %d\n', length(objsArray), length(objsArray{1}));
    fprintf('#scenes = %d, #scenes{1} = %d\n', length(scenesArray), length(scenesArray{1}));    
    
end

