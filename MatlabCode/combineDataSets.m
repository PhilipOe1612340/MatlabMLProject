function [x_data,y_data]=combineDataSets(x_data,y_data,x_2add,y_2add)
    if (size(x_data,1)==0)
        x_data = x_2add;
        y_data = y_2add;
    else
        x_data = cat(1,x_data,x_2add);
        y_data = cat(1,y_data,y_2add);
    end
    



end