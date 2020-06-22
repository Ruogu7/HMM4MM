function [ interpolating_GPS,GridID_Set_for_interpolating_GPS ]  = Get_GridID_Set_for_interpolating_GPS( gps_matrix)
    %% Get_GridID_Set_at_GPS_Singal_Blockage function description:
    % Imput:
    % Output:
    % GridID_LineID_near_GPS: Grid_ID, line num, line ID 12345....n
    %
    % Example
    % [ GridIDSet_at_GPS_Singal_Blockage_matrix, GridIDSet_at_GPS_Singal_Blockage_vector ]  = Get_GridID_Set_at_GPS_Singal_Blockage
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    %% gps_matrix
    % gps id, time, Latitude, Longitude, x, Y
    interpolating_GPS = [];
    i_interpolating_GPS = 0;
    
    distance = [];
    for i_gps = 1:size(gps_matrix,1)-1
        distance (i_gps ) = sqrt((gps_matrix(i_gps,5) - gps_matrix(i_gps+1,5)).^2 ...
            + (gps_matrix(i_gps,6) - gps_matrix(i_gps+1,6)).^2);
        
        if distance (i_gps ) > 100
            %% interpolating for more gps.
            distance (i_gps )
            i_gps
            point_num = ceil(distance (i_gps )/100);
            for ii = 1:(point_num-1)
                i_interpolating_GPS = i_interpolating_GPS + 1;
                interpolating_GPS(i_interpolating_GPS,1) = gps_matrix(i_gps,5) + ii*(gps_matrix(i_gps+1,5) - gps_matrix(i_gps,5))/point_num;
                interpolating_GPS(i_interpolating_GPS,2) = gps_matrix(i_gps,6) + ii*(gps_matrix(i_gps+1,6) - gps_matrix(i_gps,6))/point_num;
            end
        end
    end
    plot(interpolating_GPS(:,2),interpolating_GPS(:,1),'r+');
    hold on;
    GridIDSet_at_GPS_Singal_Blockage_matrix = zeros(size(interpolating_GPS,1),7);
    % x,y, gridID num, grid 1234;    
    
    QuadtreeStructure = Build_QuadtreeStructure_with_GPS_Lines_near_GPS;
    % QuadtreeStructure: Grid_side_length, Start_x, Start_y, Grid_x_num, Grid_y_num
    
    for i_gps = 1:size(interpolating_GPS,1)
        x_GPS = interpolating_GPS(i_gps,1);
        y_GPS = interpolating_GPS(i_gps,2);
        x_min_grid = ceil((x_GPS-20-QuadtreeStructure(2))/QuadtreeStructure(1));
        x_max_grid = ceil((x_GPS+20-QuadtreeStructure(2))/QuadtreeStructure(1));
        y_min_grid = ceil((y_GPS-20-QuadtreeStructure(3))/QuadtreeStructure(1));
        y_max_grid = ceil((y_GPS+20-QuadtreeStructure(3))/QuadtreeStructure(1));
        
        GridIDSet_at_GPS_Singal_Blockage_matrix(i_gps,1) = interpolating_GPS(i_gps,1);
        GridIDSet_at_GPS_Singal_Blockage_matrix(i_gps,2) = interpolating_GPS(i_gps,2);
        GridIDSet_at_GPS_Singal_Blockage_matrix(i_gps,3) = (x_max_grid - x_min_grid + 1)*(y_max_grid - y_min_grid + 1);
        k_grid = 3;
        for i_x_grid = x_min_grid:x_max_grid
            for i_y_grid = y_min_grid:y_max_grid
                k_grid = k_grid + 1;
                GridIDSet_at_GPS_Singal_Blockage_matrix(i_gps,k_grid) = (i_y_grid-1)*QuadtreeStructure(4)+i_x_grid;
            end
        end
    end
    
    %% get all the grid ID set near the Singal Blockage
    GridIDSet = GridIDSet_at_GPS_Singal_Blockage_matrix(:,4:7);
    GridIDSet = GridIDSet(:);
    GridIDSet = unique(GridIDSet);
    GridIDSet = GridIDSet';
    GridIDSet = GridIDSet (2:end);   % delete the zero
    GridID_Set_for_interpolating_GPS = GridIDSet;

end
