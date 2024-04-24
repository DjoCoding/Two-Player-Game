unit handlef;

interface

    uses CRT, GAMEITEMF;

    type    
        KEYS = (UP_ARROW, DOWN_ARROW, NO_KEY_PRESSED, BAD_KEY);

        click_t = record 
            PLAYER_KEY: KEYS;
            PLAYER: GAME_ITEM;
        end;
    
    function click_create(PLAYER_KEY: KEYS; PLAYER: GAME_ITEM): click_t;
    function get_key(click: click_t): KEYS;
    function get_player(click: click_t): GAME_ITEM;
    function get_click(): click_t;
    procedure clear_buffer();
    function buffer_is_empty(): boolean;

implementation


function click_create(PLAYER_KEY: KEYS; PLAYER: GAME_ITEM): click_t;

    var result: click_t;

    begin
        result.PLAYER_KEY := PLAYER_KEY;
        result.PLAYER := PLAYER;
        click_create := result;
    end;

function get_key(click: click_t): KEYS;

    begin
        get_key := click.PLAYER_KEY;
    end;

function get_player(click: click_t): GAME_ITEM;

    begin
        get_player := click.PLAYER; 
    end;

function buffer_is_empty(): boolean;

    begin 
        buffer_is_empty := (not KEYPRESSED);
    end;

procedure clear_buffer();

    begin
        while KEYPRESSED do 
            readkey(); 
    end;

function get_click(): click_t; 

    var key: char;
        result: click_t;

    begin 
        if (buffer_is_empty()) then 
            begin 
                get_click := click_create(NO_KEY_PRESSED, BOTH_PLAYERS);
                exit();
            end;
        
        key := readkey();

        case key of 
            #0:
                begin 
                    key := readkey();
                    case key of 
                        #72: result := click_create(UP_ARROW, PLAYER_1);
                        #80: result := click_create(DOWN_ARROW, PLAYER_1);
                    else 
                        result := click_create(NO_KEY_PRESSED, PLAYER_1);
                    end;
                end;
            #122: result := click_create(UP_ARROW, PLAYER_2);
            #115: result := click_create(DOWN_ARROW, PLAYER_2);
            else
                result := click_create(BAD_KEY, PLAYER_2);
        end;
    
        get_click := result;
    end;

procedure click_write(user_click: click_t);

    begin
        writeln('CLICK: {');
        writeln('       PLAYER: ', user_click.PLAYER);
        writeln('       PLAYER_KEY: ', user_click.PLAYER_KEY);
        writeln('}'); 
    end;

begin 
end.