function Line_MBR_matrix = Build_Line_MBR_matrix
    %% Build_Line_MBR_matrix function description:
    % Imput: Line_ID
    % Output:
    % Line_MBR_matrix: LineID, min_x, min_y, Max_x, Max_y,length
    %
    % Example
    % Line_MBR_matrix = Build_Line_MBR_matrix
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    
    %% get the points
    timeoutA = logintimeout(100);
    % Connect to a database.
    connA = database('hmm_microsoft_data','root','mysql','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/hmm_microsoft_data');
    % Check the database status.
    ping(connA);
    
    sql_query_LinesByLineID_main = 'SELECT ID,Vertex_Count, LINESTRING FROM hmm_microsoft_data.roadnetwork';
    cursor_Lines = exec(connA,sql_query_LinesByLineID_main);
    setdbprefs ('DataReturnFormat','cellarray');
    result_Lines = fetch(cursor_Lines);
    
    %% Display the data.
    Line_Set = result_Lines.Data;
    Line_num = size(Line_Set,1);
    
    %% initialize
    Line_MBR_matrix = zeros(Line_num,6);
    fid_Line_MBR_matrix = fopen('Line_MBR_matrix.txt', 'wt');
    
    for i_line = 1:Line_num
        Line_MBR = [];
        Vertex_num = Line_Set{i_line,2};
        points_in_line = zeros(Vertex_num,2);
        Line_geometry_field = Line_Set{i_line,3};
        Coor_Pair_Line_geometry_field = strtok(strtok(Line_geometry_field, 'LINESTRING(('), '))');
        Coor_Pair_Line_geometry = regexp( Coor_Pair_Line_geometry_field, ',', 'split');
        
        for i_Vertex_num = 1:Vertex_num
            points_in_line(i_Vertex_num,1) = str2num(Coor_Pair_Line_geometry{i_Vertex_num*2-1});
            points_in_line(i_Vertex_num,2) = str2num(Coor_Pair_Line_geometry{i_Vertex_num*2});
        end
        
        Line_MBR(1) = Line_Set{i_line,1};
        Line_MBR(2) = min(points_in_line(:, 1));
        Line_MBR(3) = min(points_in_line(:, 2));
        Line_MBR(4) = max(points_in_line(:, 1));
        Line_MBR(5) = max(points_in_line(:, 2));
        Line_MBR(6) = Get_distance_for_linePointInMatrix(points_in_line);
        
        fprintf(fid_Line_MBR_matrix, '%d\t%16.4f\t%16.4f\t%16.4f\t%16.4f\t%16.8f\n', Line_MBR(1), Line_MBR(2), ...
            Line_MBR(3),Line_MBR(4),Line_MBR(5),Line_MBR(6));
        
        Line_MBR_matrix (i_line,:) = Line_MBR;
        if ~mod(i_line,1000)
            i_line
        end
    end
    mean(Line_MBR_matrix(:,6))
    
    
    close(cursor_Lines);
    close(connA);
end


