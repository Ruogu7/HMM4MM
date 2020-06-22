% Generate_State_Transition_Probability

load  GridID_LineID_near_GPS_Trajectory.txt;
% get all the lines
lineID_Set = GridID_LineID_near_GPS_Trajectory(:,3:end);
lineID_Set = lineID_Set(:);
lineID_Set = unique(lineID_Set );
lineID_Set = lineID_Set (2:end)';
size(lineID_Set );

%% step 3: Build the State Transition Probability
% State Transition Probability
% 4016 * 4016
% size(lineID_Set,2)
State_Transition_Probability = ones(size(lineID_Set,2))*0.00000001;
for i_line = 1:size(lineID_Set,2)
    if ~mod(i_line, 50)
        i_line
    end
    i_line_Mark = i_line
    % LineID_Mark = lineID_Set(i_line)
    
    conjoint_LineID = Find_conjoint_Lines_by_LineID( lineID_Set(i_line) );
    for ii_Line_State_Transition = 1:size(conjoint_LineID,2)
        Line_connected_twice = find ( lineID_Set == conjoint_LineID(ii_Line_State_Transition) );
        State_Transition_Probability(i_line, Line_connected_twice) = 0.45;
    end
    State_Transition_Probability(i_line, i_line) = 0.6;
end
% Normalization
% [ State_Transition_Probability_normalization ] = Normalization( State_Transition_Probability );
save State_Transition_Probability;

