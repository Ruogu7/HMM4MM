function Generate_Emission_Probability
    %% Emission probability: Observation Probability distribution in each of the state
    % 4016*7539
    load  GridID_LineID_near_GPS_Trajectory.txt;
    % get all the lines
    lineID_Set = GridID_LineID_near_GPS_Trajectory(:,3:end);
    lineID_Set = lineID_Set(:);
    lineID_Set = unique(lineID_Set );
    lineID_Set = lineID_Set (2:end)';
    size(lineID_Set );
    
    load GPS_data_bl_xy.txt;    
    Emission_Probability = zeros(size(lineID_Set,2), size(GPS_data_bl_xy,1));
    size(Emission_Probability)
    for i_point = 1:size(GPS_data_bl_xy,1)
        if ~mod(i_point, 100)
            i_point
        end
        
        % get all lines near the gps point
        Line_with_distance_2_GPS_point = [];
        [ Line_with_distance_2_GPS_point ] = GetLine_near_GPS_By_Grid( i_point );
        
        for i_Line = 1:size(Line_with_distance_2_GPS_point,1 )
            line_order_in_lineID_Set = find( lineID_Set == Line_with_distance_2_GPS_point(i_Line,1));
            Emission_Probability(line_order_in_lineID_Set, i_point) = Line_with_distance_2_GPS_point(i_Line,2)/sum(Line_with_distance_2_GPS_point(:,2));
        end
    end
    Emission_Probability(1:2,:)
    fprintf('The area is a mark 1\n');
    save Emission_Probability;
    

end

