function T = loadEsc50Meta(metaCsvPath)
    opts = detectImportOptions(metaCsvPath);
    T = readtable(metaCsvPath, opts);
    T = T(:, {'filename','fold','target','category'});
    T.category = categorical(string(T.category));
end