hog = {};
hogDesc = {};
clusters = {};
noOfWindows = length(objCategories{2}{2});

for j = 1:noOfWindows % no of files in which object occurred
    cellArr = objCategories{2}{2}{j}; % represents one window
    imgPath = cellArr{2};
    
    if(exist(imgPath, 'file'))
%         imgPath, cellArr{4}, cellArr{3}, cellArr{6}, cellArr{5}
        hogDesc{j} = HOGDescriptor(imgPath, cellArr{4}, cellArr{3}, cellArr{6}, cellArr{5}, splitSize);
        hog{j} = hogDesc{j}{1};
    else
        imgName = regexp(imgPath, '\', 'split');
        fprintf('File not found!! imgName=%s, postId=%d, categoryName=%s\n', imgName{end}, cellArr{1}, objCategories{2}{1});
    end
end