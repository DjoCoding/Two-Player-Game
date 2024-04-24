unit GAMEF;

interface

    uses POSITIONF, VECTORF, CONSTF, GAMEITEMF, PLAYERF;
    type 
        game_t = ^game_type;
        game_type = record 
            grid: array[1..GAME_ROWS, 1..GAME_COLS] of game_item;
            rows, cols: integer; // this is for the dynamic array after getting a stable version of the game!
            player1, player2: player_t;
        end;

    function game_create(): game_t;
    function get_game_player(game: game_t; WHICH_PLAYER: GAME_ITEM): player_t;
    function get_player_position(game: game_t; WHICH_PLAYER: GAME_ITEM): position_t;
    function get_player_vector(game: game_t; WHICH_PLAYER: GAME_ITEM): vector_t;
    procedure set_player_position(game: game_t; position: position_t; WHICH_PLAYER: GAME_ITEM);
    procedure set_player_vector(game: game_t; vector: vector_t; WHICH_PLAYER: GAME_ITEM);

implementation

function game_create(): game_t;

    var result: game_t;

    begin
        new(result);
        result^.player1 := NIL;
        result^.player2 := NIL;
        result^.rows := GAME_ROWS;
        result^.cols := GAME_COLS;
        game_create := result;
        result := NIL;
    end;

function get_game_player(game: game_t; WHICH_PLAYER: GAME_ITEM): player_t;

    begin
        case WHICH_PLAYER of 
            PLAYER_1: get_game_player := game^.player1;
            PLAYER_2: get_game_player := game^.player2;
        end; 
    end;

function get_player_position(game: game_t; WHICH_PLAYER: GAME_ITEM): position_t;

    begin
        get_player_position := get_position(get_game_player(game, WHICH_PLAYER));
    end;

procedure set_player_position(game: game_t; position: position_t; WHICH_PLAYER: GAME_ITEM);

    var player: player_t;

    begin 
        player := get_game_player(game, WHICH_PLAYER);
        set_position(player, position);
    end;

function get_player_vector(game: game_t; WHICH_PLAYER: GAME_ITEM): vector_t;

    begin
        get_player_vector := get_vector(get_game_player(game, WHICH_PLAYER));
    end;

procedure set_player_vector(game: game_t; vector: vector_t; WHICH_PLAYER: GAME_ITEM);

    var player: player_t;

    begin 
        player := get_game_player(game, WHICH_PLAYER);
        set_vector(player, vector);
    end;

begin 
end.