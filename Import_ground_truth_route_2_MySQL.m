function Import_ground_truth_route_2_MySQL ( truth_route_filename )
    %%  function  Import_ground_truth_route_2_MySQL
    % Steps:
    % EXAMPLE: Import_ground_truth_route_2_MySQL ( 'ground_truth_route.txt' )
    % example of insert sql:
    % 

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
    sql_insert_main = 'insert into truth_route ( Edge_ID, From_to_To ) values ( ';
    
    i = 0;
    fid_TXT = fopen( truth_route_filename,'r');
    while (~feof(fid_TXT)) %
        i = i + 1;
        tline = fgetl(fid_TXT);
        if (i > 1 ) % && (i < 10)
            
            % class(tline);
            groudn_true_edge = regexp( tline, '\t', 'split');
            
            Name_insert = [groudn_true_edge{1},', ' ,groudn_true_edge{2}];
            SQL_insert = strcat(sql_insert_main, Name_insert, ');');
            Cursor_Insert = exec(connA,SQL_insert);
            
            if ~mod(i,200)
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


