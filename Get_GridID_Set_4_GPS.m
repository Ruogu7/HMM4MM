function GPS_with_GridID_Set = Get_GridID_Set_4_GPS
    %%  function  Get_Line_with_GridID_Set
    % Steps:
    % EXAMPLE: GPS_with_GridID_Set = Get_GridID_Set_4_GPS
    % GPS_with_GridID_Set: gps id, x,y, num, grid 1234.
    
    %% initialize
    load GPS_data_bl_xy.txt;
    % gps id, time slot, b, l, x, y
    GPS_data_Set = GPS_data_bl_xy;
    GPS_with_GridID_Set = zeros(size(GPS_data_Set,1),8);
    
    QuadtreeStructure = Build_QuadtreeStructure_with_GPS_Lines_near_GPS;
    % QuadtreeStructure: Grid_side_length, Start_x, Start_y, Grid_x_num, Grid_y_num
    
    format long g;
    fid_GPS_with_GridID_Set = fopen('GPS_with_GridID_Set.txt', 'wt');
    
    for i_gps = 1:size(GPS_data_Set,1)
        x_GPS = GPS_data_Set(i_gps,5);
        y_GPS = GPS_data_Set(i_gps,6);
        x_min_grid = ceil((x_GPS-20-QuadtreeStructure(2))/QuadtreeStructure(1));
        x_max_grid = ceil((x_GPS+20-QuadtreeStructure(2))/QuadtreeStructure(1));
        y_min_grid = ceil((y_GPS-20-QuadtreeStructure(3))/QuadtreeStructure(1));
        y_max_grid = ceil((y_GPS+20-QuadtreeStructure(3))/QuadtreeStructure(1));
        
        
        GPS_with_GridID_Set(i_gps,1) = GPS_data_Set(i_gps,1);   % gps id
        GPS_with_GridID_Set(i_gps,2) = GPS_data_Set(i_gps,5);   % x
        GPS_with_GridID_Set(i_gps,3) = GPS_data_Set(i_gps,6);   % y
        GPS_with_GridID_Set(i_gps,4) = (x_max_grid - x_min_grid + 1)*(y_max_grid - y_min_grid + 1);   % num of grid ID
        k_grid = 4;
        for i_x_grid = x_min_grid:x_max_grid
            for i_y_grid = y_min_grid:y_max_grid
                k_grid = k_grid + 1;
                GPS_with_GridID_Set(i_gps,k_grid) = (i_y_grid-1)*QuadtreeStructure(4)+i_x_grid;
            end
        end
        
        fprintf(fid_GPS_with_GridID_Set, '%d\t',GPS_with_GridID_Set(i_gps,1));
        fprintf(fid_GPS_with_GridID_Set, '%16.5f\t',GPS_with_GridID_Set(i_gps,2));
        fprintf(fid_GPS_with_GridID_Set, '%16.5f\t',GPS_with_GridID_Set(i_gps,3));
        for ii_file_line = 4:8
            fprintf(fid_GPS_with_GridID_Set, '%d\t',GPS_with_GridID_Set(i_gps,ii_file_line));
        end
        fprintf(fid_GPS_with_GridID_Set, '\n');
        
    end
    max(GPS_with_GridID_Set(:,4))
    kk_1 = GPS_with_GridID_Set(:,5) > 7289;
    
    GPS_ID_1 = GPS_with_GridID_Set(kk_1,:)
    
    kk_2 = GPS_with_GridID_Set(:,6) > 7289;
    
    GPS_ID_2 = GPS_with_GridID_Set(kk_2,:)
    
    kk_3 = GPS_with_GridID_Set(:,7) > 7289;
    
    GPS_ID_3 = GPS_with_GridID_Set(kk_3,:)
    
    kk_4 = GPS_with_GridID_Set(:,8) > 7289;
    
    GPS_ID_4 = GPS_with_GridID_Set(kk_4,:)
    
    kk_5 = GPS_with_GridID_Set(:,8) > 7000;
    
    GPS_ID_5 = GPS_with_GridID_Set(kk_5,:)
    
    
     % close
    fclose(fid_GPS_with_GridID_Set);
end


