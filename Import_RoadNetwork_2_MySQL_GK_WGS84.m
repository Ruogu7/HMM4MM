function Import_RoadNetwork_2_MySQL_GK_WGS84 ( RoadNetwork_filename )
    %%  function  Import_RoadNetwork_2_MySQL_GK_WGS84
    % Steps:
    % EXAMPLE: Import_RoadNetwork_2_MySQL_GK_WGS84 ( 'road_network.txt' )
    % example of insert sql:
    % insert into roadnetwork (Edge_ID,From_Node_ID,To_Node_ID,Two_way,speed,Vertex_Count, LINESTRING ) 
    % values (883993300443, 883993300415, 883993300024, 1, 5.833333333, 5,
    % 'LINESTRING((16494996.3933,6387254.7799,16495036.6563,6387407.3584))');

    %%
    t1 = clock;
    
    % connect with the database
    timeoutA = logintimeout(100);
    % Connect to a database.
    connA = database('hmm_microsoft_data','root','mysql','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/hmm_microsoft_data');
    % Check the database status.
    ping(connA);
    
    %% insert into table Signal Strength Map
    %'insert into signal_map(Cell_ID,LAC_ID,Time_interval,NColse,Nrow,XLLCORNER,YLLCORNER,Cellsize,SsMap) values(';
    sql_insert_main = 'insert into roadnetwork (Edge_ID,From_Node_ID,To_Node_ID,Two_way,speed,Vertex_Count, LINESTRING ) values ( ';
    
    i = 0;
    fid_TXT = fopen( RoadNetwork_filename,'r');
    while (~feof(fid_TXT)) %
        i = i + 1;
        tline = fgetl(fid_TXT);
        if (i > 1 ) % && (i < 100)
            
            % class(tline);
            road_link = regexp( tline, '\t', 'split');
            
            Name_insert = [road_link{1},', ' ,road_link{2},', ', road_link{3},', ' ,road_link{4},', ' ,road_link{5},', ' ,road_link{6},', '];
            
            % process the road link
            str_road_link_start = 'LINESTRING((';
            
            BL_sequence_str_ = strtok(strtok(road_link{7}, 'LINESTRING('), ')');
            BL_sequence_str = strrep(BL_sequence_str_, ',', ' ');
            
            % number of BL pair
            left_BL_sequence_str = BL_sequence_str;
            number_BL = str2num(road_link{6});
            str_road_link_center = '';
            for ii_number_BL = 1:number_BL
                P = zeros(1,3);
                [B_BL, num_point_str_back] = strtok(left_BL_sequence_str, ' ');
                
                P(2) = str2double(B_BL);
                left_BL_sequence_str = strtrim(num_point_str_back);
                [L_BL, num_point_str_back] = strtok(left_BL_sequence_str, ' ');
                P(1) = str2double(L_BL);
                left_BL_sequence_str = strtrim(num_point_str_back);
                
                XY_GK = ell2tm(P,'gk',[], 0);
                str_road_link_center = strcat(str_road_link_center, num2str(XY_GK(1)), ',', num2str(XY_GK(2)),',');
            end
            
            str_road_link_center_real = str_road_link_center(1:end-1);
            
            str_road_link = strcat(str_road_link_start, str_road_link_center_real, '))');
            
            SQL_insert = strcat(sql_insert_main, Name_insert, '''', str_road_link,'''', ');');
            Cursor_Insert = exec(connA,SQL_insert);
            
            if ~mod(i,1000)
                SQL_insert
                i
            end
        end
    end
    
    %% Close
    close(Cursor_Insert);
    close(connA);
    etime(clock,t1)
end


