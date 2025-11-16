function [X, y] = extractFixedMFCC_dataset(audioRoot, T, fnameCol, labelCol, numCoeffs, datasetName)
% EXTRACTFIXEDMFCC_DATASET - Parallel + Safe + Progress display
% Outputs FIXED MFCC: [MFCC + delta] → 2*numCoeffs features

    fprintf("  Dataset = %s\n", datasetName);
    N = height(T);

    % Preallocate feature matrix
    X = zeros(N, numCoeffs * 2);
    y = strings(N, 1);

    % Progress counter (needs parallel-safe method)
    progress = parallel.pool.DataQueue;
    afterEach(progress, @(~) updateProgress(N));

    global PROGRESS_COUNT;
    PROGRESS_COUNT = 0;
    tic;

    fprintf("  Starting parallel MFCC extraction (%d clips)...\n", N);

    parfor i = 1:N
        localX = zeros(1, numCoeffs * 2);
        localY = "";

        % Resolve path
        try
            switch datasetName
                case "esc50"
                    wavPath = fullfile(audioRoot, char(T.(fnameCol)(i)));

                case "us8k"
                    fold = T.fold(i);
                    wavPath = fullfile(audioRoot, sprintf("fold%d", fold), char(T.(fnameCol)(i)));

                case "fsd50k"
                    wavPath = fullfile(audioRoot, char(T.(fnameCol)(i)));

                otherwise
                    continue;
            end

            if ~isfile(wavPath)
                send(progress, 1);
                continue;
            end

            % Read audio
            [x, fs] = audioread(wavPath);
            x = mean(x, 2);

            % Extract fixed MFCC
            feat = extractFixedMFCC(x, fs, numCoeffs);
            localX = feat;
            localY = string(T.(labelCol)(i));

        catch
            % skip file
        end

        X(i, :) = localX;
        y(i)    = localY;

        send(progress, 1);
    end

    fprintf("\n  Done MFCC %s in %.2f sec\n", datasetName, toc);
    y = categorical(y);
end


% --------------------------------------------------------------
% Progress bar function
% --------------------------------------------------------------
function updateProgress(N)
    persistent lastPrint;
    if isempty(lastPrint), lastPrint = tic; end

    global PROGRESS_COUNT;
    PROGRESS_COUNT = PROGRESS_COUNT + 1;

    if toc(lastPrint) > 0.5
        pct = PROGRESS_COUNT / N * 100;
        fprintf("    Progress: %.1f%% (%d/%d)\n", pct, PROGRESS_COUNT, N);
        lastPrint = tic;
    end
end
