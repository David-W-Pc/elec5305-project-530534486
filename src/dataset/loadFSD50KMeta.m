function T = loadFSD50KMeta(devCsvPath, vocabCsvPath)

    opts = detectImportOptions(devCsvPath, 'VariableNamingRule', 'preserve');
    Traw = readtable(devCsvPath, opts);

    % Validate columns
    if ~all(ismember({'fname','labels'}, Traw.Properties.VariableNames))
        error("dev.csv must contain 'fname' and 'labels' columns.");
    end

    n = height(Traw);

    filenames = strings(n,1);
    labels    = strings(n,1);

    for i = 1:n
        % ---------- Build filename ----------
        fn = string(Traw.fname(i));
        filenames(i) = fn + ".wav";

        % ---------- Handle label(s) ----------
        labStr = string(Traw.labels(i));

        % Missing / empty label
        if ismissing(labStr) || strlength(labStr) == 0
            labels(i) = "unknown";
            continue;
        end

        % Split label list (e.g. "Electric_guitar,Guitar")
        parts = split(labStr, {',',';',' '});
        parts = parts(strlength(parts) > 0);

        if isempty(parts)
            labels(i) = "unknown";
        else
            labels(i) = parts(1);   % keep first label
        end
    end

    T = table();
    T.filename = filenames;
    T.label    = categorical(labels);
end