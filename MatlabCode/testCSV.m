function [ acc]=testCSV(start,ende2,category,overlapping,batchSize,netName)
continious_data=[[0 0 0 0]];
options = weboptions("Timeout",10);
while (1)
    tic
    ende = ende2;
    url = 'https://matlab.oesterlin.dev/csv';
    file = 'data.csv';
    outfilename = websave(file,url,options);

    net = load(['.\\Data\\networks\\' netName]);
    net= net(1).net';
    
    filename = ['.\\' file];

    
    data = readtable(filename);
    
    %cut off timestep
    data = table2array(data(:,2:end));
    col = size(data,2);
    for i=1:col
        data(:,i)=(data(:,i)+40)./80;
    end
    if ende <1
        ende = size(data,1);
    end
    data = data(start:ende,1:col);
    display(size(data));
    if (size(data,1)~=0)
    plot(data(:,1),data(:,2:end));
    cate = category*ones(size(data(:,1)));
    data = cat(2,data,cate);
    
%     save(append('.\\Data\\SensorData\\preparedTestData\\',file),'data');
%     
%     
%     listing = dir('.\\Data\\SensorData\\preparedTestData');
%     
%     
%         data = load(['.\\Data\\SensorData\\preparedTestData\\' listing(i).name]);
%         data= data(1).data';
        data =data';
        length=size(data,2);
        cellData=cell(1);
        count=0;
        for j = 1:overlapping:length-batchSize+1
            count=count+1;
            b = num2cell(data(1:end-1,j:j+batchSize-1));
            cellData(count,1) ={cell2mat(b)};
        end
        %test=data;
        y = data(end,1) * ones(round(size(cellData,1)),1);
        y_truth = categorical(y,[1 0],{'1' '0'});
%         save(append('.\\Data\\SensorData\\testDataSep\\',listing(i).name),'cellData','y_truth');
        %save(append('.\\Data\\SensorData\\trainDataSep\\y',listing(i).name),'y_truth');
%     end

% data = load('.\\data.csv');
% x = data(1).cellData;
x=cellData;
% y = data(1).y_truth;
y_pred=predictStep(net,x,512);

continious_data = plotPrediction(x,y_pred,0.1,continious_data);

    end
pause(3);
    toc 
    end
    
end