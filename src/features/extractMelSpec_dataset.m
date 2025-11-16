function [X, y] = extractMelSpec_dataset(audioRoot, T, fnameCol, labelCol, imgSize, datasetName)
% Extract Log-Mel image for CNN training
%
% Output: X = cell array of images, y = categorical labels

    fprintf("  Dataset = %s\n", datasetName);

    N = height(T);
    X = cell(N,1);
    y = strings(N,1);

    parfor i = 1:N

        % resolve audio path
        switch datasetName
            case "esc50"
                wavPath = fullfile(audioRoot, char(T.(fnameCol)(i)));
            case "us8k"
                wavPath = fullfile(audioRoot, sprintf("fold%d", T.fold(i)), char(T.(fnameCol)(i)));
            case "fsd50k"
                wavPath = fullfile(audioRoot, char(T.(fnameCol)(i)));
        end

        if ~isfile(wavPath)
            warning("Missing file: %s", wavPath);
            continue;
        end

        try
            [x, fs] = audioread(wavPath);
            x = mean(x,2);
        catch
            continue;
        end

        % ----- Log-Mel -----
        img = extractMelSpec(x, fs, imgSize);

        % CNN expects single precision
        X{i} = single(img);

        y(i) = string(T.(labelCol)(i));

        if mod(i,500)==0
            fprintf("   %d / %d processed...\n", i, N);
        end
    end

    y = categorical(y);
end
