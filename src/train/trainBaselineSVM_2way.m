function M = trainBaselineSVM_2way(X, y)
% TRAINBASELINESVM_2WAY
% Multi-class SVM using MATLAB ECOC (one-vs-one).
% Parallel training enabled for high-dimensional MFCC features.
%
% Outputs:
%   M.trainedModel - ECOC SVM classifier
%   M.labelSet     - category list
%   M.accuracy     - validation accuracy

    % Ensure categorical labels
    y = categorical(y);

    % -----------------------------
    % Train/Validation split
    % -----------------------------
    cv = cvpartition(y, 'HoldOut', 0.2);

    Xtrain = X(training(cv), :);
    ytrain = y(training(cv));
    Xval   = X(test(cv), :);
    yval   = y(test(cv));

    fprintf("Training ECOC SVM (one-vs-one, parallel)...\n");

    % Enable parallel pool
    opts = statset("UseParallel", true);

    % Base SVM template
    t = templateSVM( ...
        "KernelFunction", "linear", ...
        "KernelScale", "auto", ...
        "Standardize", true);

    % -----------------------------
    % Train ECOC classifier
    % -----------------------------
    model = fitcecoc( ...
        Xtrain, ytrain, ...
        "Learners", t, ...
        "Coding", "onevsone", ...
        "Options", opts, ...
        "Verbose", 1);

    % -----------------------------
    % Validation
    % -----------------------------
    ypred = predict(model, Xval);
    acc = mean(ypred == yval);

    fprintf("Validation accuracy = %.4f\n", acc);

    % -----------------------------
    % Package model
    % -----------------------------
    M = struct();
    M.trainedModel = model;
    M.labelSet     = categories(y);
    M.accuracy     = acc;
end
