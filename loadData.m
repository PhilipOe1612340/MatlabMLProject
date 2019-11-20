
function [X,y] = loadData()

% search for all avaliable csv files
files = dir('**/*.csv');

GPS = zeros(1,2);
ACC = zeros(1,3);
ACCLin = zeros(1,3);
GYR = zeros(1,3);
COMP = zeros(1,3);

for i = 1:length(files)
    fileName = files(i).name;
    path = fullfile(files(i).folder, fileName);
    file = readmatrix(path);
    fprintf([fileName ' found \n']);
    switch fileName(1:end-4)
        case 'GPS'
            GPS = vertcat(GPS, file(:, 3:4));
        case 'Accelerometer'
            ACC = vertcat(ACC, file(:, 3:5));
        case 'AccelerometerLinear'
            ACCLin = vertcat(ACCLin, file(:, 3:5));
        case 'Gyroscope'
            GYR = vertcat(GYR, file(:, 3:5));
        case 'Compass'
            COMP = vertcat(COMP, file(:,3:5));
        otherwise 
            fprintf('--- file ignored \n');
    end
end

% TODO: use HIGHPASS filter

% normalize
ACCLin = normalize(ACCLin,'range');
GYR = normalize(GYR,'range');
COMP = normalize(COMP,'range');

% calc gps distance between coordinate n and n+1
s = length(GPS);
dist = zeros(s(:,1), 1);
for i = 1:length(GPS)-1
    dist(i) = distance(GPS(i, :), GPS(i+1, :));
end

y = dist;
X = {ACCLin, GYR, COMP};

end
