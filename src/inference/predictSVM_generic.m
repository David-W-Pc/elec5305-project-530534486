function [label, score] = predictSVM_generic(M, feat)
% predictSVM_generic — predict using trained SVM (ECOC or manual)
% Inputs:
%   M    — struct from training (contains trainedModel + labelSet)
%   feat — 1xD feature vector (already extracted MFCC etc.)
%
% Outputs:
%   label — predicted class (string)
%   score — classification score (if available)

    modelObj = M.trainedModel;

    % --------------------------------------------
    % Case A — built-in MATLAB ECOC model
    % --------------------------------------------
    if ~iscell(modelObj)
        [yhat, score] = predict(modelObj, feat);
        label = string(yhat);
        return;
    end

    % --------------------------------------------
    % Case B — manual ECOC (rarely used)
    % --------------------------------------------
    labelSet = M.labelSet;
    C = numel(labelSet);
    votes = zeros(1, C);

    for c1 = 1:C
        for c2 = (c1+1):C
            svmModel = modelObj{c1, c2};
            if isempty(svmModel), continue; end

            p = predict(svmModel, feat);

            if p == 1
                votes(c1) = votes(c1) + 1;
            else
                votes(c2) = votes(c2) + 1;
            end
        end
    end

    [~, idx] = max(votes);
    label = string(labelSet(idx));
    score = votes;
end
