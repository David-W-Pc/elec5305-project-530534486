clear; clc;

metaCsv = "data/ESC-50-master/meta/esc50.csv";
audioDir = "data/ESC-50-master/audio";

T = loadEsc50Meta(metaCsv);
folds = T.fold;                  % 1..5
labels = T.category;

% 2) 提取 MFCC 特征
[X, y, fileIdx] = extractMFCC(audioDir, T, 13);

% 3) 训练并 5 折评估 SVM 基线
M = trainBaselineSVM(X, y, folds);

fprintf('Fold Accuracies: %s\n', mat2str(M.cvAcc,3));
fprintf('Overall Accuracy: %.3f\n', M.overallAcc);

% 4) 混淆矩阵查看
figure; confusionchart(M.yTrue, M.yPred);
title(sprintf('ESC-50 SVM Baseline, Overall Acc=%.3f', M.overallAcc));

% 5) （可选）导出 Mel 频谱图，为 Week10/11 CNN 做准备
% exportMelSpecs(audioDir, "features/melspec", T, [128 128]);