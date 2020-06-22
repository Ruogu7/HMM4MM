% Generate_states_space

%% 1: Get all the grid ID by GPS data
    load  GridID_LineID_near_GPS_Trajectory.txt;
    % get all the lines
    lineID_Set = GridID_LineID_near_GPS_Trajectory(:,3:end);
    lineID_Set = lineID_Set(:);
    lineID_Set = unique(lineID_Set );
    lineID_Set = lineID_Set (2:end)';
    size(lineID_Set )
    %     % visualization
    %     for i_line = 1:size(lineID_Set)
    %         Visualization_road_link_by_line_ID(lineID_Set(i_line));
    %         if ~mod(i_line,100)
    %             i_line
    %         end
    %     end
    
    % store the state space in cell structure.
    states_space = cell(size(lineID_Set));
    for  i_line = 1:size(lineID_Set,2)
        states_space{i_line} = num2str(lineID_Set(i_line));
    end
    class(states_space)
    states_space(1:20)
    save states_space;
