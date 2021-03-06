function mark_connection = Isconnect_Line_line_by_ID ( LineID_1, LineID_2 )
    %% Isconnect_Line_line_by_ID function description:
    % Imput: LineID_1, LineID_2
    % Output: 
    % 1: lineID is connected with Object line; 0: not.
    % Example
    % Edge_ID_Set
    % mark_connection = IsConnected ( LineID, Object_line, Object_line )
    % Revision Notes:
    %       (10/04/14)
    % by shenghua chen
    % step 1: Get the Start_x, start_y, end_x, End_y for line with lineID 
    % step 2: Matching
    
    mark_connection = 0;
     
   [ StartEnd_XY_of_line_1 ] = Get_StartEnd_XY_of_line_by_line_ID ( LineID_1 );
   [ StartEnd_XY_of_line_2 ] = Get_StartEnd_XY_of_line_by_line_ID ( LineID_2 );
   % StartEnd_XY_of_line: Line ID, start_x, start_y, end_x, end_y
   
   % Object_line: Line ID, start_x, start_y, end_x, end_y
   start_start = sqrt ( (StartEnd_XY_of_line_1(2)-StartEnd_XY_of_line_2(2)).^2 + (StartEnd_XY_of_line_1(3)-StartEnd_XY_of_line_2(3)).^2 );
   start_end = sqrt ( (StartEnd_XY_of_line_1(2)-StartEnd_XY_of_line_2(4)).^2 + (StartEnd_XY_of_line_1(3)-StartEnd_XY_of_line_2(5)).^2 );
   end_start = sqrt ( (StartEnd_XY_of_line_1(4)-StartEnd_XY_of_line_2(2)).^2 + (StartEnd_XY_of_line_1(5)-StartEnd_XY_of_line_2(3)).^2 );
   end_end = sqrt ( (StartEnd_XY_of_line_1(4)-StartEnd_XY_of_line_2(4)).^2 + (StartEnd_XY_of_line_1(5)-StartEnd_XY_of_line_2(5)).^2 );
   
   if (start_start<0.01)||(start_end<0.01)||(end_start<0.01)||(end_end<0.01)
       mark_connection = 1;
   end
   
end
