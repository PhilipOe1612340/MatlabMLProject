function [ ]=slidingWindow(overlapping,batchSize)
    listing = dir('.\\Data\\SensorData\\preparedData');
    
    numFiles = size(listing,1);
    for i=3:numFiles
        data = load(['.\\Data\\SensorData\\preparedData\\' listing(i).name]);
        data= data(1).data';
        length=size(data,2);
        cellData=cell(1);
        count=0;
        for j = 1:overlapping:length-batchSize+1
            count=count+1;
            b = num2cell(data(2:end-1,j:j+batchSize-1));
            cellData(count,1) ={cell2mat(b)};
        end
        %test=data;
        y = data(end,1) * ones(round(size(cellData,1)),1);
        y_truth = categorical(y,[1 0],{'1' '0'});
        save(append('.\\Data\\SensorData\\trainDataSep\\',listing(i).name),'cellData','y_truth');
        %save(append('.\\Data\\SensorData\\trainDataSep\\y',listing(i).name),'y_truth');
    end
end