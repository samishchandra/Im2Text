attribute_root = fullfile(fileparts(which('learning_demo.m')), '../');

addpath(genpath(attribute_root))

imdir = '~/prog/VOC2008/VOCdevkit/VOC2008/JPEGImages';

fname = fullfile(attribute_root, 'attribute_data', 'apascal_train.txt');

% Load training data
[img_names, img_classes, bbox, attributes] = read_att_data(fname);

% Collect per image data
[image_list, dk, image_inds] = unique(img_names);

% Collect class data
[class_list dk class_ind] = unique(img_classes);

% Load feature data
codewords = load_codewords;

parfor i = 1:length(image_list)
   fprintf('%d/%d\n', i, length(image_list));
   this_im = image_inds == i;

   att_labels{i} = attributes(this_im, :);
   cls_labels{i} = class_ind(this_im);
   boxes{i} = bbox(this_im, :);

   im = imread(fullfile(imdir, image_list{i}));

   features{i} = extract_features(im, boxes{i}, codewords);
end


% Train attribute classifiers
features = cat(2, features{:});
att_labels = cat(1, att_labels{:});
cls_labels = cat(1, cls_labels{:});

attribute_classifiers = train_attributes(features, att_labels);
attribute_names =  textread(fullfile(attribute_root, 'attribute_data', 'attribute_names.txt'),'%s');

save(fullfile(attribute_root, 'learning', 'attribute_classifiers'), 'attribute_classifiers', 'attribute_names');
