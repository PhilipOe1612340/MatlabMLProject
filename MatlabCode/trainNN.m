function [ acc]=trainNN()
    listing = dir('.\\Data\\SensorData\\trainDataSep');
    
    numFiles = size(listing,1);
    first=true;
    %combine all the train data
    for i=3:numFiles
        
   
        data = load(['.\\Data\\SensorData\\trainDataSep\\' listing(i).name]);
        
        x = data(1).cellData;
        y = data(1).y_truth;
        if first
            x_data = x;
            y_data = y;
            first = false;
        else
            x_data=cat(1,x_data,x);
            y_data = cat(1,y_data,y);
        end
    end
    
    
    net = trainLSTM(x_data,y_data,100,1024);
    
    t = datetime('now');
    path = append('.\\Data\\networks\\',num2str(year(t)),'-',num2str(month(t)),'-',num2str(day(t)),'_',num2str(hour(t)),'-',num2str(minute(t)),'-',num2str(second(t)),'.mat');
    save(path,'net');
    
    data = load(['.\\Data\\SensorData\\testDataSep\\' '2020-01-08_14-19-10_walk_untimed.mat']);
    x = data(1).cellData;
    y = data(1).y_truth;
    y_pred=predictStep(net,x,512);

    y_values = plotPrediction(x,y_pred,100);
    predRight = y(y==y_pred);
%     acc=size(predRight,1) /size(y_pred,1);
end