batch = 20;
T = readtable('2019-12-09_14-10-29.csv');
% T2 = readtable('2019-12-09_14-10-29.csv');
T2 = readtable('2019-12-10_22-02-57stoer.csv');
XTest = T(1:20,:);
T=T(20+1:end,:);
data = table2array(T(:,2:end));
length=size(data,1);
%XTest = T2(length+1:length+batch*10,:);
T2=T2(1:length,:);
data2 = table2array(T2(:,2:end));
data = data';
data2 = data2';



data = cat(2,data,data2);
length = 2*length;
%b = num2cell(data(1:20,:));
cellData=cell(1);
count=0;
for i = 1:5:(length-batch)
    count=count+1;
    b = num2cell(data(1:end-17,i:i+batch-1));
    cellData(count,1) ={cell2mat(b)};
end    
%data = array2table(data);
%C = table2cell(data);

x=ones(round(size(cellData,1)/2),1);
x2 = zeros(round(size(cellData,1)/2),1);
x= cat(1,x,x2);
cate = categorical(x,[1 0],{'1' '0'});





% numObservations = numel(cellData);
% for i=1:numObservations
%     sequence = cellData{i};
%     sequenceLengths(i) = size(sequence,2);
% end
% 
% [sequenceLengths,idx] = sort(sequenceLengths);
% cellData = cellData(idx);
% cellData = cellData(idx);
% 
% figure
% bar(sequenceLengths)
% ylim([0 30])
% xlabel("Sequence")
% ylabel("Length")
% title("Sorted Data")


inputSize = 3;
numHiddenUnits = 100;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer]
maxEpochs = 5;
miniBatchSize = 512;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','every-epoch', ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(cellData,cate,layers,options);


XTest = table2array(XTest(:,2:end));
XTest = XTest';
length=size(XTest,2);
temXTest=cell(1);
for i = 1:(length-batch+1)
    test = num2cell(XTest(1:end-17,i:i+batch-1));
    temXTest(i,1) ={cell2mat(test)};
end

XTest = temXTest;


miniBatchSize = 40;
YPred = classify(net,XTest, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest')




% A = table2array(T(1:1000,3:5));
% B = table2array(T(1:1000,2));
% 
% F = sqrt((table2array(T(1:1000,3))).^2+(table2array(T(1:1000,4))).^2+(table2array(T(1:1000,5))).^2);
% F=F-mean(F);
% % plot(B,A(:,1));
% % hold on
% % plot(B,A(:,2));
% % hold on
% % plot(B,A(:,3));
% % hold on
% plot (B,F);
% C=table2array(T(:,2));
% D = 1:1:size(C,1);
% fprintf("Test")
% %plot(D,C)