function main_train_cnn_selectable(datasets)

    addpath(genpath('src'));
    addpath('config');

    C = config();
    imgSize = [128 128];

    X_all = {};
    y_all = [];

    for d = datasets
        fprintf("\n--- Loading dataset: %s ---\n", d);

        D = getDatasetConfig(d);

        switch d
            case "esc50"
                T = loadEsc50Meta(D.metaCsv);
            case "us8k"
                T = loadUS8KMeta(D.metaCsv);
            case "fsd50k"
                T = loadFSD50KMeta(D.metaCsv, D.vocabCsv);
        end

        fprintf("Extracting Log-Mel for %s...\n", d);

        [X,y] = extractMelSpec_dataset( ...
            D.audioRoot, T, D.fnameCol, D.labelCol, imgSize, d);

        X_all = [X_all; X];
        y_all = [y_all; y];
    end

    fprintf("\nTraining CNN...\n");

    M = trainCNN_selectable(X_all, y_all, imgSize);

    % ===== building file name =====
    dsname = strjoin(datasets,"_");
    modelPath = sprintf("models/model_%s_cnn_melspec.mat", dsname);

    save(modelPath, "M", "datasets", "-v7.3");

    fprintf("\nModel saved: %s\n", modelPath);
end
