function [fullFilename, filename, extension] = Filename(filePath)
    %FILENAME
    % extract the filename from the filePath

    splits = regexp (filePath, '/', 'split');
    % splits = textscan(str, '%s', 'delimiter', '\');

    
    % the last split is the filename
    fullFilename = splits{length(splits)};
    splits = regexp (fullFilename, '\.', 'split');

    filename = splits{1};
    extension = splits{length(splits)};
    
end

