function main_train_cnn_selectable_gui()
    addpath(genpath(pwd));

    f = figure("Name","CNN Dataset Selector", ...
               "Position",[500, 400, 350, 280], ...
               "MenuBar","none", ...
               "NumberTitle","off");

    uicontrol(f,"Style","text", ...
        "String","Select Datasets for CNN Training", ...
        "Position",[50 230 250 30], ...
        "FontSize",12);

    cb1 = uicontrol(f,"Style","checkbox","String","ESC-50", ...
        "Position",[50 190 200 25],"FontSize",11);

    cb2 = uicontrol(f,"Style","checkbox","String","UrbanSound8K", ...
        "Position",[50 160 200 25],"FontSize",11);

    cb3 = uicontrol(f,"Style","checkbox","String","FSD50K (dev)", ...
        "Position",[50 130 200 25],"FontSize",11);

    uicontrol(f,"Style","pushbutton","String","Start Training", ...
        "FontSize",12,"Position",[90 60 160 40], ...
        "BackgroundColor",[0.2 0.6 1], ...
        "Callback",@(src,evt) onStart(cb1,cb2,cb3));
end

function onStart(cb1,cb2,cb3)
    selected = [];

    if cb1.Value, selected(end+1) = 1; end
    if cb2.Value, selected(end+1) = 2; end
    if cb3.Value, selected(end+1) = 3; end

    if isempty(selected)
        errordlg("Please select at least one dataset!","Error");
        return;
    end

    disp("=== User selected datasets (CNN) ===");
    disp(selected);

    main_train_cnn_core(selected);
end
