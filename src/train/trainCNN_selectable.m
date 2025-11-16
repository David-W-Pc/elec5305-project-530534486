function M = trainCNN_selectable(X_all, y_all, imgSize)

    fprintf("\n=== Building CNN ===\n");

    layers = [
        imageInputLayer([imgSize 1], 'Normalization','none')

        convolution2dLayer(3,16,'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3,32,'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3,64,'Padding','same')
        batchNormalizationLayer
        reluLayer

        fullyConnectedLayer(numel(categories(y_all)))
        softmaxLayer
        classificationLayer
    ];

    options = trainingOptions('adam', ...
        'MaxEpochs', 25, ...
        'MiniBatchSize', 32, ...
        'Shuffle','every-epoch', ...
        'Verbose', true, ...
        'Plots','training-progress');

    net = trainNetwork(X_all, y_all, layers, options);

    M.net = net;
    M.labelSet = categories(y_all);
end
