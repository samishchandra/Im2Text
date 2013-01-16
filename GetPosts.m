function [posts] = GetPosts(objCategories)
    % Used to return a cell array of posts and their corresponding categories
    
    posts = {};
    % posts is organized in the following format
    % list
    % {
    %     postId,
    %     postFile,
    %     list{objCategoryName, x0, y0, x1, y1, score}
    % }
    
    for i = 1:length(objCategories) % total no of oject categories
        noOfWindows = length(objCategories{i}{2});
        for j = 1:noOfWindows % no of files in which object occurred
            cellArr = objCategories{i}{2}{j};
            postId = cellArr{1};
            imgPath = cellArr{2};

            postIndex = 0;
            % find the postIndex by postId
            for k=1:length(posts)
                if(posts{k}{1} == postId)
                    postIndex = k;
                    break;
                end
            end

            if(postIndex == 0)
                posts{end+1}{1} = postId;
                posts{end}{2} = imgPath;
                posts{end}{3} = {};
                postIndex = length(posts);
            end

            posts{postIndex}{3}{end+1}{1} = objCategories{i}{1};
            posts{postIndex}{3}{end}{2} = cellArr{3};
            posts{postIndex}{3}{end}{3} = cellArr{4};
            posts{postIndex}{3}{end}{4} = cellArr{5};
            posts{postIndex}{3}{end}{5} = cellArr{6};
            posts{postIndex}{3}{end}{6} = cellArr{7};
        end
    end
end

