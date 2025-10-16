function M = trainBaselineSVM(X, y, folds)
    if nargin < 3
        error('need to provide folds (come from esc50.csv)');
    end
    cvAcc = zeros(5,1);
    yhat_all = categorical(strings(size(y)));
    for k = 1:5
        isTest  = (folds == k);
        isTrain = ~isTest;
        svmMdl = fitcecoc(X(isTrain,:), y(isTrain), ...
            'Learners', templateSVM('KernelFunction','linear'), ...
            'Coding', 'onevsall', 'ClassNames', categories(y));
        yhat = predict(svmMdl, X(isTest,:));
        yhat_all(isTest) = yhat;
        cvAcc(k) = mean(yhat == y(isTest));
    end
    overallAcc = mean(cvAcc);
    confMat = confusionmat(y, yhat_all);
    M = struct('cvAcc', cvAcc, 'overallAcc', overallAcc, ...
               'yTrue', y, 'yPred', yhat_all, 'confMat', confMat);
end