file = '2020-01-07_17-37-37_walk';
filename = ['.\\Data\\SensorData\\' file '\\Accelerometer.csv'];

%define included attributes
%num_attributes=3;
%------
data = readtable(filename);

%cut off timestep
data = table2array(data(:,2:end));
steps = detectAmountOfSteps(data)
