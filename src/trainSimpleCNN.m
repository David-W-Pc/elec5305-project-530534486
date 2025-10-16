function net = trainSimpleCNN(imgRoot)
    imds = imageDatastore(imgRoot, 'IncludeSubfolders', true, 'LabelSource','foldernames');
    [imdsTrain, imdsVal] = splitEachLabel(imds, 0.8, 'randomized');

    inputSize = [128 128 1];
    layers = [
        imageInputLayer(inputSize)
        convolution2dLayer(3,16,'Padding','same'), batchNormalizationLayer, reluLayer
        maxPooling2dLayer(2,'Stride',2)
        convolution2dLayer(3,32,'Padding','same'), batchNormalizationLayer, reluLayer
        maxPooling2dLayer(2,'Stride',2)
        convolution2dLayer(3,64,'Padding','same'), batchNormalizationLayer, reluLayer
        globalAveragePooling2dLayer
        fullyConnectedLayer(numel(categories(imds.Labels)))
        softmaxLayer
        classificationLayer];

    aug = imageDataAugmenter('RandXReflection',false);
    dsTrain = augmentedImageDatastore(inputSize, imdsTrain, 'DataAugmentation', aug, 'ColorPreprocessing','gray2rgb');
    dsVal   = augmentedImageDatastore(inputSize, imdsVal,   'ColorPreprocessing','gray2rgb');

    opts = trainingOptions('adam', ...
        'MaxEpochs', 10, ...
        'MiniBatchSize', 64, ...
        'Shuffle','every-epoch', ...
        'ValidationData', dsVal, ...
        'Plots','training-progress', ...
        'Verbose', false);

    net = trainNetwork(dsTrain, layers, opts);
end