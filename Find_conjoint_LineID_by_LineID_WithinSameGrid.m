function Conjoint_LinesID = Find_conjoint_LineID_by_LineID_WithinSameGrid ( LineID )
    %% Find_conjoint_Lines_in_5_by_Edge_ID_Set function description:
    % Imput: Edge_ID_Set
    % Output:
    % Quadtree_structure: conjoint_Lines_in_5
    % parameters:
    %
    % Example
    % Edge_ID_Set
    % Conjoint_LinesID = Find_conjoint_LineID_by_LineID_WithinSameGrid ( 5586 )
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    % step 1: find the grid id set in which the line pass through 
    % step 2: get all the line in the these grid id.
    % step 3: match among these line, and get the conjoint lines. 
    
    %% step 1: find the grid id set in which the line pass through 
    load Line_in_GPS_Area_with_GridID.txt;
    GridID_num = Line_in_GPS_Area_with_GridID(LineID,2);
    GridIDSet_of_line = Line_in_GPS_Area_with_GridID(LineID,3:(GridID_num+2));
    
    
    %% step 2: get all the line in the these grid id.
    load GridID_LineID_near_GPS.txt;
    Line_in_grid_Set = []
    for i_grid = 1:GridID_num
        % grid
        GridIDSet_of_line(i_grid)
        mark_gridID = ismember(GridID_LineID_near_GPS(:,1),GridIDSet_of_line(i_grid));
        GridID_lineID_record = GridID_LineID_near_GPS(mark_gridID,:)
        LineNum = GridID_lineID_record(2);
        LineID_Set_inGrid_record = GridID_lineID_record(3:(2+LineNum));
        Line_in_grid_Set = union(Line_in_grid_Set, LineID_Set_inGrid_record);
    end
    
    %% step 3: match among these line, and get the conjoint lines.
    Conjoint_LinesID = [];
    num_conjoint = 0;
    % object line
    
    for i_line = 1:size(Line_in_grid_Set,2)
        % Object_line: Line ID, start_x, start_y, end_x, end_y
        mark_connection = IsConnected (Line_in_grid_Set(i_line), Object_line );
        if mark_connection == 1
            num_conjoint = num_conjoint + 1;
            Conjoint_LinesID(num_conjoint) = Line_in_grid_Set(i_line);
        end
    end
    
    
    %% visualizaiton
    for i_line = 1:size(Conjoint_LinesID,2)
        Visualization_Read_road_link_by_line_ID ( Conjoint_LinesID(i_line) );
    end
    
end

% 5586	884010201289.0	884010200284.0	884010200631.0

