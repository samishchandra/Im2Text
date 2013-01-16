tic

postsDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\posts';
postsFile = '0000.txt';
postsFilePath = strcat(postsDir, '\', postsFile);

objDir = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\objects';
objFile = '0000.txt';
objFilePath = strcat(objDir, '\', objFile);


fid = fopen(postsFilePath);
postsArray1 = textscan(fid, '%d %d %d %s %[^\n]');
fclose(fid);

fprintf('#postsArray = %d, #postsArray{1}= %d\n', length(postsArray1), length(postsArray1{1}));

postFilenames = postsArray1{4};

vars = load('postsArray');
postsArray = vars.postsArray;

vars = load('objsArray');
objsArray = vars.objsArray;

[x, postsIndex] = ismember(postsFilenames, postsArray{4});


resultPosts = cell(1, 5);
for i=1:length(postsIndex)
    resultPosts{1}(end+1, 1) = postsArray{1}(postsIndex(i));
    resultPosts{2}(end+1, 1) = postsArray{2}(postsIndex(i));
    resultPosts{3}(end+1, 1) = postsArray{3}(postsIndex(i));
    resultPosts{4}{end+1, 1} = postsArray{4}{postsIndex(i)};
    resultPosts{4}{end+1, 1} = postsArray{4}{postsIndex(i)};
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





toc