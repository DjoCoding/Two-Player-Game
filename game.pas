unit game;

interface

    uses CRT, LISTF, POSITIONF, GAMEITEMF, VECTORF, PLAYERF, GAMEF, CONSTF, HANDLEF;

    procedure run(number_iterations, fps: integer);

implementation

function get_next_vector(user_click: click_t): vector_t;

    var result: vector_t;

    begin
        case get_key(user_click) of 
            UP_ARROW: result := vector_create(-1, 0);
            DOWN_ARROW: result := vector_create(1, 0);
        end;
        get_next_vector := result;
    end;

function get_index_in_range(index: integer): integer;

    begin
        if (index <= 0) then 
            get_index_in_range := 1
        else 
            if (index >= GAME_ROWS + 1) then 
                get_index_in_range := GAME_ROWS
            else 
                get_index_in_range := index;
    end;

function get_other_player(WHICH_PLAYER: GAME_ITEM): GAME_ITEM;

    begin
        case WHICH_PLAYER of 
            PLAYER_1: get_other_player := PLAYER_2;
            PLAYER_2: get_other_player := PLAYER_1;
        end; 
    end;

// this will get the next position after each event from the user!
// suppose the next vector is already in the player configuration!
function get_next_position(game: game_t; WHICH_PLAYER: GAME_ITEM): position_t;

    var player: player_t;
        result: position_t;
    
    begin   
        player := get_game_player(game, WHICH_PLAYER);
        result := position_create(get_index_in_range(get_row(get_position(player)) + get_vector(player).on_rows), get_col(get_position(player)));
        get_next_position := result;
    end;

procedure set_new_position(game: game_t; player_click: click_t);

    var WHICH_PLAYER: GAME_ITEM;
        vector: vector_t;
        position : position_t;

    begin   
        WHICH_PLAYER := get_player(player_click);
        
        if (get_key(player_click) = NO_KEY_PRESSED) then 
            vector := get_vector(get_game_player(game, WHICH_PLAYER))
        else 
            vector := get_next_vector(player_click);

        set_vector(get_game_player(game, WHICH_PLAYER), vector);
        position := get_next_position(game, WHICH_PLAYER);
        set_position(get_game_player(game, WHICH_PLAYER), position);
    end;

procedure add_new_ball(game: game_t; WHICH_PLAYER: GAME_ITEM);

    var player: player_t;
        ball: node_t;

    begin
        player := get_game_player(game, WHICH_PLAYER);
        ball := node_create(get_position(player));
        list_add(player^.ball_list, ball);
        ball := NIL; 
    end;

procedure update_ball_position(node: node_t; step: integer);

    var col: integer;

    begin
        col := node^.position.col;
        col := col + step;
        node^.position.col := col;
    end;

function does_collide(node: node_t): boolean;

    begin
        does_collide := (node^.position.col > GAME_COLS) or (node^.position.col < 1); 
    end;

procedure move_player_balls(game: game_t; WHICH_PLAYER: GAME_ITEM);

    var player: player_t;
        list: list_t;
        next, current: node_t;
        step: integer;

    begin
        case WHICH_PLAYER of 
            PLAYER_1: step := -1;
            PLAYER_2: step := 1;
        end;

        player := get_game_player(game, WHICH_PLAYER);
        list := player^.ball_list;
        current := get_head(list);

        while (current <> NIL) do 
            begin
                next := current^.next;
                update_ball_position(current, step);
                if (does_collide(current)) then 
                    list_remove_node(list, current);
                current := next; 
            end; 
    end;

procedure move_balls(game: game_t);

    begin
        move_player_balls(game, PLAYER_1);
        move_player_balls(game, PLAYER_2); 
    end;

procedure set_player_balls(game: game_t; WHICH_PLAYER: GAME_ITEM);

    var player: player_t;
        list: list_t;
        current: node_t;

    begin
        player := get_game_player(game, WHICH_PLAYER);
        list := player^.ball_list;
        current := get_head(list);
        while (current <> NIL) do 
            begin
                game^.grid[current^.position.row, current^.position.col] := BALL;
                current := current^.next; 
            end;
        list := NIL;
        player := NIL;
    end;

procedure set_balls(game: game_t);

    begin
        set_player_balls(game, PLAYER_1);
        set_player_balls(game, PLAYER_2); 
    end;

procedure update_balls(game: game_t);

    begin
        move_balls(game);
        set_balls(game) 
    end;

function get_winner(game: game_t): integer;

    var player1, player2: player_t;
        position1, position2: position_t;
        current1, current2: node_t;

    begin
        //GETTING PLAYERS
        player1 := get_game_player(game, PLAYER_1);
        player2 := get_game_player(game, PLAYER_2);

        //GETTING POSITIONS
        position1 := get_position(player1);
        position2 := get_position(player2);

        //SETTING UP THE BALL NODES!
        current1 := get_head(player1^.ball_list);
        current2 := get_head(player2^.ball_list);
        
        //INITIALIZING THE WINNER VALUE FOR "NO WINNER"
        get_winner := 0;

        // two different loops to check for the tie event!
        while (current1 <> NIL) do 
            begin
                if (equal_position(position2, current1^.position)) then 
                    begin
                        get_winner := 1;
                        break; 
                    end;
                current1 := current1^.next; 
            end;
        
        while (current2 <> NIL) do 
            begin   
                if (equal_position(position1, current2^.position)) then 
                    begin   
                        if (get_winner <> 0) then 
                            get_winner := -1
                        else 
                            get_winner := 2;
                        break; 
                    end;
                current2 := current2^.next;
            end;
    end;

