function label = predictCNN(net, x, fs, imgSize)
    img = extractMelSpec_CNN(x, fs, imgSize);
    img = single(img);
    label = classify(net, img);
end
