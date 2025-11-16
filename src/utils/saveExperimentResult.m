function saveExperimentResult(R, filePath)
% Inputs:
%   R         - Result struct (accuracy, confusion matrix, predictions)
%   filePath  - Path to save .mat file
%
% Output:
%   (none)

    S = struct();
    S.accuracy = R.accuracy;
    S.confMat = R.confMat;
    S.yTrue   = R.yTrue;
    S.yPred   = R.yPred;

    save(filePath, '-struct', 'S');

    fprintf("Experiment result saved to %s\n", filePath);
end