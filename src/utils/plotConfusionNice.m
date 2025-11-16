function plotConfusionNice(yTrue, yPred, titleStr)
% Inputs:
%   yTrue     - True labels
%   yPred     - Predicted labels
%   titleStr  - (Optional) Title string

    if nargin < 3
        titleStr = "Confusion Matrix";
    end

    cm = confusionchart(yTrue, yPred);

    % Optional styling
    cm.Title = titleStr;
    cm.RowSummary = 'row-normalized';
    cm.ColumnSummary = 'column-normalized';
    cm.FontSize = 12;

end