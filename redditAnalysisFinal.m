%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["date", "platform", "url", "title", "body", "tags", "author", "num_comments", "ups", "VarName10"];
opts.VariableTypes = ["double", "categorical", "string", "string", "string", "string", "string", "double", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["url", "title", "body", "tags", "author", "VarName10"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["platform", "url", "title", "body", "tags", "author", "VarName10"], "EmptyFieldRule", "auto");

% Import the data
redditDatafinal = readtable(fullfile([pwd '/' 'redditDatafinal.csv']), opts);



%% Clear temporary variables
clear opts

finalData = redditDatafinal(~cellfun('isempty', redditDatafinal.body) | ~cellfun('isempty', redditDatafinal.title), :);

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
