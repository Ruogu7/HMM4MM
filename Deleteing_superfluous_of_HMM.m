%% Deleteing_superfluous_of_HMM

%% real data
% load Truth_route_EdgeID.txt;
% load Network_Topology.txt;
% unique_Truth_route_EdgeID = unique(Truth_route_EdgeID(:,1));
% mark_Edge_ID = ismember(Network_Topology(:,2),unique_Truth_route_EdgeID');
% LineID_of_GroundEdge = Network_Topology(mark_Edge_ID,1)';
% size(LineID_of_GroundEdge)
% for i_c = 1:size(LineID_of_GroundEdge,2)
%     if ~mod(i_c,100)
%         i_c
%     end
%     Visualization_road_link_by_line_ID(LineID_of_GroundEdge(i_c),'*g');
% end

%% easy lines
load LineID_set_HMM_raw_1_2200.txt;
LineID_set_HMM_raw_1_2200 = LineID_set_HMM_raw_1_2200(:,2:end);
LineID_set_HMM_raw_1_2200 = LineID_set_HMM_raw_1_2200';
LineID_set_HMM_raw_1_2200 = LineID_set_HMM_raw_1_2200(:);
Line_with_Sequence = LineID_set_HMM_raw_1_2200';

load LineID_set_HMM_raw_2201_2260.txt
Line_with_Sequence = [Line_with_Sequence, LineID_set_HMM_raw_2201_2260(2:end)];

load line_connected_2261_2290
Line_with_Sequence = [Line_with_Sequence, line_connected_2261_2290];

load LineID_set_HMM_raw_2291_2370.txt
LineID_set_HMM_raw_2291_2370 = LineID_set_HMM_raw_2291_2370(:,2:end);
LineID_set_HMM_raw_2291_2370 = LineID_set_HMM_raw_2291_2370';
LineID_set_HMM_raw_2291_2370 = LineID_set_HMM_raw_2291_2370(:)';
Line_with_Sequence =  [Line_with_Sequence, LineID_set_HMM_raw_2291_2370];

load line_connected_2371_2390
Line_with_Sequence =  [Line_with_Sequence, line_connected_2371_2390];

load LineID_set_HMM_raw_2391_2530.txt
LineID_set_HMM_raw_2391_2530 = LineID_set_HMM_raw_2391_2530(:,2:end);
LineID_set_HMM_raw_2391_2530 = LineID_set_HMM_raw_2391_2530';
LineID_set_HMM_raw_2391_2530 = LineID_set_HMM_raw_2391_2530(1:end-10)';
Line_with_Sequence =  [Line_with_Sequence, LineID_set_HMM_raw_2391_2530];

load line_connected_2521_2560
Line_with_Sequence =  [Line_with_Sequence, line_connected_2521_2560];

load LineID_set_HMM_raw_2551_5350.txt
LineID_set_HMM_raw_2551_5350 = LineID_set_HMM_raw_2551_5350(:,2:end);
LineID_set_HMM_raw_2551_5350 = LineID_set_HMM_raw_2551_5350';
LineID_set_HMM_raw_2551_5350 = LineID_set_HMM_raw_2551_5350(:);
LineID_set_HMM_raw_2551_5350 = LineID_set_HMM_raw_2551_5350(11:end)';
Line_with_Sequence =  [Line_with_Sequence, LineID_set_HMM_raw_2551_5350];

load line_connected_5341_5380
Line_with_Sequence =  [Line_with_Sequence, line_connected_5341_5380];

load LineID_set_HMM_raw_5371_5970.txt
LineID_set_HMM_raw_5371_5970 = LineID_set_HMM_raw_5371_5970(:,2:end);
LineID_set_HMM_raw_5371_5970 = LineID_set_HMM_raw_5371_5970';
LineID_set_HMM_raw_5371_5970 = LineID_set_HMM_raw_5371_5970(:);
LineID_set_HMM_raw_5371_5970 = LineID_set_HMM_raw_5371_5970(11:end)';
Line_with_Sequence =  [Line_with_Sequence, LineID_set_HMM_raw_5371_5970];

load LineID_set_HMM_raw_5971_6042.txt;
Line_with_Sequence =  [Line_with_Sequence, LineID_set_HMM_raw_5971_6042(2:end)];
size(Line_with_Sequence)

HMM_result(1) = Line_with_Sequence(1);
i_line = 1;
for i = 2:size(Line_with_Sequence,2)
    if ~(Line_with_Sequence(i) == HMM_result(end))
        i_line = i_line + 1;
        HMM_result(i_line) = Line_with_Sequence(i);
    end
end

size(HMM_result)
save HMM_result

load HMM_result
Start_End_line = [];
for i = 1:size(HMM_result,2)
    [ StartEnd_XY_of_line ] = Get_StartEnd_XY_of_line_by_line_ID ( HMM_result(i) );
    % StartEnd_XY_of_line: Line ID, start_x, start_y, end_x, end_y
    Start_End_line = [Start_End_line;StartEnd_XY_of_line];
end
size(Start_End_line)

Point_Set = [Start_End_line(:,2:3);Start_End_line(:,4:5)];
save Point_Set;

load Point_Set
size(Point_Set)
[ Point_Set_Unique_times ] = Unique_Point_Set_Num(Point_Set);
size(Point_Set_Unique_times)
save Point_Set_Unique_times

format long g
Point_Set_Unique_times(1:20,:)
sum(Point_Set_Unique_times(:,3))
size(Point_Set_Unique_times)

load HMM_result
size(HMM_result)
load Point_Set_Unique_times
HMM_result_filter = HMM_result(1);
i_HMM_result_filter = 1;
single_point = Point_Set_Unique_times(Point_Set_Unique_times(:,3) == 1,:);
size(single_point )

for i = 2:(size(HMM_result,2)-1)
    flag_contain_s = 1;
    flag_contain_e = 1;
    [ StartEnd_XY_of_line ] = Get_StartEnd_XY_of_line_by_line_ID ( HMM_result(i) );
    for i_Point = 1:size(single_point,1)
        distance_1 = sqrt(( StartEnd_XY_of_line(2)-single_point(i_Point,1))^2+...
            (StartEnd_XY_of_line(3)-single_point(i_Point,2))^2);
        if distance_1 <1e-3
            flag_contain_s = 0; % means contain
        end
    end
    for i_Point = 1:size(single_point,1)
        distance_2 = sqrt(( StartEnd_XY_of_line(4)-single_point(i_Point,1)).^2+...
            (StartEnd_XY_of_line(5)-single_point(i_Point,2))^2);
        if distance_2 <1e-3
            flag_contain_e = 0; % means contain
        end
    end
    
    if (flag_contain_e && flag_contain_s)
        i_HMM_result_filter = i_HMM_result_filter + 1;
        HMM_result_filter(i_HMM_result_filter) = HMM_result(i);
    end
end
i_HMM_result_filter = i_HMM_result_filter + 1;
HMM_result_filter(i_HMM_result_filter) = HMM_result(end);
i_HMM_result_filter

figure;
for i_line = 1:size(HMM_result_filter,2)
    Visualization_road_link_by_line_ID(HMM_result_filter(i_line),'-r');
    if ~ mod(i_line,50)
        i_line
    end
end

% load Truth_route_EdgeID.txt;
% load Network_Topology.txt;
% unique_Truth_route_EdgeID = unique(Truth_route_EdgeID(:,1));
% mark_Edge_ID = ismember(Network_Topology(:,2),unique_Truth_route_EdgeID');
% LineID_of_GroundEdge = Network_Topology(mark_Edge_ID,1)';
% size(LineID_of_GroundEdge)
% for i_c = 1:size(LineID_of_GroundEdge,2)
%     Visualization_road_link_by_line_ID(LineID_of_GroundEdge(i_c),'.b');
% end

% %% gps
% load GPS_Compress;
% plot(GPS_Compress(:,6),GPS_Compress(:,5),'g.');
% hold on;

%% legend
xlabel('(m)');
ylabel('(m)');
title('Result by HMM map-matching with map-aiding operation(2)');

load GPS_Compress;
gps_vis = [];
for i = 1:size(GPS_Compress,1)
    if ~mod(i,3)
        gps_vis = [gps_vis;GPS_Compress(i,:)];
    end
end
plot(gps_vis(:,6),gps_vis(:,5),'g.');


load Truth_route_EdgeID.txt;
load Network_Topology.txt;
unique_Truth_route_EdgeID = unique(Truth_route_EdgeID(:,1));
mark_Edge_ID = ismember(Network_Topology(:,2),unique_Truth_route_EdgeID');
LineID_of_GroundEdge = Network_Topology(mark_Edge_ID,1)';
size(LineID_of_GroundEdge)
for i_c = 1:size(LineID_of_GroundEdge,2)
    Visualization_road_link_by_line_ID(LineID_of_GroundEdge(i_c),'+b');
    
        if ~ mod(i_c,50)
        i_c
    end
end





