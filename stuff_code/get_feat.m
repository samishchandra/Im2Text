function [hog, tc] = get_feat(cat, image)

    hog = load(strcat(cat,'/processed/hog/', image, '_hog.mat'));
    tc = load(strcat(cat,'/processed/tc2/', image, '_tc.mat'));
