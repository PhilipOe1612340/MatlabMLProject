[x_data,y_data] = prepareTrainData('.\\Data\\2019-12-13_16-36-30_noise.csv',20,20,0);
[x_data2,y_data2] = prepareTrainData('.\\Data\\2019-12-13_16-43-24_noise.csv',20,20,0);
[x_data3,y_data3] = prepareTrainData('.\\Data\\2019-12-13_16-51-52_noise.csv',20,20,0);
[x_data4,y_data4] = prepareTrainData('.\\Data\\2019-12-13_17-05-46_noise.csv',20,20,0);
[x_data5,y_data5] = prepareTrainData('.\\Data\\Sensor Record datadata Phi_walk.csv',20,20,1);
[x_data6,y_data6] = prepareTrainData('.\\Data\\Sensor Record data Fabian_walk 1.csv',20,20,1);
[x_data7,y_data7] = prepareTrainData('.\\Data\\Sensor Record data Fabian_walk 2.csv',20,20,1);
[x_data8,y_data8] = prepareTrainData('.\\Data\\Sensor Record data Phi_walk.csv',20,20,1);
[x_data9,y_data9] = prepareTrainData('.\\Data\\2019-12-10_21-13-04_tobi.csv',20,20,1);
[x_data10,y_data10] = prepareTrainData('.\\Data\\2019-12-10_21-19-36_tobi.csv',20,20,1);




[x_data,y_data]=combineDataSets(x_data,y_data,x_data2,y_data2);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data3,y_data3);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data4,y_data4);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data5,y_data5);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data6,y_data6);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data7,y_data7);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data8,y_data8);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data9,y_data9);
[x_data,y_data]=combineDataSets(x_data,y_data,x_data10,y_data10);


net = trainLSTM(x_data,y_data,4,512);

[x_data9,y_data9] = prepareTrainData('.\\Data\\2019-12-10_21-13-04_tobi.csv',20,20,1);
%x_data9 = prepareTestData('.\\Data\\2019-12-10_21-13-04_tobi.csv',20,20);
y_pred=predictStep(net,x_data9,128);

fullData = plotPrediction(x_data9,y_pred,100);
%saveTrainData(x_data,y_data,'test');
%plotPrediction(x_data,y_data,100);