function T = loadUS8KMeta(csvPath)
% LOADUS8KMETA
% Loads UrbanSound8K metadata CSV and returns a table.
%
% Required columns:
%   - slice_file_name  (audio filename)
%   - fold             (fold1 ... fold10)
%   - classID          (numeric target)
%   - class            (string label)

    % Read metadata CSV
    T = readtable(csvPath);

    % Create a unified filename column
    T.filename = T.slice_file_name;

    % Create a categorical label column
    T.label = categorical(T.class);
end