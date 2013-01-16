addpath(genpath('./'))

imdir = '~/prog/VOC2008/VOCdevkit/VOC2008/JPEGImages';

fname = fullfile('attribute_data', 'apascal_test.txt');

% Load training data
[img_names, img_classes, bbox, attributes] = read_att_data(fname);

% Collect per image data
[image_list, dk, image_inds] = unique(img_names);

% Collect class data
[class_list dk class_ind] = unique(img_classes);

% Load feature data
codewords = load_codewords;
att_classifiers = load_att_classifiers;

parfor i = 1:length(image_list)
   fprintf('%d/%d\n', i, length(image_list));
   this_im = image_inds == i;

   att_labels{i} = attributes(this_im, :);
   cls_labels{i} = class_ind(this_im);
   boxes{i} = bbox(this_im, :);

   im = imread(fullfile(imdir, image_list{i}));
	
   %%%%% To extract base features for each bounding box:
   features{i} = extract_features(im, boxes{i}, codewords);

   %%%%% To apply pretrained attribute classifers to each box
   %% To train classifiers, see learning/learning_demo.m
   predictions{i} = extract_predictions(im, boxes{i}, att_classifiers, codewords);
end


% Train attribute classifiers
pred_labels = cat(1, predictions{:});
att_labels = cat(1, att_labels{:});
cls_labels = cat(1, cls_labels{:});

rocs = test_classifiers(pred_labels, att_labels);
