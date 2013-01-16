addpath(genpath('features/feature_extraction'));
addpath(genpath('features/feature_extraction/code'));
categories={'building','grass','road','sky','tree','water'};

for c=1:length(categories)
    extract_features_dh(char(strcat('data/',categories(c))), char(categories(c)));
end
