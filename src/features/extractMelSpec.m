function melImg = extractMelSpec(x, fs, imgSize)
% extractMelSpec — safe version (never throws FFT/window errors)
% Output → resized log-Mel image for CNN
%
% imgSize : [H W]

    x = x(:);

    % ------------------------------
    % Safe window & FFT parameters
    % ------------------------------
    win = hamming(1024, "periodic");
    winLength = length(win);

    % FFT must be >= winLength
    fftLength = 1024;

    hop = 512;     % 50% overlap
    numBands = 64; % Mel bins

    if fftLength < winLength
        fftLength = pow2(nextpow2(winLength));
    end

    % ------------------------------
    % Compute Mel-spectrogram
    % ------------------------------
    S = melSpectrogram(x, fs, ...
        "Window", win, ...
        "OverlapLength", winLength - hop, ...
        "FFTLength", fftLength, ...
        "NumBands", numBands);

    % ------------------------------
    % Convert to log scale
    % ------------------------------
    S = log10(S + 1e-6);

    % ------------------------------
    % Normalize 0–1
    % ------------------------------
    S = S - min(S(:));
    S = S ./ max(S(:) + eps);

    % ------------------------------
    % Resize to CNN required size
    % ------------------------------
    melImg = imresize(S, imgSize);

    % CNN expects H×W×1
    melImg = single(melImg);
end
