function T = loadEsc50Meta(csvPath)
% Loads the ESC-50 metadata CSV and standardizes the table format.
%
% Output fields:
%   - filename : audio file name (string)
%   - label    : categorical class label
%   - fold     : fold index
%
% Other columns from the original CSV are ignored.

    % Load CSV as table
    Traw = readtable(csvPath, 'VariableNamingRule', 'preserve');

    % Validate required columns
    required = ["filename", "category", "fold"];
    if ~all(ismember(required, Traw.Properties.VariableNames))
        error("ESC50 metadata is missing required columns: filename, category, fold.");
    end

    % Standardize output
    T = table();

    % File name (e.g., 1-100032-A-0.wav)
    T.filename = string(Traw.filename);

    % Class label (e.g., dog, rain, clock_tick)
    T.label = categorical(Traw.category);

    % Fold information
    T.fold = Traw.fold;
end
