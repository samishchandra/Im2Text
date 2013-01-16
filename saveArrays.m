tic

si = 1;
ei = 1;



postsDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\posts\';
postsFiles = dir(strcat(postsDir, '*.txt'));
% postsFiles = postsFiles(si:ei);

% read and concatenate all the postsArray
postsArray = cell(1, 5);
for i=1:length(postsFiles)
    fid = fopen(strcat(postsDir, postsFiles(i).name));
    pArray = textscan(fid, '%d %d %d %s %[^\n]', 'BufSize', postsFiles(i).bytes);
    fclose(fid);
    for j=1:length(pArray)
        postsArray{j} = [postsArray{j};pArray{j}];
    end
end
save('postsArray', 'postsArray');

objDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\objects\';
objFiles = dir(strcat(objDir, '*.txt'));
% objFiles = objFiles(si:ei);

objsArray = cell(1, 8);
for i=1:length(postsFiles)
    fid = fopen(strcat(objDir, objFiles(i).name));
    oArray = textscan(fid, '%d %d %[^\t] %d %d %d %d %f', 'BufSize', objFiles(i).bytes);
    fclose(fid);
    for j=1:length(oArray)
        objsArray{j} = [objsArray{j};oArray{j}];
    end
end
save('objsArray', 'objsArray');


sceneDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\scenes\';
sceneFiles = dir(strcat(sceneDir, '*.txt'));
% sceneFiles = sceneFiles(si:ei);

scenesArray = cell(1, 4);
for i=1:length(postsFiles)
    fid = fopen(strcat(sceneDir, sceneFiles(i).name));
    oArray = textscan(fid, '%d %d %[^\t] %f');
    fclose(fid);
    for j=1:length(oArray)
        scenesArray{j} = [scenesArray{j};oArray{j}];
    end
end
save('scenesArray', 'scenesArray');

fprintf('#postsArray = %d, #postsArray{1}= %d\n', length(postsArray), length(postsArray{1}));
fprintf('#objsArray = %d, #objsArray{1}= %d\n', length(objsArray), length(objsArray{1}));
fprintf('#scenesArray = %d, #scenesArray{1}= %d\n', length(scenesArray), length(scenesArray{1}));


toc
