function []=saveTrainData(x_data,y_data,name)
    save(append('x_data_',name),'x_data');
    save(append('y_data_',name),'y_data');
end