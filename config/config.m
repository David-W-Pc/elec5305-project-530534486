function C = config()
% CONFIG  Returns a struct containing all project-level configuration.

    % === ESC-50 dataset paths ===
    C.esc50.metaCsv   = "data/ESC-50/meta/esc50.csv";
    C.esc50.audioRoot = "data/ESC-50/audio";

    % === UrbanSound8K dataset paths ===
    C.us8k.metaCsv    = "data/urbansound8k/metadata/UrbanSound8K.csv";
    C.us8k.audioRoot  = "data/urbansound8k/audio";

    % === FSD50K dataset paths (dev split) ===
    C.fsd.devMetaCsv     = "data/FSD50K/metadata/dev.csv";
    C.fsd.vocabCsv       = "data/FSD50K/metadata/vocabulary.csv";
    C.fsd.devAudioRoot   = "data/FSD50K/dev_audio";

    % Directory for trained models
    C.modelsDir  = "models";

    % Directory for saving results
    C.resultsDir = "results";

    % Auto-create directories if missing
    if ~exist(C.modelsDir, 'dir')
        fprintf("Creating folder: %s\n", C.modelsDir);
        mkdir(C.modelsDir);
    end

    if ~exist(C.resultsDir, 'dir')
        fprintf("Creating folder: %s\n", C.resultsDir);
        mkdir(C.resultsDir);
    end
end