function QuadtreeStructure = Build_QuadtreeStructure_with_GPS_Lines_near_GPS
    %% Build_Line_MBR_matrix function description:
    % Imput: Line_ID
    % Output:
    % QuadtreeStructure: Grid_side_length, Start_x, Start_y, Grid_x_num, Grid_y_num
    % Example
    % QuadtreeStructure = Build_QuadtreeStructure_with_GPS_Lines_near_GPS
    % 200    16473400     6382400          37         197
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    load Lines_in_GPS_Area.txt;
    % LineID, min_x, min_y, Max_x, Max_y,length  
    
    GPS_MBR_Vector = Get_GPS_MBR_Vector;
    
    min_x = min(min(Lines_in_GPS_Area(:,2)), GPS_MBR_Vector(1));
    min_y = min(min(Lines_in_GPS_Area(:,3)), GPS_MBR_Vector(2));
    max_x = max(max(Lines_in_GPS_Area(:,4)), GPS_MBR_Vector(3));
    max_y = max(max(Lines_in_GPS_Area(:,5)), GPS_MBR_Vector(4));
    
    Start_x = 200*floor((min_x-50)/200);
    Start_y = 200*floor((min_y-50)/200);
    Grid_x_num = ceil((max_x+50-Start_x)/200);
    Grid_y_num = ceil((max_y+50-Start_y)/200);
    
    QuadtreeStructure = [200,Start_x, Start_y,Grid_x_num,Grid_y_num ];
    
end





