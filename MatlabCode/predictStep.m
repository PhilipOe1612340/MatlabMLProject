function [y_pred]=predictStep(net,x_test,MiniBatchSize)
% net -> train network out of func 'trainLSTM'
% x_test -> test set for which the data is predicted (prepared with func
%           'prepareTestData' or 'prepareTrainData'
% MiniBatchSize -> defines the amount of Batches 
% 
    y_pred = classify(net,x_test, ...
        'MiniBatchSize',MiniBatchSize, ...
        'SequenceLength','longest');
end