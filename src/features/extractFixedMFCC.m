function feat = extractFixedMFCC(x, fs, numCoeffs)
% extractFixedMFCC — stable MFCC extraction (26 dims)
% Compatible with ESC50 + US8K SVM training

    if nargin < 3
        numCoeffs = 13;
    end

    % Ensure mono
    x = x(:);
    if isempty(x)
        feat = zeros(1, numCoeffs*2);
        return;
    end

    % Normalize
    x = x - mean(x);

    % ------------------------------------------------------
    % Window and hop (25ms / 10ms)
    % ------------------------------------------------------
    winLength = round(0.025 * fs);
    hopLength = round(0.010 * fs);

    win = hamming(winLength, "periodic");

    % ------------------------------------------------------
    % FIXED FFT length
    % Must be >= winLength
    % ------------------------------------------------------
    FFTLength = 1024;    % safe value
    if FFTLength < winLength
        FFTLength = 2^nextpow2(winLength);
    end

    % ------------------------------------------------------
    % Compute MFCC
    % ------------------------------------------------------
    coeffs = mfcc(x, fs, ...
        "Window", win, ...
        "OverlapLength", winLength - hopLength, ...
        "NumCoeffs", numCoeffs, ...
        "FFTLength", FFTLength, ...
        "LogEnergy", "replace");

    if isempty(coeffs)
        feat = zeros(1, numCoeffs*2);
        return;
    end

    % Mean pooling (as in training)
    base = mean(coeffs, 1, "omitnan");

    % Delta coefficients
    d = diff(coeffs);
    delta = mean(d, 1, "omitnan");

    feat = [base, delta];

    % Ensure row vector
    feat = reshape(feat, 1, []);
end