procedure grid_init(game: game_t);

    var i, j: integer;

    begin   
        for i := 1 to GAME_ROWS do 
            for j := 1 to GAME_COLS do 
                game^.grid[i, j] := EMPTY; 
    end;

function game_init(): game_t;

    var result: game_t;

    begin
        result := game_create();
        result^.rows := GAME_ROWS;
        result^.cols := GAME_COLS; 
        result^.player1 := player_create(position_create(GAME_ROWS, GAME_COLS), vector_create(1, 0));
        result^.player2 := player_create(position_create(1, 1), vector_create(-1, 0)); 
        grid_init(result);
        game_init := result;
        result := NIL;
    end;

//KEEP READING KEYS FROM THE BUFFER UNTIL A KEY WITH THE .PLAYER = WHICH_PLAYER IS FOUND!

function get_player_click(WHICH_PLAYER: GAME_ITEM): click_t;

    var click: click_t;

    begin
        while (not buffer_is_empty()) do 
            begin
                click := get_click();
                if (get_player(click) = WHICH_PLAYER) then 
                    break;  
            end;
        
        if (get_player(click) = WHICH_PLAYER) then 
            get_player_click := click 
        else 
            get_player_click := click_create(NO_KEY_PRESSED, WHICH_PLAYER);
    end;

procedure update_player(game: game_t; player_click: click_t);

    begin
        set_new_position(game, player_click);
    end;

procedure update_game(game: game_t; set_new_balls: boolean);

    var player_click: click_t;
        WHICH_PLAYER: GAME_ITEM;

    begin
        if (not buffer_is_empty()) then  
            begin
                player_click := get_click();
                WHICH_PLAYER := get_player(player_click);
                update_player(game, player_click);
                WHICH_PLAYER := get_other_player(WHICH_PLAYER);
                player_click := get_player_click(WHICH_PLAYER);
                update_player(game, player_click);
            end
        else 
            begin
                player_click := click_create(NO_KEY_PRESSED, PLAYER_1);
                update_player(game, player_click);
                player_click.PLAYER := PLAYER_2;
                update_player(game, player_click); 
            end;
        if (set_new_balls) then 
            begin 
                add_new_ball(game, PLAYER_1);
                add_new_ball(game, PLAYER_2);
            end;
        clear_buffer();
    end;

procedure set_player(game: game_t; WHICH_PLAYER: GAME_ITEM);

    var player: player_t;

    begin
        player := get_game_player(game, WHICH_PLAYER);
        game^.grid[get_row(get_position(player)), get_col(get_position(player))] := WHICH_PLAYER; 
    end;

procedure set_players(game: game_t); 

    begin
        set_player(game, PLAYER_1);
        set_player(game, PLAYER_2); 
    end;

procedure update_grid(game: game_t);

    begin 
        grid_init(game);
        update_balls(game);
        set_players(game);
    end;

procedure render_item(ITEM: GAME_ITEM);

    begin
        case ITEM of 
            PLAYER_1:
                begin 
                    TextColor(Red);
                    write(' <| ');
                    TextColor(white);
                end;
            PLAYER_2: 
                begin 
                    TextColor(Blue);
                    write(' |> ');
                    TextColor(white);
                end;
            BALL: 
                begin 
                    TextColor(green);
                    write(' -- ');   
                    TextColor(white);
                end;
            EMPTY: write('    ');
        end; 
    end;

procedure print_walls();

    var i: integer;

    begin
        for i := 1 to 10 do 
            write('   ');
        
        write(' ');
    
        for i := 1 to GAME_ROWS do 
            write('----');
        
        writeln(); 
    end;

procedure render(game: game_t);

    var i, j: integer;

    begin
        print_walls();

        for i := 1 to GAME_ROWS do 
            begin 
                for j := 1 to 10 do 
                    write('   ');
                write('|');
                for j := 1 to GAME_COLS do 
                    render_item(game^.grid[i, j]);
                writeln('|');
            end;

        print_walls();
    end;


// FPS = SECOND / ITERATIONS (ASSUMING HANDLING THE GAME LOGIC TAKES NO TIME)
function get_delay(fps: integer): integer;

    begin
        get_delay := 1000 div fps; 
    end;

procedure run(number_iterations, fps: integer);

    var
        game: game_t;
        set_new_balls: boolean;
        count, DELAY_TIME, GAME_RESULT: integer;
        WINNER: GAME_ITEM;

    begin
        game := game_init();
        readln();
        count := 0;
        DELAY_TIME := get_delay(fps);
        repeat
            inc(count);
            set_new_balls := (count = number_iterations);
            if (set_new_balls) then count := 0;

            clrscr();

            update_game(game, set_new_balls);
            update_grid(game);

            GAME_RESULT := get_winner(game);

            render(game);

            delay(DELAY_TIME);
        until(GAME_RESULT <> 0);
    
        writeln();

        case GAME_RESULT of 
            1: WINNER := PLAYER_1;
            2: WINNER := PLAYER_2;
            -1 : WINNER := NO_PLAYER;
        end;

        writeln(WINNER, ' won the game!');
    end;

begin 
end.