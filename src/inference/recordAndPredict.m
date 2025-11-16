function predictedLabel = recordAndPredict(modelPath, duration)
% RECORDANDPREDICT
% Supports SVM (MFCC) and CNN (Log-Mel).
% Automatically adapts to new/old model formats.

    if nargin < 2
        duration = 3;
    end

    fprintf("Using model: %s\n", modelPath);
    fprintf("Recording %.1f seconds...\n", duration);

    % ----------------------------------------------------------
    % 1) RECORD MICROPHONE AUDIO
    % ----------------------------------------------------------
    recObj = audiorecorder(44100, 16, 1);
    recordblocking(recObj, duration);
    x = getaudiodata(recObj);
    fs = 44100;

    fprintf("Recording finished. Processing...\n");

    % ----------------------------------------------------------
    % 2) LOAD MODEL
    % ----------------------------------------------------------
    S = load(modelPath);

    isSVM = isfield(S, "M");
    isCNN = isfield(S, "net");

    if ~isSVM && ~isCNN
        error("Unknown model structure in MAT file.");
    end

    % ----------------------------------------------------------
    % 3A) SVM Prediction
    % ----------------------------------------------------------
    if isSVM
        fprintf("Detected SVM model.\n");

        featureType = S.featureType;
        M = S.M;

        switch featureType
            case "mfcc"
                feat = extractFixedMFCC(x, fs, 13);
                feat = reshape(feat, 1, []);

                predictedLabel = predictSVM_generic(M, feat);

            otherwise
                error("Unsupported SVM feature type: %s", featureType);
        end

        fprintf("Predicted Sound: %s\n", string(predictedLabel));
        return;
    end

    % ----------------------------------------------------------
    % 3B) CNN Prediction (NEW VERSION)
    % ----------------------------------------------------------
    if isCNN
        fprintf("Detected CNN model.\n");

        net = S.net;

        % Automatically read input size from CNN
        inputSize = net.Layers(1).InputSize;    % [H W C]

        imgH = inputSize(1);
        imgW = inputSize(2);
        imgC = inputSize(3);

        % Extract Log-Mel
        melImg = extractMelSpec(x, fs, [imgH imgW]);

        % Ensure channels match CNN input
        if imgC == 3
            melImg = repmat(melImg, 1, 1, 3);
        else
            melImg = melImg(:,:,1);
        end

        melImg = single(melImg);

        predictedLabel = classify(net, melImg);

        fprintf("Predicted Sound: %s\n", string(predictedLabel));
        return;
    end
end
