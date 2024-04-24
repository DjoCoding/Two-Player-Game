unit VECTORF;

interface

    type 
        vector_t = record 
            on_rows, on_cols: integer;
        end;
        
    function vector_create(on_rows, on_cols: integer): vector_t;

implementation

function vector_create(on_rows, on_cols: integer): vector_t;

    var result: vector_t;

    begin
        result.on_rows := on_rows;
        result.on_cols := on_cols;
        vector_create := result; 
    end;

begin 
end.