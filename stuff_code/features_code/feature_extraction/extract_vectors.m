function feat = extract_vector(hog, tc, bbox)
% bbox: [xmin ymin xmax ymax]


   n_x = 2;
   n_y = 3;

   feat_hog = zeros(1000*(n_x*n_y+1),1);
   feat_c = zeros(128*(n_x*n_y+1),1);
   feat_t = zeros(256*(n_x*n_y+1),1);

   % This splits the image into a 3x2 grid, and computes 
   %   histograms for each cell of the grid, along with a
   %   histogram for the whole bbox.  Just use bs{end} for
   %   the whole bounding box
   bs = get_boxes(bbox,n_x, n_y); 

   for b_i = 1:length(bs)
      box = bs{b_i};
      box_size = (box(4)-box(2))*(box(3)-box(1));

      hog_ind = hog.x >= box(1) & hog.y >= box(2) & hog.x <= box(3) & hog.y <= box(4);

      feat_hog((1:1000)+(b_i-1)*1000) = do_hist(hog.idx(hog_ind),1000);
      feat_c((1:128)+(b_i-1)*128) = do_hist(tc.colorim(box(2)+1:box(4), box(1)+1:box(3)),128);
      feat_t((1:256)+(b_i-1)*256) = do_hist(tc.textonim(box(2)+1:box(4), box(1)+1:box(3)),256);
   end

   feat = [feat_c;feat_t;feat_hog];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = do_hist(d,n_bins)

h = hist(d(:),1:n_bins)';
n = norm(h);
if(n == 0)
   h = zeros(size(h));
else
   h = h/n;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bs = get_boxes(bbox,x,y)

h = bbox(4) - bbox(2);
w = bbox(3) - bbox(1);

w_s = ([1:x+1]-1)*w/x + bbox(1);
h_s = ([1:y+1]-1)*h/y + bbox(2);

bs = cell(x*y+1,1);

for i = 1:x
   for j = 1:y
      bs{(i-1)*y+j} = floor([w_s(i) h_s(j) min(w_s(i+1),bbox(3)) min(h_s(j+1),bbox(4))]);
   end
end

bs{end} = bbox;
