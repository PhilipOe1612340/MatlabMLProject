function [cellData,y_truth]=prepareTrainData(filename,batchSize,XthSlidingWindow,category)
%filename -> example: 'test.csv'
%batchSize -> how many samples refer to one group
% XthSlidingWindow -> reduce amount of sliding window, for default set 1
% category -> defines the category the data is a type of: step = 1  / noStep = 0


    %define included attributes
    num_attributes=3;
    %------
    data = readtable(filename);
    
    %cut off timestep
    data = table2array(data(:,2:end));
    
    
    
    length=size(data,1);
    data = data';
    
    %transform data into the right format
    cellData=cell(1);
    count=0;
    for i = 1:XthSlidingWindow:(length-batchSize)
        count=count+1;
        b = num2cell(data(1:num_attributes,i:i+batchSize-1));
        cellData(count,1) ={cell2mat(b)};
    end
    %create the groundtruth relying on the given category
    y = category * ones(round(size(cellData,1)),1);
    y_truth = categorical(y,[1 0],{'1' '0'});
end