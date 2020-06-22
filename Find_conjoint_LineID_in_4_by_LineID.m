function conjoint_LineID_in_4 = Find_conjoint_LineID_in_4_by_LineID ( Line_ID )
%% Find_conjoint_Lines_in_5_by_Edge_ID_Set function description:
% Imput: Edge_ID_Set
% Output:
% Quadtree_structure: conjoint_Lines_in_5
% parameters:
%
% Example
% conjoint_LineID_in_2 = Find_conjoint_LineID_in_4_by_LineID ( 35261 )
% Revision Notes:
%       (10/04/14)
% by shenghua chen
% step 1: find the grid id set in which the line pass through
% step 2: get all the line in the these grid id.
% step 3: match among these line, and get the conjoint lines.

%% step 1: find the grid id set in which the line pass through
Conjoint_LinesID = Find_conjoint_Lines_by_LineID  ( Line_ID );
conjoint_LineID_in_4 = Conjoint_LinesID;
Line_4_Extend_1 = setdiff(Conjoint_LinesID,Line_ID);

Lines_extended_record = [];
for i_LinesID_4_Extend = 1:size(Line_4_Extend_1,2)
    Conjoint_LinesID_new = Find_conjoint_Lines_by_LineID  ( Line_4_Extend_1(i_LinesID_4_Extend) );
    Lines_extended_record = union(Conjoint_LinesID_new, Lines_extended_record );
end
Line_4_Extend_2 = setdiff(Lines_extended_record,conjoint_LineID_in_4);
conjoint_LineID_in_4 = union(conjoint_LineID_in_4, Lines_extended_record);


for i_LinesID_4_Extend = 1:size(Line_4_Extend_2,2)
    Conjoint_LinesID_new = Find_conjoint_Lines_by_LineID  ( Line_4_Extend_2(i_LinesID_4_Extend) );
    Lines_extended_record = union(Conjoint_LinesID_new, Lines_extended_record );
end
Line_4_Extend_3 = setdiff(Lines_extended_record,conjoint_LineID_in_4);
conjoint_LineID_in_4 = union(conjoint_LineID_in_4, Lines_extended_record);

for i_LinesID_4_Extend = 1:size(Line_4_Extend_3,2)
    Conjoint_LinesID_new = Find_conjoint_Lines_by_LineID  ( Line_4_Extend_3(i_LinesID_4_Extend) );
    Lines_extended_record = union(Conjoint_LinesID_new, Lines_extended_record );
end
Line_4_Extend_4 = setdiff(Lines_extended_record,conjoint_LineID_in_4);
conjoint_LineID_in_4 = union(conjoint_LineID_in_4, Lines_extended_record);

for i_LinesID_4_Extend = 1:size(Line_4_Extend_4,2)
    Conjoint_LinesID_new = Find_conjoint_Lines_by_LineID  ( Line_4_Extend_4(i_LinesID_4_Extend) );
    Lines_extended_record = union(Conjoint_LinesID_new, Lines_extended_record );
end
Line_4_Extend_5 = setdiff(Lines_extended_record,conjoint_LineID_in_4);
conjoint_LineID_in_4 = union(conjoint_LineID_in_4, Lines_extended_record);


%     %% visualizaiton
%     for i_line = 1:size(conjoint_LineID_in_4,2)
%         Visualization_road_link_by_line_ID ( conjoint_LineID_in_4(i_line),'-r' );
%     end
%     
%     Visualization_road_link_by_line_ID ( Line_ID,'g*' );

end


