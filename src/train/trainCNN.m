function net = trainCNN(imdsTrain, imdsVal, numClasses, imgSize)
% TRAINCNN  
% Trains a lightweight CNN for Mel-spectrogram classification.
%
% Inputs:
%   imdsTrain   - Training imageDatastore
%   imdsVal     - Validation imageDatastore
%   numClasses  - Number of output classes
%   imgSize     - Input image size, e.g. [128 128 1]
%
% Output:
%   net         - Trained network

    if nargin < 4
        imgSize = [128 128 1];
    end

    layers = [
        imageInputLayer(imgSize)

        convolution2dLayer(3, 16, 'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3, 32, 'Padding','same')
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(2,'Stride',2)

        convolution2dLayer(3, 64, 'Padding','same')
        batchNormalizationLayer
        reluLayer

        globalAveragePooling2dLayer

        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer
    ];

    options = trainingOptions('adam', ...
        'MaxEpochs', 12, ...
        'MiniBatchSize', 64, ...
        'Shuffle','every-epoch', ...
        'ValidationData', imdsVal, ...
        'ValidationPatience', 3, ...
        'Verbose', false, ...
        'Plots','training-progress');

    net = trainNetwork(imdsTrain, layers, options);
end