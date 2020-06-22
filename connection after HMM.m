load GPS_with_GridID_Set.txt;
load GridID_LineID_near_GPS_Trajectory.txt;
load GPS_with_GridID_Set.txt;
load GPS_Compress;
mark_GPS_ID_from_compress_GPS = ismember(GPS_with_GridID_Set(:,1),GPS_Compress(5341:5380,1)');
gridID_Set_by_GPS = GPS_with_GridID_Set(mark_GPS_ID_from_compress_GPS,5:8);
gridID_Set_by_GPS = gridID_Set_by_GPS(:)';
gridID_Set_by_GPS = unique(gridID_Set_by_GPS);
gridID_Set_by_GPS = gridID_Set_by_GPS(2:end);

[ interpolating_GPS,GridID_Set_for_interpolating_GPS ]  = Get_GridID_Set_for_interpolating_GPS( GPS_Compress(5341:5380,:));
GridID_local = union(GridID_Set_for_interpolating_GPS,gridID_Set_by_GPS);

gridID_Set_by_GPS_mark = ismember(GridID_LineID_near_GPS_Trajectory(:,1),GridID_local);

lineID_Set_IN_GridID_By_GPS = GridID_LineID_near_GPS_Trajectory(gridID_Set_by_GPS_mark,3:end);
lineID_Set_IN_GridID_By_GPS = lineID_Set_IN_GridID_By_GPS(:)';
lineID_Set_IN_GridID_By_GPS = unique(lineID_Set_IN_GridID_By_GPS );
lineID_Set_IN_GridID_By_GPS = lineID_Set_IN_GridID_By_GPS (2:end);
size(lineID_Set_IN_GridID_By_GPS,2)

load LineID_set_HMM_raw_5341_5380;
[Flag_conn_hmm, Line_4_Trajectory_final_HMM] = Connection_Startline2Endline( lineID_Set_IN_GridID_By_GPS, LineID_set_HMM_raw_5341_5380(1), LineID_set_HMM_raw_5341_5380(end) )
size(Line_4_Trajectory_final_HMM,2)
Complete_consequence(1) = LineID_set_HMM(1);
i_Complete_consequence = 1;
if Flag_conn_hmm > 0
    for i_Line_4_Trajectory_final_HMM = 1:size(Line_4_Trajectory_final_HMM,2)
        i_Complete_consequence = i_Complete_consequence + 1;
        Complete_consequence(i_Complete_consequence) = Line_4_Trajectory_final_HMM(i_Line_4_Trajectory_final_HMM)
    end
end
i_Complete_consequence = i_Complete_consequence + 1;
Complete_consequence(i_Complete_consequence) = LineID_set_HMM(end);
Complete_consequence

line_connected_5341_5380(1) = Complete_consequence(1);
i_line_connected = 1;
for i = 2:size(Complete_consequence,2)
    if ~(Complete_consequence(i) == line_connected_5341_5380(end))
        i_line_connected = i_line_connected + 1;
        line_connected_5341_5380(i_line_connected) = Complete_consequence(i);
    end
end
save line_connected_5341_5380;
for i_line = 1:size(line_connected_2521_2560)
    Visualization_road_link_by_line_ID(line_connected_5341_5380(i_line),'-y');
end