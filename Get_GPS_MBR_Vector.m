function GPS_MBR_Vector = Get_GPS_MBR_Vector
    %% Get_GPS_MBR_Vector function description:
    % Imput:
    % Output:
    % GPS_MBR_Vector: min_x, min_y, Max_x, Max_y
    %
    % Example
    % GPS_MBR_Vector = Get_GPS_MBR_Vector
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    load GPS_data_bl_xy.txt;
    % gps id, time, Latitude, Longitude, x, Y
    
    GPS_MBR_Vector(1) = min(GPS_data_bl_xy(:,5))-20;
    GPS_MBR_Vector(2) = min(GPS_data_bl_xy(:,6))-20;
    GPS_MBR_Vector(3) = max(GPS_data_bl_xy(:,5))+20;
    GPS_MBR_Vector(4) = max(GPS_data_bl_xy(:,6))+20;
    
end


