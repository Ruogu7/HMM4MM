function Conjoint_Lines = Find_conjoint_Lines_by_LineID ( Line_ID )
    %% Find_conjoint_Lines_in_5_by_Edge_ID_Set function description:
    % Imput: Edge_ID_Set
    % Output:
    % Quadtree_structure: conjoint_Lines_in_5
    % parameters:
    %
    % Example
    % Conjoint_Lines = Find_conjoint_Lines_by_LineID  ( 35261 )
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    % step 1: find the grid id set in which the line pass through
    % step 2: get all the line in the these grid id.
    % step 3: match among these line, and get the conjoint lines.
    
    % initial time recording
    % t0 = cputime;

    %% step 1: find the grid id set in which the line pass through
    load Lines_in_GPS_Area_with_GridID.txt;
    kk = ismember(Lines_in_GPS_Area_with_GridID(:,1),Line_ID);
    TheRecord = Lines_in_GPS_Area_with_GridID(kk, :);
    GridID_num = TheRecord(2);
    GridIDSet_of_line = TheRecord(3:(GridID_num+2));
    
    
    %% step 2: get all the line in the these grid id.
    load GridID_LineID_near_GPS_Trajectory.txt;
    Line_in_grid_Set = [];
    for i_grid = 1:GridID_num
        % grid
        GridIDSet_of_line(i_grid);
        mark_gridID = ismember(GridID_LineID_near_GPS_Trajectory(:,1),GridIDSet_of_line(i_grid));
        GridID_lineID_record = GridID_LineID_near_GPS_Trajectory(mark_gridID,:);
        
        % some grid do not contain lines
        if size(GridID_lineID_record,1) == 0
            LineID_Set_inGrid_record = [];
        end
        
        % grid do contain lines
        if size(GridID_lineID_record,1) > 0
            LineNum = GridID_lineID_record(2);
            LineID_Set_inGrid_record = GridID_lineID_record(3:(2+LineNum));
        end
        Line_in_grid_Set = union(Line_in_grid_Set, LineID_Set_inGrid_record);
    end
    Lines_inSameGrid = Line_in_grid_Set;
    
    
    %% step 3: match among these line, and get the conjoint lines.
    Conjoint_Lines = [];
    num_conjoint = 0;
    
    % object line
    Object_line = Get_StartEnd_XY_of_line_by_line_ID ( Line_ID );
    % StartEnd_XY_of_line: Line ID, start_x, start_y, end_x, end_y
    
    for i_line = 1:size(Lines_inSameGrid,2)
        % Object_line: Line ID, start_x, start_y, end_x, end_y
        mark_connection = IsConnected (Lines_inSameGrid(i_line), Object_line );
        if mark_connection == 1
            num_conjoint = num_conjoint + 1;
            Conjoint_Lines(num_conjoint) = Lines_inSameGrid(i_line);
        end
    end
    
%     %% visualizaiton
%     for i_line = 1:size(Conjoint_Lines,2)
%         Visualization_road_link_by_line_ID ( Conjoint_Lines(i_line) );
%     end
    
    % time recording
    % t_record = cputime - t0
    
end

