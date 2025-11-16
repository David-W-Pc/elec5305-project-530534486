function main_train_svm_selectable_gui()
% GUI for selecting datasets: ESC50 / US8K / FSD50K
% Calls main_train_svm_selectable(selectedDatasets)
    addpath(genpath(pwd));


    f = figure("Name", "Dataset Selector (SVM)", ...
               "Position", [500, 400, 350, 280], ...
               "MenuBar", "none", ...
               "NumberTitle", "off");

    uicontrol(f, "Style", "text", ...
        "String", "Select Datasets to Train SVM", ...
        "Position", [70 230 220 30], ...
        "FontSize", 12);

    % Checkboxes
    cb1 = uicontrol(f, "Style", "checkbox", ...
        "String", "ESC-50", ...
        "Position", [50 190 200 25], ...
        "FontSize", 11);

    cb2 = uicontrol(f, "Style", "checkbox", ...
        "String", "UrbanSound8K", ...
        "Position", [50 160 200 25], ...
        "FontSize", 11);

    cb3 = uicontrol(f, "Style", "checkbox", ...
        "String", "FSD50K", ...
        "Position", [50 130 200 25], ...
        "FontSize", 11);

    % Start button
    uicontrol(f, "Style", "pushbutton", ...
        "String", "Start Training", ...
        "FontSize", 12, ...
        "Position", [90 60 160 40], ...
        "BackgroundColor", [0.3 0.8 0.4], ...
        "Callback", @(src,evt) onStart(cb1,cb2,cb3));

end


function onStart(cb1, cb2, cb3)
% Called when "Start Training" is clicked

    selected = [];

    if cb1.Value == 1
        selected = [selected, 1];
    end
    if cb2.Value == 1
        selected = [selected, 2];
    end
    if cb3.Value == 1
        selected = [selected, 3];
    end

    if isempty(selected)
        errordlg("Please select at least one dataset!", "No Selection");
        return;
    end

    disp("=== User selected datasets ===");
    disp(selected);

    % Pass to train script
    main_train_svm_selectable(selected);
end
