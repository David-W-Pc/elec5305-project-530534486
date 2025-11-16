function main_train_svm_selectable(selectedDatasets)
% selectedDatasets is a numeric vector like [1 2] or [1 3]

    if nargin < 1
        error("main_train_svm_selectable requires an input vector.");
    end

    % Convert number → dataset name
    map = ["esc50", "us8k", "fsd50k"];
    datasets = map(selectedDatasets);

    fprintf("=== User selected datasets ===\n");
    disp(datasets);

    % Now call your original training logic
    main_train_svm_core(datasets);
end
