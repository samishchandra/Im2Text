function pred = extract_predictions(im, boxes, varargin)

if(length(varargin)<1 || isempty(varargin{1}))
   classifiers = load_att_classifiers;
else
   classifiers = varargin{:};
end

features = extract_features(im, boxes, varargin{2:end});

pred = zeros(size(boxes,1), numel(classifiers));

for i = 1:length(classifiers)
   b = classifiers{i}.w(end);
   w = -classifiers{i}.w(1:end-1);
   
   pred(:, i) = (w(:)'*features - b)';
end
