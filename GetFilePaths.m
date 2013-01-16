% get the image paths cell array
% dbDir - directory of the images
% categories - array containing category names

function [filePaths] = GetFilePaths(dbDir, prefix, suffix)
%     dbDir= 'bags';
%     categories = {'clutch','hobo','shoulder','totes'};
% 
%     prefix = 'descr_bags_';
%     suffix = '.txt';

    filePaths = {};
    for i=1:length(categories)
        categoryDir = GetCategoryDir(dbDir, categories{i});
        paths = {};
        for j=1:1000
            paths{j} = strcat(categoryDir, prefix, categories{i}, '_', num2str(j), suffix);
        end
        filePaths{i} = paths;
    end
