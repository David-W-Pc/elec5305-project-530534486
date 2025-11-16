function main_live_demo_gui()
% MAIN_LIVE_DEMO_GUI
% Launches a simple GUI for live environmental sound recognition.
% The user can select a trained model (SVM MFCC or CNN Mel-Spectrogram),
% choose recording duration, and run live prediction from the microphone.
%
% Requirements:
%   - config.m (returns C.modelsDir)
%   - recordAndPredict.m (auto-handles SVM/CNN based on model file)
%   - extractMelSpec.m (for CNN models)
%
% Usage:
%   >> main_live_demo_gui

    % Make sure project paths are available
    addpath(genpath('src'));
    addpath('config');

    % Load configuration to locate models directory
    C = config();
    modelsDir = C.modelsDir;

    if ~exist(modelsDir, "dir")
        warning("Models directory does not exist: %s\nRun main_train*.m first.", modelsDir);
    end

    % Scan available model files
    modelFiles = {};
    if exist(modelsDir, "dir")
        d = dir(fullfile(modelsDir, "*.mat"));
        modelFiles = {d.name};
    end

    if isempty(modelFiles)
        modelFiles = {"<no model found>"};
    end

    % ================== Build GUI ==================
    fig = uifigure( ...
        'Name', 'Environmental Sound Live Demo', ...
        'Position', [100 100 480 260]);

    % Model selection label
    uilabel(fig, ...
        'Text', 'Select model (.mat):', ...
        'Position', [20 210 150 22]);

    % Model dropdown
    ddModel = uidropdown(fig, ...
        'Items', modelFiles, ...
        'Position', [170 210 220 22]);

    % Refresh button
    uibutton(fig, 'push', ...
        'Text', 'Refresh', ...
        'Position', [400 210 60 22], ...
        'ButtonPushedFcn', @(src,evt) refreshModels());

    % Duration label
    uilabel(fig, ...
        'Text', 'Recording duration (s):', ...
        'Position', [20 170 160 22]);

    % Duration numeric field
    nfDur = uieditfield(fig, 'numeric', ...
        'Value', 3, ...
        'Limits', [0.5 30], ...
        'Position', [190 170 80 22]);

    % Record button
    uibutton(fig, 'push', ...
        'Text', 'Record & Predict', ...
        'FontWeight', 'bold', ...
        'Position', [290 160 170 40], ...
        'ButtonPushedFcn', @(src,evt) onRecord());

    % Result label (static)
    uilabel(fig, ...
        'Text', 'Prediction:', ...
        'Position', [20 115 80 22], ...
        'FontWeight', 'bold');

    % Result display label
    lblResult = uilabel(fig, ...
        'Text', '---', ...
        'Position', [110 115 350 22], ...
        'FontWeight', 'bold', ...
        'FontSize', 14);

    % Log text area (create first, then set Value)
    txtLog = uitextarea(fig, ...
        'Editable', 'off', ...
        'Position', [20 20 440 80]);

    % Initialize log as cell array of char (column)
    txtLog.Value = {'Ready. Select a model and press ''Record & Predict''.'};

    % ============== Nested helper: append to log ==============
    function appendLog(msg)
        % Ensure msg is a cell column of char
        if isstring(msg)
            msg = cellstr(msg);
        elseif ischar(msg)
            msg = {msg};
        elseif iscell(msg)
            % assume ok
        else
            msg = {char(msg)};
        end
        msg = msg(:);  % column

        val = txtLog.Value;
        if ischar(val)
            val = {val};
        end
        val = [val; msg];
        txtLog.Value = val;
    end

    % ============== Nested callback functions ==============

    function refreshModels()
        % Reloads model list from modelsDir
        if ~exist(modelsDir, "dir")
            uialert(fig, sprintf('Models folder not found: %s', modelsDir), ...
                'Error', 'Icon', 'error');
            return;
        end
        d = dir(fullfile(modelsDir, "*.mat"));
        if isempty(d)
            ddModel.Items = {"<no model found>"};
            ddModel.Value = "<no model found>";
            appendLog("No .mat model files found. Run training first.");
        else
            names = {d.name};
            ddModel.Items = names;
            ddModel.Value = names{1};
            appendLog(sprintf("Found %d model files.", numel(names)));
        end
    end

    function onRecord()
        % Handles Record & Predict button press

        modelName = ddModel.Value;
        if strcmp(modelName, "<no model found>")
            uialert(fig, 'No model file selected. Please train and refresh.', ...
                'No Model', 'Icon', 'warning');
            return;
        end

        % Build full model path
        modelPath = fullfile(modelsDir, modelName);

        if ~isfile(modelPath)
            uialert(fig, sprintf('Model file not found:\n%s', modelPath), ...
                'File Error', 'Icon', 'error');
            return;
        end

        dur = nfDur.Value;

        appendLog(sprintf("Using model: %s", modelName));
        appendLog(sprintf("Recording %.1f seconds...", dur));
        drawnow;

        try
            % Call your unified live recording + prediction function
            predicted = recordAndPredict(modelPath, dur);

            % Update GUI result
            lblResult.Text = char(predicted);
            appendLog(sprintf("Prediction: %s", string(predicted)));
            appendLog("Done.");

        catch ME
            % Show error information
            lblResult.Text = 'ERROR';
            appendLog(sprintf("Error: %s", ME.message));
            uialert(fig, ME.message, 'Runtime Error', 'Icon', 'error');
        end

        drawnow;
    end

end