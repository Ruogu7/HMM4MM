function [ Line_2_GPS_point ] = GetLine_near_GPS_By_Grid( GPS_ID )
    %% GetLine_near_GPS_By_Grid function description:
    % Imput: GPS_ID
    % Output:
    % Line_near_GPS: Line ID Set
    % parameters:
    %
    % Example
    % [ Line_near_GPS ] = GetLine_near_GPS_By_Grid( 2 )
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    load GPS_with_GridID_Set.txt;
    load GridID_LineID_near_GPS_Trajectory.txt;
    
    mark_gps = ismember(GPS_with_GridID_Set(:,1),GPS_ID);
    % sum(mark_gps )
    GPS_with_GridID_Set_record = GPS_with_GridID_Set(mark_gps,:);
    GridID_Set = GPS_with_GridID_Set_record(5:(4+GPS_with_GridID_Set_record(4)));
    
    mark_Grid = ismember(GridID_LineID_near_GPS_Trajectory(:,1),GridID_Set);
    GridID_LineID_near_GPS_Trajectory_records = GridID_LineID_near_GPS_Trajectory(mark_Grid,:);
    Line_near_GPS = [];
    for i_grid = 1:size(GridID_LineID_near_GPS_Trajectory_records,1)
        num_line = GridID_LineID_near_GPS_Trajectory_records(i_grid,2);
        line_in_Grid = GridID_LineID_near_GPS_Trajectory_records(i_grid,3:(2+num_line));
        Line_near_GPS = union(Line_near_GPS, line_in_Grid);
    end
    
    GPS_XY = GPS_with_GridID_Set_record(2:3);
    
    for i_line = 1:size(Line_near_GPS,2)
        Line_2_GPS_point(i_line,1) = Line_near_GPS(i_line);
        distance = Distance_point_2_Multiline(GPS_XY,Line_near_GPS(i_line));
        Line_2_GPS_point(i_line,2) = 1/(distance*distance);
    end
    
%     %% visualizaiton
%     for i_line = 1:size(Line_near_GPS,2)
%         Visualization_road_link_by_line_ID ( Line_near_GPS(i_line) );
%     end
%     
%     % visualization
%     load GPS_data_bl_xy.txt;
%     % gps id, time, b, l, x, y
%     plot(GPS_XY( 2),GPS_XY(1), '*r')
    
end


