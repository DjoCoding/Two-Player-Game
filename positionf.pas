unit POSITIONF;

interface

    type 
        position_t = record     
            row, col: integer;
        end;

    function position_create(row, col: integer): position_t;
    function get_row(position: position_t): integer;
    function get_col(position: position_t): integer;
    procedure set_row(var position: position_t; row: integer);
    procedure set_col(var position: position_t; col: integer);

    function equal_position(position1, position2: position_t): boolean;
    
implementation  

function position_create(row, col: integer): position_t;

    var result: position_t;

    begin
        result.row := row;
        result.col := col;
        position_create := result; 
    end;

function get_row(position: position_t): integer;

    begin
        get_row := position.row; 
    end;

function get_col(position: position_t): integer;

    begin
        get_col := position.col; 
    end;

procedure set_row(var position: position_t; row: integer);

    begin
        position.row := row; 
    end;

procedure set_col(var position: position_t; col: integer);

    begin
        position.col := col; 
    end;

function equal_position(position1, position2: position_t): boolean;

    begin
        equal_position := (get_row(position1) = get_row(position2)) and (get_col(position1) = get_col(position2)); 
    end;

begin 
end.