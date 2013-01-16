function  attribute_classifier = train_attributes(features, attributes)

N = size(features,2);
Natt = size(attributes,2);

% Cs to search over
Cs = [-7,-5,-4,-2,-1,0,1,2,3,4,5,7];

% Random split for 
r = randperm(N);
train = false(N, 1);
train(r(1:ceil(end/2))) = 1;
test = ~train;

for i = 1:Natt
   pos = attributes(:,i)==1;
   for C_i = 1:length(Cs)

      neg_tr = find(train &~pos);
      neg_te = find(test &~pos);
      pos_tr = find(train &pos);
      pos_te = find(test &pos);


      opts = sprintf('-c %8.9f -w1 %f',5^(Cs(C_i))/length(neg_tr),length(neg_tr)/length(pos_tr));
      str = lintrain(2*attributes([neg_tr; pos_tr],i)-1,sparse(features(:,[neg_tr; pos_tr]))',opts);

      b = str.w(end);
      w = -str.w(1:end-1)';

      % Check validation data
      pred = w'*features(:, [pos_te; neg_te]);
      roc = computeROC(pred(:), [ones(numel(pos_te), 1); -ones(numel(neg_te), 1)]);
      auc(C_i) = roc.area;
   end

   % Retrain with best C
   [bestAUC(i) best_ind] = max(auc);
   bestC = Cs(best_ind); 

   neg_tr = find(~pos);
   pos_tr = find(pos);

   opts = sprintf('-c %8.9f -w1 %f',5^(bestC)/length(neg_tr),length(neg_tr)/length(pos_tr));
   attribute_classifier{i} = lintrain(2*attributes([neg_tr; pos_tr],i)-1,sparse(features(:,[neg_tr; pos_tr]))',opts);

   fprintf('Best AUC for part %d: %f\n', i, bestAUC(i));
end

keyboard
