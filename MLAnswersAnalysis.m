%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "date", "platform", "type", "url", "title", "body", "author", "tags", "Views", "ups"];
opts.SelectedVariableNames = ["date", "platform", "type", "url", "title", "body", "author", "tags", "Views", "ups"];
opts.VariableTypes = ["string", "double", "categorical", "categorical", "string", "string", "string", "categorical", "string", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "url", "title", "body", "tags"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "platform", "type", "url", "title", "body", "author", "tags"], "EmptyFieldRule", "auto");

% Import the data
MLanswers = readtable(fullfile([pwd '/' 'ML_answers.csv']), opts);


%% Clear temporary variables
clear opts

finalData = MLanswers(~cellfun('isempty', MLanswers.body) | ~cellfun('isempty', MLanswers.title), :);

finalBody = finalData.title + ' ' + finalData.body;

finalBody = eraseURLs(finalBody);
finalBody = eraseTags(finalBody);
finalBody = erasePunctuation(finalBody);

allTags = {};

for i=1:length(finalBody)
    finalBody{i} = replace(finalBody{i}, newline, ' ');
    finalBody{i}(~ismember(finalBody{i},['A':'Z' 'a':'z' '1':'9' ' '])) = '';
    finalData.tags(i) = replace(finalData.tags(i), '[', '');
    finalData.tags(i) = replace(finalData.tags(i), ']', '');
    finalData.tags(i) = replace(finalData.tags(i), ' ', '');
    finalData.tags(i) = replace(finalData.tags(i), "'", '');
    finalString = '';
    splitted = (split(finalData.tags(i), ','));
    for j=1:length(splitted)
        finalString = finalString + splitted(j) + ' ';
    end
    allTags{end+1} = finalString;
end

documents = tokenizedDocument(finalBody);
polarities = vaderSentimentScores(documents);

meanPolarity = mean(polarities);


documents = tokenizedDocument(allTags);
wordcloud(bagOfWords(documents))