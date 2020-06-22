function distance = Get_distance_for_linePointInMatrix(line_PointMatrix)
    
    %% rename: Line_PointMatrix
    
    distance = 0;
    for i_point= 1:size(line_PointMatrix,1)-1
        distance_interval = sqrt((line_PointMatrix(i_point,1) - line_PointMatrix(i_point+1,1)).^2 ...
            + (line_PointMatrix(i_point,2) - line_PointMatrix(i_point+1,2)).^2);
        distance = distance + distance_interval;
    end
    
end
