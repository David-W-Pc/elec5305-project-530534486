function [X, y, fileIdx] = extractMFCC(audioDir, T, numCoeffs)
    if nargin < 3, numCoeffs = 13; end
    n = height(T);
    X = zeros(n, 2*numCoeffs);
    y = T.category;
    fileIdx = strings(n,1);
    for i = 1:n
        wavPath = fullfile(audioDir, T.filename{i});
        [x, fs]  = audioread(wavPath);
        x = mean(x,2);
        % coeffs = mfcc(x, fs, 'NumCoeffs', numCoeffs);
        % mu = mean(coeffs, 1);
        % sd = std(coeffs, 0, 1);
        % X(i,:) = [mu sd];

        coeffs = mfcc(x, fs);
        coeffs = coeffs(:, 1:numCoeffs);   % 强制只有 13 维
        mu = mean(coeffs, 1);
        sd = std(coeffs, 0, 1);
        X(i,:) = [mu sd];

        fileIdx(i) = T.filename{i};
    end
end