function [ GridID_LineID_near_GPS_Trajectory ] = Build_GridID_LineID_near_GPS_Trajectory
    %% Road_network_with_Quadtree_structure function description:
    % Imput:
    % Output:
    % GridID_LineID_near_GPS: Grid_ID, line num, line ID 12345....n
    %
    % Example
    % [ GridID_LineID_near_GPS_Trajectory ] = Build_GridID_LineID_near_GPS_Trajectory
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    %%
    load Line_in_GPS_Area_with_GridID.txt;
    % Line_in_GPS_Area_with_GridID: LineID, num of grid id, grid id 123.....n.
    load GPS_with_GridID_Set.txt;
    % GPS_with_GridID_Set: gps id, x,y, num, grid 1234.
    
    fid_GridID_LineID_near_GPS_Trajectory = fopen('GridID_LineID_near_GPS_Trajectory.txt', 'wt');
    
    %% Get the Grids which contains GPS point
    % from GPS_with_GridID_Set.txt
    GridID_Set_containing_GPS = GPS_with_GridID_Set(:,5:end);
    GridID_Set_containing_GPS = unique(GridID_Set_containing_GPS(:));
    
    % Grid ID from GPS Singal_Blockage
    load GridIDSet_at_GPS_Singal_Blockage_vector.txt;
    GridID_Set_not_containing_GPS = GridIDSet_at_GPS_Singal_Blockage_vector';
    
    GridID_Set_around_GPS = union(GridID_Set_containing_GPS,GridID_Set_not_containing_GPS);
    GridID_Set_around_GPS = GridID_Set_around_GPS(2:end);
    GridID_Set_around_GPS = GridID_Set_around_GPS';  % 587*1
    
    size(GridID_Set_around_GPS,1)
    
    %% Get the lines in grid
    GridID_LineID_near_GPS_Trajectory = zeros(size(GridID_Set_around_GPS,1),51);
    
    for i_grid = 1:size(GridID_Set_around_GPS,1)
        
        GridID_LineID_near_GPS_Trajectory(i_grid,1) = GridID_Set_around_GPS(i_grid);
        line_in_Grid = [];
        Num_line_in_Grid = 0;
        for ii_line = 1:size(Line_in_GPS_Area_with_GridID,1)
            if ismember( GridID_Set_around_GPS(i_grid), Line_in_GPS_Area_with_GridID(ii_line,3:end))
                Num_line_in_Grid = Num_line_in_Grid + 1;
                line_in_Grid(Num_line_in_Grid) = Line_in_GPS_Area_with_GridID(ii_line,1);
            end
        end
        GridID_LineID_near_GPS_Trajectory(i_grid,2) = size(line_in_Grid,2);
        GridID_LineID_near_GPS_Trajectory(i_grid,3:(size(line_in_Grid,2)+2)) = line_in_Grid;
        
        if ~mod(i_grid,50)
            i_grid
        end
        
        % input into the file
        for ii_file_line = 1:51
            fprintf(fid_GridID_LineID_near_GPS_Trajectory, '%d\t',GridID_LineID_near_GPS_Trajectory(i_grid,ii_file_line));
        end
        fprintf(fid_GridID_LineID_near_GPS_Trajectory, '\n');
        
    end
    max(GridID_LineID_near_GPS_Trajectory(:,2))
    
    % get all the lines
    lineID_Set = GridID_LineID_near_GPS_Trajectory(:,3:end);
    lineID_Set = lineID_Set(:);
    lineID_Set = unique(lineID_Set );
    lineID_Set = lineID_Set (2:end);
    
    size(lineID_Set)
    
    for i_line = 1:size(lineID_Set)
        Visualization_road_link_by_line_ID(lineID_Set(i_line));
        if ~mod(i_line,100)
            i_line
        end
    end
    
    % close
    fclose(fid_GridID_LineID_near_GPS_Trajectory);
    
end
