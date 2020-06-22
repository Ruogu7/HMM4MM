function [ Lines_in_GPS_Area_with_GridID ] = Get_GridID_4_Lines_near_GPS
    %% Get_GridID_4_Line_near_GPS function description:
    % Imput:
    % Output:
    % Line_in_GPS_Area_with_GridID: LineID, num of grid id, grid id 123.....n.
    %
    % Example
    %  [ Line_in_GPS_Area_with_GridID ] = Get_GridID_4_Lines_near_GPS
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    %% Lines_in_GPS_Area:
    load Lines_in_GPS_Area.txt;
    % LineID, min_x, min_y, Max_x, Max_y,length
    
    QuadtreeStructure = Build_QuadtreeStructure_with_GPS_Lines_near_GPS;
    % QuadtreeStructure: Grid_side_length, Start_x, Start_y, Grid_x_num, Grid_y_num
    
    fid_Lines_in_GPS_Area_with_GridID = fopen('Lines_in_GPS_Area_with_GridID.txt', 'wt');
    
    %% calculate the grid ID for Lines
    % Road_link_with_GridID:
    Lines_in_GPS_Area_with_GridID = zeros(size( Lines_in_GPS_Area,1 ),302);
    for i_line = 1:size( Lines_in_GPS_Area,1 )
        
        Min_x_Line_grid_ID = ceil((Lines_in_GPS_Area(i_line,2) - QuadtreeStructure(2))/200);
        Min_y_Line_grid_ID = ceil((Lines_in_GPS_Area(i_line,3) - QuadtreeStructure(3))/200);
        Max_x_Line_grid_ID = ceil((Lines_in_GPS_Area(i_line,4) - QuadtreeStructure(2))/200);
        Max_y_Line_grid_ID = ceil((Lines_in_GPS_Area(i_line,5) - QuadtreeStructure(3))/200);
        
        
        Lines_in_GPS_Area_with_GridID( i_line, 1 ) = Lines_in_GPS_Area(i_line,1);   % line ID
        Lines_in_GPS_Area_with_GridID( i_line, 2 ) = (Max_x_Line_grid_ID - Min_x_Line_grid_ID + 1 )*(Max_y_Line_grid_ID - Min_y_Line_grid_ID + 1);
        
        Grid_order = 2;
        for Grid_mark_1 = Min_x_Line_grid_ID:Max_x_Line_grid_ID
            for Grid_mark_2 = Min_y_Line_grid_ID:Max_y_Line_grid_ID
                Grid_order = Grid_order + 1;
                Lines_in_GPS_Area_with_GridID( i_line, Grid_order ) = QuadtreeStructure(4) * (Grid_mark_2-1) + Grid_mark_1;
            end
        end
        
        if ~mod(i_line,1000)
            i_line
        end
        for ii_file_line = 1:302
            fprintf(fid_Lines_in_GPS_Area_with_GridID, '%d\t', Lines_in_GPS_Area_with_GridID(i_line,ii_file_line));
        end
        fprintf(fid_Lines_in_GPS_Area_with_GridID, '\n');
        
    end
    
    max(Lines_in_GPS_Area_with_GridID(:,2))
    kk_1 = Lines_in_GPS_Area_with_GridID(:,5) > 7289;
    
    GPS_ID_1 = Lines_in_GPS_Area_with_GridID(kk_1,:)
    
    kk_2 = Lines_in_GPS_Area_with_GridID(:,6) > 7289;
    
    GPS_ID_2 = Lines_in_GPS_Area_with_GridID(kk_2,:)
    
    kk_3 = Lines_in_GPS_Area_with_GridID(:,7) > 7289;
    
    GPS_ID_3 = Lines_in_GPS_Area_with_GridID(kk_3,:)
    
    kk_4 = Lines_in_GPS_Area_with_GridID(:,8) > 7289;
    
    GPS_ID_4 = Lines_in_GPS_Area_with_GridID(kk_4,:)
    
    % close
    fclose(fid_Lines_in_GPS_Area_with_GridID);
end


