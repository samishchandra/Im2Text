function [resultPosts, resultObjs] = LoadPostsAndObjsArray(postsArray, objsArray, postFilenames)
    % return the postsArray and objsArray for the given filesnames in the given
    % filePath
    
    % fid = fopen(filePath);
    % postFilenames = textscan(fid, '%s');
    % fclose(fid);
    % fprintf('#filenames = %d\n', length(postFilenames{1}));
    
    [x, postsIndex] = ismember(postFilenames, postsArray{4});

    % pArray = textscan(fid, '%d %d %d %s %[^\n]');
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

    [objsBit, x] = ismember(objsArray{2}, postIds);

    % oArray = textscan(fid, '%d %d %[^\t] %d %d %d %d %f', 'BufSize', objFiles(i).bytes);
    % 1	1	chair	25	195	218	437	0.382010

    resultObjs = cell(1, 8);
    for i=1:length(objsBit)
        if(objsBit(i) == 1)
            resultObjs{1}(end+1, 1) = objsArray{1}(i);
            resultObjs{2}(end+1, 1) = objsArray{2}(i);
            resultObjs{3}{end+1, 1} = objsArray{3}{i};
            resultObjs{4}(end+1, 1) = objsArray{4}(i);
            resultObjs{5}(end+1, 1) = objsArray{5}(i);
            resultObjs{6}(end+1, 1) = objsArray{6}(i);
            resultObjs{7}(end+1, 1) = objsArray{7}(i);
            resultObjs{8}(end+1, 1) = objsArray{8}(i);
        end
    end
    
end

