%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "date", "platform", "url", "title", "body", "author", "tags", "num_comments", "Var11"];
opts.SelectedVariableNames = ["date", "platform", "url", "title", "body", "author", "tags", "num_comments"];
opts.VariableTypes = ["string", "string", "double", "categorical", "string", "string", "string", "string", "string", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "url", "title", "body", "author", "tags", "Var11"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "platform", "url", "title", "body", "author", "tags", "Var11"], "EmptyFieldRule", "auto");

% Import the data
StackOverflowAll = readtable(fullfile([pwd '/' 'stackOverflowAll.csv']), opts);


%% Clear temporary variables
clear opts

finalData = StackOverflowAll(~cellfun('isempty', StackOverflowAll.body) & ~cellfun('isempty', StackOverflowAll.title), :);

finalBody = finalData.title;

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