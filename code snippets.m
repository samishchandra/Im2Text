
url = 'D:\Dropbox\Study\Fall''12\Words & Pictures\Words & Pictures Project\SBU_Captioned_Photo_Dataset_v1.1\data\images\1_122200564_741285c8ed.jpg';
img = imread(url);
x1 = 1; y1 = 1;
[x2, y2, z] = size(img);
width = x2-x1;
height = y2-y1;
splitSize = 3;
 for i=1:splitSize
    for j=1:splitSize
        sx1 = x1 + ((i-1) * (x2-x1)/splitSize);
        sx2 = x1 + (i * width/splitSize);
        sy1 = y1 + ((j-1) * height/splitSize);
        sy2 = y1 + (j * height/splitSize);
        img1 = img(sx1:sx2, sy1:sy2);
        subplot(splitSize, splitSize, splitSize*(i-1) + j), imshow(img1)
    end
end




for i = 1:length(objCategories)
    for j=1:noOfWindows
        hist = objCategories{i}{2}{j}{8};
        objCategories{i}{2}{j}{8} = hist./sumabs(hist);
    end
end






% finalImg = {};
% for i = 1:length(objCategories)
%     for j = 1:length(objCategories{i}{2})
% %         objCategories{i}{2}{j}{2}
%         if(exist(objCategories{i}{2}{j}{2}, 'file'))
%             img = imread(objCategories{i}{2}{j}{2});
%             [x, y, z] = size(img);
% %             fprintf('%d, %d ', x, y);
% %             fprintf('%d, ', objCategories{i}{2}{j}{3});
% %             fprintf('%d, ', objCategories{i}{2}{j}{5});
% %             fprintf('%d, ', objCategories{i}{2}{j}{2});
% %             fprintf('%d \n', objCategories{i}{2}{j}{4});
%             
%             img = img(objCategories{i}{2}{j}{4}:min(x, objCategories{i}{2}{j}{6}), objCategories{i}{2}{j}{3}:min(y, objCategories{i}{2}{j}{5}), :);
% %             fprintf('%f, ', objCategories{i}{2}{j}{6});
%             finalImg{end+1} = img;
%         end
%     end
% end
% 
% 
% length(finalImg)
% for i=1:9
%     subplot(4, 4, i), imshow(finalImg{i+9})
% end
 
% obj = {};
% for i = 1:length(objCategories)
%     obj{i, 1} = objCategories{i}{1};
% end
% obj;

% 