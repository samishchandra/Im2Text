function rocs = test_classifiers(pred_labels, att_labels)


for i = 1:size(att_labels,2)
   rocs{i} = computeROC(pred_labels(:, i), 2*att_labels(:, i)-1);
end
