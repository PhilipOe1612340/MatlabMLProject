function [data,col]=loadCSV(file,start,ende,category)
% file
% category -> defines the category the data is a type of: step = 1  / noStep = 0

%example:
% % [data,col]=loadCSV('2019-12-13_16-36-30_noise',215,3590,0);
% % [data,col]=loadCSV('2019-12-13_16-43-24_noise',330,3670,0);
% % [data,col]=loadCSV('2019-12-13_16-51-52_noise',200,3755,0);
% % [data,col]=loadCSV('2019-12-13_17-05-46_noise',231,3530,0);
% % [data,col]=loadCSV('2019-12-18_16-52-33_walk',192,3667,1);


    
    filename = ['.\\Data\\SensorData\\' file '\\Accelerometer.csv'];

    %define included attributes
    %num_attributes=3;
    %------
    data = readtable(filename);
    
    %cut off timestep
    data = table2array(data(:,2:end));
    col = size(data,2);
    for i=2:col
        data(:,i)=(data(:,i)+40)./80;
    end
    if ende <1
        ende = size(data,1);
    end
    data = data(start:ende,1:col);
    plot(data(:,1),data(:,2:end));
    cate = category*ones(size(data(:,1)));
    data = cat(2,data,cate);
    
    save(append('.\\Data\\SensorData\\preparedData\\',file),'data');
%     length=size(data,1);
%     data = data';
%     
%     %transform data into the right format
%     cellData=cell(1);
%     count=0;
%     for i = 1:XthSlidingWindow:(length-batchSize)
%         count=count+1;
%         b = num2cell(data(1:num_attributes,i:i+batchSize-1));
%         cellData(count,1) ={cell2mat(b)};
%     end
%     %create the groundtruth relying on the given category
%     y = category * ones(round(size(cellData,1)),1);
%     y_truth = categorical(y,[1 0],{'1' '0'});
end