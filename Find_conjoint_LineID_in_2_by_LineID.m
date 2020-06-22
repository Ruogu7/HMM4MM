function conjoint_LineID_in_2 = Find_conjoint_LineID_in_2_by_LineID ( Line_ID )
    %% Find_conjoint_Lines_in_5_by_Edge_ID_Set function description:
    % Imput: Edge_ID_Set
    % Output:
    % Quadtree_structure: conjoint_Lines_in_5
    % parameters:
    %
    % Example
    % conjoint_LineID_in_2 = Find_conjoint_LineID_in_2_by_LineID ( 35261 )
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    % step 1: find the grid id set in which the line pass through
    % step 2: get all the line in the these grid id.
    % step 3: match among these line, and get the conjoint lines.
    
    %% step 1: find the grid id set in which the line pass through
    Conjoint_LinesID = Find_conjoint_Lines_by_LineID  ( Line_ID );
    conjoint_LineID_in_2 = Conjoint_LinesID;
    Line_4_Extend = setdiff(Conjoint_LinesID,Line_ID);
    for i_LinesID_4_Extend = 1:size(Line_4_Extend,2)
        Conjoint_LinesID_new = Find_conjoint_Lines_by_LineID  ( Line_4_Extend(i_LinesID_4_Extend) );
        conjoint_LineID_in_2 = union(Conjoint_LinesID_new, conjoint_LineID_in_2 );
    end
    
    
    %     %% visualizaiton
    %     for i_line = 1:size(conjoint_LineID_in_2,2)
    %         Visualization_road_link_by_line_ID ( conjoint_LineID_in_2(i_line) );
    %     end
    
end


