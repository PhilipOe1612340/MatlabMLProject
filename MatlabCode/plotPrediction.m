function [full]=plotPrediction(x_test,y_pred,SampleFreq)
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
        tempData = [data,y];
        if(firstIter)
            fullData = tempData;
            firstIter = false;
        else
            fullData = cat(1,fullData,tempData);
        end
    end
    full = double(y_pred);
    DataLength = size(fullData,1);
    x = 0:SampleFreq:(DataLength-1)*SampleFreq;
    plot(x,fullData(:,:))
end