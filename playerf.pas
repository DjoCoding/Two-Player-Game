unit PLAYERF;

interface

    USES VECTORF, POSITIONF, LISTF;

    type 
        player_t = ^player_type;
        player_type = record 
            position: position_t;
            vector: vector_t;
            ball_list: list_t;
        end;
    
    function player_create(position: position_t; vector: vector_t): player_t;
    function get_position(player: player_t): position_t;
    procedure set_position(player: player_t; position: position_t);
    function get_vector(player: player_t): vector_t;
    procedure set_vector(player: player_t; vector: vector_t);

implementation

function player_create(position: position_t; vector: vector_t): player_t;

    var result: player_t;

    begin
        new(result);
        result^.position := position;
        result^.vector := vector;
        result^.ball_list := list_create();
        player_create := result;
        result := NIL;
    end;

function get_position(player: player_t): position_t;

    begin
        get_position := player^.position; 
    end;

procedure set_position(player: player_t; position: position_t);

    begin 
        player^.position := position;
    end;

function get_vector(player: player_t): vector_t;

    begin
        get_vector := player^.vector; 
    end;

procedure set_vector(player: player_t; vector: vector_t);

    begin
        player^.vector := vector; 
    end;

begin 
end.