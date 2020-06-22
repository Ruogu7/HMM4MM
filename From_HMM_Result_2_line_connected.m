function line_connected = From_HMM_Result_2_line_connected ( LineSet_4_network, HMM_Result )

%% example:
% LineSet_4_network = [];
% HMM_Result = [];
% line_connected = From_HMM_Result_2_line_connected ( LineSet_4_network, HMM_Result )

LineID_sequence = [];
LineID_sequence(1) = HMM_Result(1);
i_LineID_sequence = 1;
for i = 2:size(HMM_Result,2)
    if ~(HMM_Result(i) == LineID_sequence(end))
        i_LineID_sequence = i_LineID_sequence + 1;
        LineID_sequence(i_LineID_sequence) = HMM_Result(i);
    end
end
LineID_sequence
i_Complete_consequence = 0;
for i_line = 1:size(LineID_sequence,2)-1
    mark_connection = Isconnect_Line_line_by_ID ( LineID_sequence(i_line), LineID_sequence(i_line+1) )
    if ~mod(i_line, 10)
        i_line
    end
    
    if mark_connection
        i_Complete_consequence = i_Complete_consequence + 1;
        Complete_consequence(i_Complete_consequence) = LineID_sequence(i_line)
        continue;
    end
    if ~mark_connection
        i_line
        StartLine = LineID_sequence(i_line);
        EndLine = LineID_sequence(i_line+1);
        
        [Flag_conn_hmm, Line_4_Trajectory_final_HMM] = Connection_Startline2Endline( LineSet_4_network, StartLine, EndLine )
        size(Line_4_Trajectory_final_HMM,2)
        
        if Flag_conn_hmm > 0
            for i_Line_4_Trajectory_final_HMM = 1:size(Line_4_Trajectory_final_HMM,2)
                i_Complete_consequence = i_Complete_consequence + 1;
                Complete_consequence(i_Complete_consequence) = Line_4_Trajectory_final_HMM(i_Line_4_Trajectory_final_HMM)
            end
        end
    end
end
line_connected(1) = Complete_consequence(1);
i_line_connected = 1;
for i = 2:size(Complete_consequence,2)
    if ~(HMM_Result(i) == LineID_sequence(end))
        i_line_connected = i_line_connected + 1;
        line_connected(i_line_connected) = Complete_consequence(i);
    end
end
end
