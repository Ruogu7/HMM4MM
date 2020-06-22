function  GPS_Compress = Compress_GPS
%% Compress_GPS
% compress the gps point by deleting the superfluous point pair
%%
load GPS_data_bl_xy.txt;
plot(GPS_data_bl_xy(:,6),GPS_data_bl_xy(:,5),'.g');
hold on;

%% initialize
GPS_Compress = GPS_data_bl_xy(1,:)
i_GPS_Compress = 1;
for i_GPS = 2:size(GPS_data_bl_xy,1)
    distance = sqrt ( (GPS_data_bl_xy(i_GPS,5) - GPS_Compress(end, 5)).^2  + (GPS_data_bl_xy(i_GPS,6) - GPS_Compress(end, 6)).^2 );
    if distance > 0.0001
        i_GPS_Compress = i_GPS_Compress + 1;
        GPS_Compress = [GPS_Compress;GPS_data_bl_xy(i_GPS,:)];
    end
end
size(GPS_Compress)
save GPS_Compress;

%% visualization of gps point
for i_gps = 1:size(GPS_Compress,1)-1
    distance (i_gps ) = sqrt((GPS_Compress(i_gps,5) - GPS_Compress(i_gps+1,5)).^2 ...
        + (GPS_Compress(i_gps,6) - GPS_Compress(i_gps+1,6)).^2);
    if distance (i_gps ) > 100
        %% interpolating for more gps.
        distance (i_gps )
        i_gps
        plot(GPS_Compress(i_gps,6),GPS_Compress(i_gps,5),'r*');
        hold on;
    end
end

%% visualization of road network
load Truth_route_EdgeID.txt;
load Network_Topology.txt;
unique_Truth_route_EdgeID = unique(Truth_route_EdgeID(:,1));
mark_Edge_ID = ismember(Network_Topology(:,2),unique_Truth_route_EdgeID');
LineID_of_GroundEdge = Network_Topology(mark_Edge_ID,1)';
size(LineID_of_GroundEdge)
% for i_c = 1:size(LineID_of_GroundEdge,2)
%     Visualization_road_link_by_line_ID(LineID_of_GroundEdge(i_c),'.b');
%     if ~mod(i_c,50)
%         i_c
%     end
% end

%% legend
xlabel('(m)');
ylabel('(m)');
title('Result of the Hidden Markov Model - based map matching method and the GPS trajectory');

end




