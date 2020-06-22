% Generate_Probability_initial

%% step 6: Initialize the state
load GPS_with_GridID_Set.txt;
GridID_num_First_GPS = GPS_with_GridID_Set(1,4);
GridIDSet_First_GPS = GPS_with_GridID_Set(1,5:(GridID_num_First_GPS+4));

line_initial_state = [];
for i_grid = 1:size(GridIDSet_First_GPS,2)
    kk_grid = ismember( GridID_LineID_near_GPS_Trajectory(:,1), GridIDSet_First_GPS(i_grid));
    Line_from_grid = GridID_LineID_near_GPS_Trajectory(kk_grid,3:end);
    Line_from_grid = Line_from_grid(:);
    Line_from_grid = Line_from_grid';
    line_initial_state = union(line_initial_state,Line_from_grid);
end
line_initial_state = unique(line_initial_state);
line_initial_state = line_initial_state(2:end)
num_initial_State = size(line_initial_state,2);

Probability_initial = zeros(1,size(lineID_Set,2));
kk_initial_state = ismember(lineID_Set, line_initial_state);

Probability_initial = kk_initial_state ./num_initial_State;
% size(Probability_initial )
% sum(Probability_initial )
save Probability_initial;


