function Lines_in_GPS_Area = Get_Lines_in_GPS_Area
    %%  function  Get_Lines_in_GPS_Area
    % Steps:
    % EXAMPLE: Lines_in_GPS_Area = Get_Lines_in_GPS_Area;
    % Quadtree_structure: Grid_side_length,Start_x, Start_y,Grid_x_num,Grid_y_num
    
    %% initialize
    load Line_MBR_matrix.txt;
    % LineID, min_x, min_y, Max_x, Max_y,length
    
    GPS_MBR_Vector = Get_GPS_MBR_Vector;
    % GPS_MBR_Vector: min_x, min_y, Max_x, Max_y
    
    % line_min_x < gps_max_x
    kk_1 = Line_MBR_matrix(:,2) < GPS_MBR_Vector(3);
    % line_min_y < gps_max_y
    kk_2 = Line_MBR_matrix(:,3) < GPS_MBR_Vector(4);
    % line_max_x > gps_min_x
    kk_3 = Line_MBR_matrix(:,4) > GPS_MBR_Vector(1);
    % line_max_y > gps_min_y
    kk_4 = Line_MBR_matrix(:,5) > GPS_MBR_Vector(2);
    
    kk = kk_1.*kk_2.*kk_3.*kk_4;
    sum(kk)
    
    Lines_in_GPS_Area = Line_MBR_matrix(kk==1,:);
    mean(Lines_in_GPS_Area(:,6));
    size(Lines_in_GPS_Area,1)
    
    % output the Lines_in_GPS_Area into a file:
    
    fid_Lines_in_GPS_Area = fopen('Lines_in_GPS_Area.txt', 'wt');
    for ii_line = 1:size(Lines_in_GPS_Area,1)
        fprintf(fid_Lines_in_GPS_Area, '%d\t', Lines_in_GPS_Area( ii_line,1 ));
        for i_record = 2:5
            fprintf(fid_Lines_in_GPS_Area, '%16.5f\t', Lines_in_GPS_Area( ii_line,i_record  ));
        end
        fprintf(fid_Lines_in_GPS_Area, '%16.8f\n', Lines_in_GPS_Area( ii_line,6 ));
        
        if ~mod(ii_line,1000)
            ii_line
        end
    end
    
    
end

