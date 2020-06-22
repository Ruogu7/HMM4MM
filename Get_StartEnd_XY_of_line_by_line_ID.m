function [ StartEnd_XY_of_line ] = Get_StartEnd_XY_of_line_by_line_ID ( Line_ID )
    %% Get_StartEnd_XY_of_line_by_line_ID function description:
    % Imput: Line_ID
    % Output:
    % StartEnd_XY_of_line: Line ID, start_x, start_y, end_x, end_y
    % Example
    % [ StartEnd_XY_of_line ] = Get_StartEnd_XY_of_line_by_line_ID ( Line_ID )
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    StartEnd_XY_of_line = zeros(1,5);
    points_in_line = [];
    
    %% get the points
    timeoutA = logintimeout(100);
    % Connect to a database.
    connA = database('hmm_microsoft_data','root','mysql','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/hmm_microsoft_data');
    % Check the database status.
    ping(connA);
    
    sql_query_LinesByLineID_main = 'SELECT LINESTRING FROM hmm_microsoft_data.roadnetwork where ID = ';
    sql_query_LinesByLineID_LineID = num2str(Line_ID); % PID = 5823 as test
    sql_query_LinesByLineID = [sql_query_LinesByLineID_main, sql_query_LinesByLineID_LineID];
    
    cursor_LinesByLineID = exec(connA,sql_query_LinesByLineID);
    setdbprefs ('DataReturnFormat','cellarray');
    result_LinesByLineID = fetch(cursor_LinesByLineID);
    
    %% Display the data.
    Line_Set = result_LinesByLineID.Data;

    Line_geometry_field = Line_Set{1};    
    Coor_Pair_Line_geometry_field = strtok(strtok(Line_geometry_field, 'LINESTRING(('), '))');    
    Coor_Pair_Line_geometry = regexp( Coor_Pair_Line_geometry_field, ',', 'split');
    
    StartEnd_XY_of_line(1) = Line_ID;
    StartEnd_XY_of_line(2) = str2num(Coor_Pair_Line_geometry{1});
    StartEnd_XY_of_line(3) = str2num(Coor_Pair_Line_geometry{2});
    StartEnd_XY_of_line(4) = str2num(Coor_Pair_Line_geometry{end-1});
    StartEnd_XY_of_line(5) = str2num(Coor_Pair_Line_geometry{end});
    
    close(cursor_LinesByLineID);
    close(connA);
end
