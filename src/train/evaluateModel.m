function R = evaluateModel(net, imdsTest)
% Inputs:
%   net       - Trained network or classifier
%   imdsTest  - Test datastore (imageDatastore)
%
% Output:
%   R         - Result struct (accuracy, confusion matrix, predictions)

    trueLabels = imdsTest.Labels;

    % Predict labels
    predictedLabels = classify(net, imdsTest);

    % Compute accuracy
    accuracy = mean(predictedLabels == trueLabels);

    % Confusion matrix
    confMat = confusionmat(trueLabels, predictedLabels);

    R = struct();
    R.accuracy = accuracy;
    R.confMat = confMat;
    R.yTrue = trueLabels;
    R.yPred = predictedLabels;

    fprintf("Evaluation accuracy = %.3f\n", accuracy);
end