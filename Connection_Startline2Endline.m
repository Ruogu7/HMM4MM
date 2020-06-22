function [Flag_conn_hmm, Line_4_Trajectory_final_HMM] = Connection_Startline2Endline( road_link_4_Network, StartLine, EndLine )
    %% Connection_Startline2Endline function description:
    % judge whether the start cell connects with the EndCells
    % Imput: ( CellID_Set, Startcell, Endcell )
    % Output: Traj_LineID_Set
    % step:
    % step 1: Build_Adjacency_Matrix_BY_CellID_Set by Cell_ID_Set
    % step 2: Get the FT point from Startcell, EndCell
    % step 3: Dijkstra_Mini to get the shortest path between Startcell, EndCell
    % step 4:
    % step 5: Analyse the lines in LineSet, to value the Adjacency Matrice
    % step 6: Analyses and visualization
    % Example:
    %     clc
    % [Flag_conn_hmm, Line_4_Trajectory_final_HMM] = Connection_Startline2Endline( road_link_4_Network, StartLine, EndLine )
    % Revision Notes:
    %       (09/04/13)
    % by shenghua chen
    
    %% initialize
    Flag_conn_hmm = 0;
    Line_4_Trajectory_final_HMM = [];
    
    [ Adjacency_Matrix, Point_Set, Line_Set ] = Build_Adjacency_Matrix_BY_LineID_Set( road_link_4_Network );
    Adjacency_Matrix_mark = (Adjacency_Matrix < 10000);
    
    %% StartLine
    StartEnd_XY_of_Start_line = Get_StartEnd_XY_of_line_by_line_ID ( StartLine )
    [flag_start, Ordinal_startPoint ] = find_Row_point (StartEnd_XY_of_Start_line(2), StartEnd_XY_of_Start_line(3), Point_Set);
    Ordinal_startPoint
    %% Endline
    StartEnd_XY_of_End_line = Get_StartEnd_XY_of_line_by_line_ID ( EndLine )
    [flag_end, Ordinal_endPoint ] = find_Row_point (StartEnd_XY_of_End_line(2), StartEnd_XY_of_End_line(3), Point_Set);
    Ordinal_endPoint
    
    %% 3. Dijkstra_Mini to get the shortest path between Startcell, EndCell
    [costs_distance, paths_distance] = Dijkstra_Mini(Adjacency_Matrix_mark, Adjacency_Matrix, Ordinal_startPoint, Ordinal_endPoint)
    
    if costs_distance/10000 < 10000
        Flag_conn_hmm = 1;

        for i_Traj_SL = 1:size(paths_distance,2)-1
            Traj_ShortestLength_Line_Set(i_Traj_SL) = find_Line_ID (Line_Set, Point_Set(paths_distance(i_Traj_SL),1),...
                Point_Set(paths_distance(i_Traj_SL),2),Point_Set(paths_distance(i_Traj_SL+1),1),...
                Point_Set(paths_distance(i_Traj_SL+1),2) );
        end
        
        Line_4_Trajectory_final_HMM = Traj_ShortestLength_Line_Set;
    end
end



%% function find_Line_ID
function Line_ID = find_Line_ID (Line_Set, vertex_1_x,vertex_1_y,vertex_2_x,vertex_2_y )
    % return Line_ID with which the line have the two vertex (vertex_1_x,vertex_1_y,vertex_2_x,vertex_2_y)
    % Known:
    % Line_Set (Line_ID in DB, length, vertex_1_x,vertex_1_y,vertex_2_x,vertex_2_y)
    % two vertex (vertex_1_x,vertex_1_y,vertex_2_x,vertex_2_y)
    Line_ID = 0;
    for i_Num_L = 1:size(Line_Set,1)
        a = (vertex_1_x-Line_Set(i_Num_L,3)).^2+(vertex_1_y-Line_Set(i_Num_L,4)).^2;
        b = (vertex_1_x-Line_Set(i_Num_L,5)).^2+(vertex_1_y-Line_Set(i_Num_L,6)).^2;
        c = (vertex_2_x-Line_Set(i_Num_L,3)).^2+(vertex_2_y-Line_Set(i_Num_L,4)).^2;
        d = (vertex_2_x-Line_Set(i_Num_L,5)).^2+(vertex_2_y-Line_Set(i_Num_L,6)).^2;
        
        %% judge
        if ((a + d < 1e-5) ||(b + c < 1e-5))
            Line_ID = Line_Set(i_Num_L,1);
        end
    end
end

%% function find_Row_point
function [flag_exist, Row_point] = find_Row_point (Point_X, Point_Y, Point_Set)
    % return Row_point of (Point_X, Point_Y) in Point_Set
    flag_exist = 0; % do not exist
    Num_Point = size(Point_Set,1);
    Row_point = 0;
    for ii_Num_Point = 1:Num_Point
        distance = 0;
        distance = sqrt((Point_Set(ii_Num_Point,1)-Point_X).^2+(Point_Set(ii_Num_Point,2)-Point_Y).^2);
        if distance <1e-8
            flag_exist = 1;
            Row_point = ii_Num_Point;
            break;
        end
    end
end

