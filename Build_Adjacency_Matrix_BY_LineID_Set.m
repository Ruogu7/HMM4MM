function [ Adjacency_Matrix, Point_Set, Line_Set ] = Build_Adjacency_Matrix_BY_LineID_Set( LineID_Set )
%% Build_Adjacency_Matrix_BY_LineID_Set function description:
% Build the Adjacency Matrix BY CellID_Set
% Imput: LineID_Set
% Output:
%       Adjacency_Matrix:
%       Point_Set: Point ine the adjacency matrix;
%       Line_Set: connection between points
%
% step:
% step 1: Get PointSet related to the cells in Cell_ID_Set
% step 2: Get LineSet related to the cells in Cell_ID_Set
% step 3: Get PointSet which locates in the ends of line in LineSet
% step 4: Combine the PointSet, and build the matrix for the Adjacency Matrice
% step 5: Analyse the lines in LineSet, to value the Adjacency Matrice
% step 6: analyses and visualization
% Example:
% [ Adjacency_Matrix, Point_Set, Line_Set ] = Build_Adjacency_Matrix_BY_CellID_Set( CellID_Set )
% Revision Notes:
%       (09/04/13)
% by shenghua chen

%% 1&2. Get LineSet, PointSet_1 related to the cells in Cell_ID_Set.  (Line ID, Line_length, Node_1_X, Node_1_Y,Node_2_X,Node_2_Y)


Line_Set = zeros(size(LineID_Set,2),6);
for i_Line4n = 1:size(LineID_Set,2)
    start_end_length_record = Read_road_link_by_line_ID (LineID_Set(i_Line4n));
    % start_end_length_record: Line ID, length, start_x, start_y, end_x, end_y;
    Line_Set(i_Line4n,:) = start_end_length_record;
end

%% 4. Get PointSet from Line4Network
NodePoint_Set = [Line_Set(:,3:4); Line_Set(:,5:6) ];
[ Point_Set ] = Unique_Point_Set(NodePoint_Set);
% size(Point_Set)

%% 5. build the matrix for the Adjacency Matrice
% build the Adjacency Matrice
Num_P_Adja_ma = size(Point_Set,1)   % num of the point for the Adjacency Matrice   1153
Adjacency_Matrix = ones(Num_P_Adja_ma)*10000;

%% 6. Analyse the lines in LineSet_2, to value the Adjacency Matrice
% LineByCells_Set: (Line_ID in DB, length, vertex_1_x,vertex_1_y,vertex_2_x,vertex_2_y)
for ii_LineSet = 1:size(Line_Set,1)
    if ~mod(ii_LineSet,10)
        ii_LineSet
    end
    [flag_point_1, Point_Row_1] = find_Row_point (Line_Set(ii_LineSet,3), Line_Set(ii_LineSet,4), Point_Set);
    [flag_point_2, Point_Row_2] = find_Row_point (Line_Set(ii_LineSet,5), Line_Set(ii_LineSet,6), Point_Set);
    
    Adjacency_Matrix(Point_Row_1, Point_Row_2) = Line_Set(ii_LineSet,2);
    Adjacency_Matrix(Point_Row_2, Point_Row_1) = Line_Set(ii_LineSet,2);
end

Adja_Matr_Mark = (Adjacency_Matrix<10000);

%% 6. Result & visualization: the most possible path [Routing_matrix: Start_X, Start_Y, End_X, End_Y,
%     Visualization_Cell_ID_Set( CellID_Set );   % black background
%
%     title('Trajectory by the A data in GSM and GPS trajectory');
%     % title('GPS trajectory and traffic road network in test area');
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

