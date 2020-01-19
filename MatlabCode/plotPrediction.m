function [continious_data]=plotPrediction(x_test,y_pred,SampleFreq,continious_data)
% net -> train network out of func 'trainLSTM'
% x_test -> test set for which the data is predicted (prepared with func
%           'prepareTestData' or 'prepareTrainData'
% MiniBatchSize -> defines the amount of Batches 
% 
    samples = size(x_test,1);
    firstIter= true;
    for i=1:samples
        data = x_test{i};
        data = data';
        y = double(y_pred(i))*ones(size(data,1),1);
        %test
        y(y==2)=0;
        tempData = [data,y];
        if(firstIter)
            fullData = tempData;
            firstIter = false;
        else
            fullData = cat(1,fullData,tempData);
        end
    end
    y_values = fullData(:,end);
    continious_data = cat(1,continious_data,fullData);
    if (size(continious_data,1)>300)
       continious_data=continious_data(end-300:end,:); 
    end
    DataLength = size(continious_data,1);
    x = 0:SampleFreq:(DataLength-1)*SampleFreq;
    
    tiledlayout(2,1) % Requires R2019b or later

    % Top plot
    nexttile
    p=plot(x,continious_data(:,end:end));
    p(1).LineWidth = 5;
    ylim([0 1])
    title('Prediction')

    % Bottom plot
    nexttile
    plot(x,continious_data(:,1:end-1));
    ylim([-1 1])
    title('Sensor Data')

        
        
end