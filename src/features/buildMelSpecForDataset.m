function buildMelSpecForDataset(datasetName, outDir, logWin)
% BUILDMELSPECFORDATASET
% Generates log-Mel spectrograms for one dataset:
%   ESC50, US8K, FSD50K.
%
% datasetName : "esc50" | "us8k" | "fsd50k"
% outDir      : output directory
% logWin      : GUI text area (or empty)

    if nargin < 3
        logWin = [];
    end

    % Load dataset configuration
    C = getDatasetConfig(datasetName);
    C.datasetName = datasetName;   % ensure exists

    % Load metadata
    T = loadMetadata(C);

    logMsg(logWin, sprintf(">>> Building MelSpec for dataset: %s", datasetName));

    outDatasetDir = fullfile(outDir, datasetName);
    if ~exist(outDatasetDir, "dir")
        mkdir(outDatasetDir);
    end

    imgSize = [128 128];
    N = height(T);

    for i = 1:N

        % Audio path for this dataset
        wavPath = resolveWavPath(C, T, i);

        if ~isfile(wavPath)
            logMsg(logWin, "Missing file: " + wavPath);
            continue;
        end

        [x, fs] = audioread(wavPath);
        x = mean(x, 2);

        melImg = extractMelSpec(x, fs, imgSize);

        % Save by label
        label = string(T.(C.labelCol)(i));
        labelDir = fullfile(outDatasetDir, label);
        if ~exist(labelDir, "dir")
            mkdir(labelDir);
        end

        fpath = fullfile(labelDir, sprintf("%s_%d.png", datasetName, i));
        imwrite(mat2gray(melImg), fpath);

        if mod(i, 400) == 0
            logMsg(logWin, sprintf("  %d / %d done", i, N));
        end
    end

    logMsg(logWin, sprintf("✔ Finished MelSpec for %s (%d files)", ...
        datasetName, N));
end


%% ======================================================
%  Correct metadata loader
% ======================================================
function T = loadMetadata(C)
    switch C.datasetName
        case "esc50"
            T = loadEsc50Meta(C.metaCsv);

        case "us8k"
            T = loadUS8KMeta(C.metaCsv);

        case "fsd50k"
            T = loadFSD50KMeta(C.metaCsv, C.vocabCsv);

        otherwise
            error("Unknown dataset: %s", C.datasetName);
    end
end


%% ======================================================
%  Proper audio path resolver
% ======================================================
function wavPath = resolveWavPath(C, T, idx)

    switch C.datasetName
        case "esc50"
            wavPath = fullfile(C.audioRoot, char(T.(C.fnameCol)(idx)));

        case "us8k"
            fold = T.fold(idx);
            fname = char(T.(C.fnameCol)(idx));
            wavPath = fullfile(C.audioRoot, sprintf("fold%d", fold), fname);

        case "fsd50k"
            wavPath = fullfile(C.audioRoot, char(T.(C.fnameCol)(idx)));

        otherwise
            error("Unknown datasetName: %s", C.datasetName);
    end
end


%% ======================================================
%  GUI logger
% ======================================================
function logMsg(logWin, txt)
    if isempty(logWin)
        fprintf("%s\n", txt);
    else
        logWin.Value = [logWin.Value; {char(txt)}];
        drawnow;
    end
end
