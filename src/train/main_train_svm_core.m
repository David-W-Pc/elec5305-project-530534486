function main_train_svm_core(datasets)

    addpath(genpath('src'));
    addpath('config');

    % Start parallel pool
    p = gcp('nocreate');
    if isempty(p)
        parpool("Processes");
    end

    numCoeffs = 13;
    X_all = [];
    y_all = [];

    fprintf("\n=== Starting MFCC extraction (%d datasets) ===\n", numel(datasets));

    % Progress bar
    hwait = waitbar(0, "Extracting MFCC...", "Name", "MFCC Extraction");

    totalDatasets = numel(datasets);
    datasetIndex = 0;

    for d = datasets
        datasetIndex = datasetIndex + 1;

        fprintf("\n--- Loading dataset: %s ---\n", d);
        waitbar((datasetIndex-1)/totalDatasets, hwait, ...
            sprintf("Processing %s ...", d));

        D = getDatasetConfig(d);

        switch d
            case "esc50"
                T = loadEsc50Meta(D.metaCsv);
            case "us8k"
                T = loadUS8KMeta(D.metaCsv);
            case "fsd50k"
                T = loadFSD50KMeta(D.metaCsv, D.vocabCsv);
        end

        fprintf("Extracting FIXED MFCC for %s...\n", d);

        [X, y] = extractFixedMFCC_dataset( ...
            D.audioRoot, T, D.fnameCol, D.labelCol, numCoeffs, d);

        fprintf("  -> Done. %d samples.\n", size(X,1));

        X_all = [X_all; X];
        y_all = [y_all; y];
    end

    waitbar(1, hwait, "Completed MFCC extraction.");
    pause(0.3);
    close(hwait);

    % ---------------- SVM TRAINING ----------------
    fprintf("\n=====================================\n");
    fprintf("Training SVM classifier on %d samples...\n", size(X_all,1));
    fprintf("=====================================\n");

    M = trainBaselineSVM_2way(X_all, y_all);

    % Auto filename
    modelName = "model_" + strjoin(datasets, "_") + "_mfcc_svm.mat";
    modelPath = fullfile("models", modelName);

    featureType  = "mfcc";
    datasetsUsed = datasets;
    save(modelPath, "M", "featureType", "datasetsUsed", "-v7.3");

    fprintf("\nModel saved to: %s\n", modelPath);


end
