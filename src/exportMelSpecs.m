function exportMelSpecs(audioDir, outDir, T, imgSize)
    if nargin < 4, imgSize = [128 128]; end
    if ~exist(outDir,'dir'), mkdir(outDir); end
    for i = 1:height(T)
        wavPath = fullfile(audioDir, T.filename{i});
        [x, fs] = audioread(wavPath);
        x = mean(x,2);
        S = melSpectrogram(x, fs, 'WindowLength', round(0.025*fs), ...
                                'OverlapLength', round(0.015*fs), ...
                                'NumBands', 128);
        Sdb = 10*log10(S+eps);
        Sdb = (Sdb - min(Sdb(:))) / (max(Sdb(:)) - min(Sdb(:)) + eps);
        I = imresize(Sdb, imgSize);
        catDir = fullfile(outDir, char(T.category(i)));
        if ~exist(catDir,'dir'), mkdir(catDir); end
        [~, name, ~] = fileparts(T.filename{i});
        imwrite(I, fullfile(catDir, name + ".png"));
    end
end