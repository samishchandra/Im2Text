function [feat, scale, interval] = featpyramid(im, sbin, sc)

% [feat, scale, interval] = featpyramid(im, sbin, sc);
% Compute feature pyramid.
%
% sc is the approximate scaling factor between levels. 
% feat{i} is the i-th level of the feature pyramid.
% scale{i} is the scaling factor used for the i-th level.
% feat{i+interval} is computed at exactly half the resolution of feat{i}.
% first interval features halucinate higher resolution

interval = ceil(log(2) / log(sc));
imsize = [size(im, 1) size(im, 2)];
max_scale = floor(max(log(3*sbin) - log(imsize)) / log(1 / sc)) - 2;
feat = cell(max_scale + interval, 1);
scale = zeros(max_scale + interval, 1);

% our resize function wants floating point values
im = double(im);
for i = 1:interval
  size(im)
  k = 1/sc^(i-1);
  scaled = resize(im, 1/sc^(i-1));
  % "first" 2x interval
  feat{i} = features(scaled, sbin/2);
  scale(i) = 2/sc^(i-1);
  % "second" 2x interval
  feat{i+interval} = features(scaled, sbin);
  scale(i+interval) = 1/sc^(i-1);
  % remaining interals
  for j = i+interval:interval:max_scale
    scaled = resize(scaled, 0.5);
    feat{j+interval} = features(scaled, sbin);
    scale(j+interval) = 0.5 * scale(j);
  end
end
