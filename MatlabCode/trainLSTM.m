function [net]=trainLSTM(x_train,y_train,epochs,MiniBatchSize)
% x_train -> Training Data
% y_train -> Ground truth Data
% epochs -> Number of Epochs
% MiniBatchSize -> Mini Batch Size
    attributes = size(x_train{1},1);
    %fprintf('attr:',attributes);
    inputSize = attributes;
    numHiddenUnits = 100;
    numClasses = 2;

    layers = [ ...
        sequenceInputLayer(inputSize)
        bilstmLayer(numHiddenUnits,'OutputMode','last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];
    maxEpochs = epochs;
    miniBatchSize = MiniBatchSize;

    options = trainingOptions('adam', ...
        'ExecutionEnvironment','gpu', ...
        'GradientThreshold',1, ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest', ...
        'Shuffle','every-epoch', ...
        'Verbose',0, ...
        'Plots','training-progress');
    net = trainNetwork(x_train,y_train,layers,options);
end