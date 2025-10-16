clear; clc;

metaCsv = "data/ESC-50-master/meta/esc50.csv";
audioDir = "data/ESC-50-master/audio";

T = loadEsc50Meta(metaCsv);
folds = T.fold;                  % 1..5
labels = T.category;

[X, y, fileIdx] = extractMFCC(audioDir, T, 13);

M = trainBaselineSVM(X, y, folds);

fprintf('Fold Accuracies: %s\n', mat2str(M.cvAcc,3));
fprintf('Overall Accuracy: %.3f\n', M.overallAcc);

figure; confusionchart(M.yTrue, M.yPred);
title(sprintf('ESC-50 SVM Baseline, Overall Acc=%.3f', M.overallAcc));


exportMelSpecs(audioDir, "features/melspec", T, [128 128]);