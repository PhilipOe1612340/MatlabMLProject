function [cellData]=prepareTestData(filename,batchSize,XthSlidingWindow)
%filename -> example: 'test.csv'
%batchSize -> how many samples refer to one group
% XthSlidingWindow -> in this case for test data it is set to 1

    XthSlidingWindow=1;
    
    %define included attributes
    num_attributes=20;
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
end