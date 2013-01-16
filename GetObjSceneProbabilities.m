function [objProb, objResult, scenesProb, scenesResult] = GetObjSceneProbabilities(imgDir, postsFilenames, qPostsFilenames)

    % Get Object and Scene probabilities

    fprintf('<START OF EXECUTION>\n');

%     imgDir= 'D:\Dropbox\Study\Fall12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images';
%     postsFilename = 'C:\Users\KSC\Desktop\filenames.txt';
%     qPostsFilename = 'C:\Users\KSC\Desktop\qfilenames.txt';
% 
%     fid = fopen(postsFilename);
%     postFilenames = textscan(fid, '%s');
%     fclose(fid);
%     fprintf('#filenames = %d\n', length(postFilenames{1}));
% 
%     fid = fopen(qPostsFilename);
%     qPostsFilenames = textscan(fid, '%s');
%     fclose(fid);
%     fprintf('#filenames = %d\n', length(qPostsFilenames{1}));

    tic
    fprintf('Loading required arrays...\n');
    [posts, objs, scenes] = LoadArrays();
    fprintf('Arrays loaded!!\n');
    toc

    % objProbabilities is organised in the following format
    % list
    % {
    %     postId,
    %     postName,
    %     list{objCategoryName, x0, y0, x1, y1, score, list{edist, postId, postName}}
    % }
    tic
    fprintf('Computing Object probabilities...\n');
    [objProbabilities] = GetObjProbabilities(posts, objs, postsFilenames, qPostsFilenames, imgDir);
    fprintf('Completed Object probabilities!!\n')
    toc

    objProb = {};
    objResult = {};
    for i=1:length(objProbabilities)
        for j=1:length(objProbabilities{i}{3})
            obj = objProbabilities{i}{3}{j};
            objName = obj{1};
            for k=1:length(objProbabilities{i}{3}{j}{7})
                objMatch = objProbabilities{i}{3}{j}{7}{k};
                objResult{end+1, 1} = sprintf('%f, %s, %s, %d\n', objMatch{1}, objName, objMatch{3}, objMatch{2});
                objProb{end+1}{1} = objMatch{1};
                objProb{end}{2} = objName;
                objProb{end}{3} = objMatch{3};
                objProb{end}{4} = objMatch{2};
            end
        end
    end

    objResult = sort(objResult);
    fprintf('%s', objResult{:});

    % sceneProbabilities is organised in the following format
    % {
    %     postId,
    %     postName,
    %     sceneVector,
    %     list{probability, postId, postName, sceneVector}
    % }
    tic
    fprintf('Computing Scene probabilities...\n');
    [sceneProbabilities] = GetSceneProbabilities(posts, scenes, postsFilenames, qPostsFilenames, imgDir);
    fprintf('Completed Scene probabilities!!\n');
    toc

    scenesProb = {};
    scenesResult = {};
    for i=1:length(sceneProbabilities)
        for j=1:length(sceneProbabilities{i}{4})
            sceneMatch = sceneProbabilities{i}{4}{j};
            scenesResult{end+1, 1} = sprintf('%f, %s, %d\n', sceneMatch{1}, sceneMatch{3}, sceneMatch{2});
            scenesProb{end+1}{1} = sceneMatch{1};
            scenesProb{end}{2} = sceneMatch{3};
            scenesProb{end}{3} = sceneMatch{2};
        end
    end

    scenesResult = sort(scenesResult);
    fprintf('%s', scenesResult{:})

    
    fprintf('\n<END OF EXECUTION>\n')

    toc


end

