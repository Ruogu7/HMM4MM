function [ distanceP2Multiline ] = Distance_point_2_Multiline ( GPS_XY, Line_ID )
    %% Distance_point_2_Multiline function description:
    % Imput: (p_object, LineID)
    % Example:
    %
    %      GPS_XY = [16480282.149              6418737.3938]
    %    Line_ID =  [87879       87880       87890       87891       88271]
    %    [ distanceP2Multiline ] = Distance_point_2_Multiline ( GPS_XY, Line_ID )
    % Revision Notes:
    %       (16/04/13)
    % by shenghua chen
    
    
    %% initialize
    distanceP2Multiline = 0;
    
    %% get the points
    timeoutA = logintimeout(100);
    % Connect to a database.
    connA = database('hmm_microsoft_data','root','mysql','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/hmm_microsoft_data');
    % Check the database status.
    ping(connA);
    
    sql_query_LinesByLineID_main = 'SELECT Vertex_Count, LINESTRING FROM hmm_microsoft_data.roadnetwork where ID = ';
    sql_query_LinesByLineID_LineID = num2str(Line_ID); % PID = 5823 as test
    sql_query_LinesByLineID = [sql_query_LinesByLineID_main, sql_query_LinesByLineID_LineID];
    
    cursor_LinesByLineID = exec(connA,sql_query_LinesByLineID);
    setdbprefs ('DataReturnFormat','cellarray');
    result_LinesByLineID = fetch(cursor_LinesByLineID);
    
    %% Display the data.
    Line_Set = result_LinesByLineID.Data;
    Vertex_num = Line_Set{1};
    
    points_in_line = zeros(Vertex_num+1,2);
    points_in_line(1,1) = Line_ID;
    points_in_line(1,2) = Vertex_num;
    
    Line_geometry_field = Line_Set{2};
    Coor_Pair_Line_geometry_field = strtok(strtok(Line_geometry_field, 'LINESTRING(('), '))');
    Coor_Pair_Line_geometry = regexp( Coor_Pair_Line_geometry_field, ',', 'split');
    
    for i_Vertex_num = 1:Vertex_num
        points_in_line(i_Vertex_num+1,1) = str2num(Coor_Pair_Line_geometry{i_Vertex_num*2-1});
        points_in_line(i_Vertex_num+1,2) = str2num(Coor_Pair_Line_geometry{i_Vertex_num*2});
    end
    
    if Vertex_num == 2
        [distance_Point2singleline, X_Projected_P, Y_Projected_P] = point_projected2singleline(GPS_XY, points_in_line(2,:),points_in_line(3,:));
        distanceP2Multiline = distance_Point2singleline;
    end
    
    if Vertex_num > 2
        projection_result = [];
        for i_count_p = 2:Vertex_num
            [distance_Point2singleline, X_Projected_P, Y_Projected_P] = point_projected2singleline(GPS_XY, points_in_line(i_count_p,:),points_in_line(i_count_p+1,:));
            projection_result(i_count_p-1,1) = distance_Point2singleline;
        end
        distanceP2Multiline = min(projection_result(:,1));
    end
    
    %% Visualization
    close(cursor_LinesByLineID);
    close(connA);
end






%%% test 
% GPS_XY = [16480282.149              6418737.3938]
% Line_ID =  [87879       87880       87890       87891       88271]
% for i = 1:size(Line_ID ,2)
%     
%     [ distanceP2Multiline ] = Distance_point_2_Multiline ( GPS_XY, Line_ID(i) )
% end
