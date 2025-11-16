function D = getDatasetConfig(name)
% Returns fields:
%   audioRoot
%   metaCsv
%   vocabCsv (for fsd50k)
%   fnameCol
%   labelCol
%   metaTable (optional)
%
% Supports:
%   "esc50"
%   "us8k"
%   "fsd50k"
%   "all"

    name = lower(string(name));

    switch name

        % -----------------------------------------
        % ESC-50
        % -----------------------------------------
        case "esc50"
            D.audioRoot = "data/ESC-50/audio";
            D.metaCsv   = "data/ESC-50/meta/esc50.csv";

            % Standard columns for ESC50 loader
            D.fnameCol  = "filename";
            D.labelCol  = "label";

        % -----------------------------------------
        % UrbanSound8K
        % -----------------------------------------
        case "us8k"
            D.audioRoot = "data/urbansound8k/audio";
            D.metaCsv   = "data/urbansound8k/metadata/UrbanSound8K.csv";

            % Standardized by loadUS8KMeta
            D.fnameCol  = "filename";
            D.labelCol  = "label";

        % -----------------------------------------
        % FSD50K (simplified dev subset)
        % -----------------------------------------
        case "fsd50k"
            D.audioRoot = "data/FSD50K/dev_audio";
            D.metaCsv   = "data/FSD50K/metadata/dev.csv";
            D.vocabCsv  = "data/FSD50K/metadata/vocabulary.csv";

            % Output from loadFSD50KMeta
            D.fnameCol  = "filename";
            D.labelCol  = "label";

        % -----------------------------------------
        % Combined: ESC50 + US8K + FSD50K
        % -----------------------------------------
        case "all"
            D.esc50  = getDatasetConfig("esc50");
            D.us8k   = getDatasetConfig("us8k");
            D.fsd50k = getDatasetConfig("fsd50k");

        otherwise
            error("Unknown dataset: %s", name);
    end
end
