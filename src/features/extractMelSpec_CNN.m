function img = extractMelSpec_CNN(x, fs, imgSize)
% extractMelSpec_CNN
% Unified Mel-spectrogram generator for CNN training & inference.
% Ensures consistent dimensions and normalization.

    if nargin < 3
        imgSize = [128 128];
    end

    % Ensure column vector
    x = x(:);

    % Remove DC and normalize
    x = x - mean(x);
    x = x / (max(abs(x)) + 1e-8);

    % Generate Mel-spectrogram
    win = hann(1024, 'periodic');
    overlap = round(0.75 * length(win));
    fftLen = 1024;

    S = melSpectrogram(x, fs, ...
        'Window', win, ...
        'OverlapLength', overlap, ...
        'FFTLength', fftLen, ...
        'NumBands', 128);

    % Log scale
    S = log10(S + 1e-6);

    % Normalize (per-spectrogram)
    S = (S - min(S(:))) ./ (max(S(:)) - min(S(:)) + 1e-8);

    % Resize to target size
    img = imresize(S, imgSize);

    % CNN requires H×W×1
    img = reshape(img, imgSize(1), imgSize(2), 1);
end
