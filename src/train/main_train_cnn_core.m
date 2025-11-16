function modelPath = main_train_cnn_core(datasetIDs)

    addpath(genpath('src'));
    addpath('config');

    C = config();

    datasetMap = ["esc50","us8k","fsd50k"];
    datasets   = datasetMap(datasetIDs);

    fprintf("\n=== Starting CNN Training ===\n");
    disp("Selected datasets: " + join(datasets,", "));

    fileList  = {};
    labelList = {};

    % ===============================================================
    % 1. Load Metadata
    % ===============================================================
    for d = datasets
        fprintf("\nLoading dataset: %s\n", d);

        D = getDatasetConfig(d);

        switch d
            case "esc50"
                T = loadEsc50Meta(D.metaCsv);
                for i = 1:height(T)
                    fileList{end+1}  = fullfile(D.audioRoot, T.filename{i});
                    labelList{end+1} = char(string(T.label(i)));
                end

            case "us8k"
                T = loadUS8KMeta(D.metaCsv);
                for i = 1:height(T)
                    fileList{end+1} = fullfile( ...
                        D.audioRoot, sprintf("fold%d", T.fold(i)), ...
                        T.slice_file_name{i});
                    labelList{end+1} = char(string(T.class{i}));
                end

            case "fsd50k"
                T = loadFSD50KMeta(D.metaCsv, D.vocabCsv);
                for i = 1:height(T)
                    fileList{end+1} = fullfile(D.audioRoot, T.fname{i});
                    labelList{end+1} = char(string(T.label(i)));
                end
        end
    end

    totalN = numel(fileList);
    fprintf("\nLoaded %d audio files total.\n", totalN);

    % ===============================================================
    % 2. Clean labelList
    % ===============================================================
    labelList_clean = cellfun( ...
        @(x) char(string(x)), ...
        labelList, "UniformOutput",false);

    Y = categorical(labelList_clean);
    fprintf("Unique classes: %d\n", numel(categories(Y)));

    % ===============================================================
    % 3. Generate Log-Mel Spectrograms
    % ===============================================================
    fprintf("Generating Log-Mel spectrograms...\n\n");

    imgH = 128;
    imgW = 128;
    X = zeros(imgH, imgW, 1, totalN, "single");

    for i = 1:totalN
        if mod(i,500)==0
            fprintf("  Processed %d / %d...\n", i, totalN);
        end

        fp = fileList{i};
        if ~isfile(fp), continue; end

        try
            [x, fs] = audioread(fp);
            x = mean(x,2);
            melImg = extractMelSpec(x, fs, [imgH imgW]);
            X(:,:,1,i) = melImg;
        catch
            warning("Cannot read %s", fp);
        end
    end

    fprintf("\nMel-spectrogram extraction complete.\n");

    % ===============================================================
    % 3.5 Split Train / Validation
    % ===============================================================
    fprintf("Splitting dataset into train/validation...\n");

    idx = randperm(totalN);

    nTrain = round(0.8 * totalN);
    trainIdx = idx(1:nTrain);
    valIdx   = idx(nTrain+1:end);

    XTrain = X(:,:,:,trainIdx);
    YTrain = Y(trainIdx);

    XVal   = X(:,:,:,valIdx);
    YVal   = Y(valIdx);

    fprintf("Training samples:   %d\n", numel(YTrain));
    fprintf("Validation samples: %d\n", numel(YVal));

    % ===============================================================
    % 4. CNN Architecture
    % ===============================================================
    layers = [
        imageInputLayer([imgH imgW 1],"Name","input")

        convolution2dLayer(3,16,"Padding","same")
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2,"Stride",2)

        convolution2dLayer(3,32,"Padding","same")
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2,"Stride",2)

        convolution2dLayer(3,64,"Padding","same")
        batchNormalizationLayer
        reluLayer

        fullyConnectedLayer(numel(categories(Y)))
        softmaxLayer
        classificationLayer
    ];

    opts = trainingOptions("adam", ...
        "InitialLearnRate",1e-3, ...
        "MaxEpochs",15, ...
        "MiniBatchSize",64, ...
        "Shuffle","every-epoch", ...
        "ValidationData",{XVal, YVal}, ...
        "ValidationFrequency",50, ...
        "Verbose",true, ...
        "Plots","training-progress");

    % ===============================================================
    % 5. Train CNN
    % ===============================================================
    fprintf("\nTraining CNN model...\n");
    net = trainNetwork(XTrain, YTrain, layers, opts);

    % ===============================================================
    % 6. Save model
    % ===============================================================
    outName = "model_cnn_" + join(datasets,"_") + ".mat";
    modelPath = fullfile(C.modelsDir, outName);

    save(modelPath, "net", "datasets", "-v7.3");

    fprintf("\nModel saved to: %s\n", modelPath);
end
