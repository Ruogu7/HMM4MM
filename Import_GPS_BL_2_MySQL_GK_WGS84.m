function Import_GPS_BL_2_MySQL_GK_WGS84 ( GPS_BL_filename )
    %%  function  Import_GPS_BL_2_MySQL_GK_WGS84
    % Steps:
    % EXAMPLE: Import_GPS_BL_2_MySQL_GK_WGS84 ( 'gps_data.txt' )
    
    
    
    % connect with the database
    timeoutA = logintimeout(100);
    % Connect to a database.
    connA = database('hmm_microsoft_data','root','mysql','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/hmm_microsoft_data');
    % Check the database status.
    ping(connA);
    
    %% insert into table Signal Strength Map
    %'insert into signal_map(Cell_ID,LAC_ID,Time_interval,NColse,Nrow,XLLCORNER,YLLCORNER,Cellsize,SsMap) values(';
    sql_insert_main = 'insert into gps_bl_xy (time, Latitude, Longitude, x, y ) values ( ';
    
    i = 0;
    fid_TXT = fopen( GPS_BL_filename,'r');
    
    while (~feof(fid_TXT)) %
        i = i + 1;
        tline = fgetl(fid_TXT);
        if (i > 1 ) % && (i < 10)
            
            % class(tline);
            GPS_record = regexp( tline, '\t', 'split');
            
            hhmmss = regexp( GPS_record{2}, ':', 'split');
            hhmmss_str = [hhmmss{1}, hhmmss{2}, hhmmss{3}];
            
            Name_insert = ['''',hhmmss_str,'''', ', ' , GPS_record{3},', ', GPS_record{4}, ', '  ];
            
            %% gauss kruger map projection
            BL = [str2num(GPS_record{3}), str2num(GPS_record{4}), 0];
            
            P6 = ell2tm(BL,'gk',[], 0);
            
            Name_insert = [Name_insert, num2str(P6(1)), ', ',num2str(P6(2))];
            
            SQL_insert = [sql_insert_main, Name_insert, ');'];
            Cursor_Insert = exec(connA,SQL_insert);
            
            
            if ~mod(i,300)
                SQL_insert
                i
            end
            
            
            %% output to textfile abou the GPS data
            
            
            
            
        end
    end
    
    %% Close
    close(Cursor_Insert);
    close(connA);
end


