function attribute_classifiers = load_att_classifiers;

attribute_root = fileparts(which('load_att_classifiers.m'));

load(fullfile(attribute_root, 'attribute_classifiers'), 'attribute_classifiers');
