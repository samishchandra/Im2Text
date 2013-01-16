function features = extract_features(im, boxes, codewords)

if(~exist('codewords', 'var'))
   codewords = load_codewords;
end

hog = extract_hog(im, codewords.hog_nodes);
tc2 = extract_texcol(im, codewords.tex_nodes, codewords.col_nodes);

for i = 1:size(boxes, 1)
   features{i} = extract_vectors(hog, tc2, boxes(i, :));
end


features = cat(2, features{:});
