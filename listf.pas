unit LISTF;

interface

    uses POSITIONF;

    type 
        node_t = ^node_type;
        node_type = record 
            position: position_t;
            prev, next: node_t;
        end;

        list_t = ^list_type;
        list_type = record 
            head, tail: node_t;
        end;

    function node_create(position: position_t): node_t;
    function list_create(): list_t;
    function get_head(list: list_t): node_t;
    function get_tail(list: list_t): node_t;
    function list_is_empty(list: list_t): boolean;
    procedure list_add(list: list_t; node: node_t);
    procedure list_remove_node(list: list_t; node: node_t);
    procedure list_remove(list: list_t);

implementation

function node_create(position: position_t): node_t;

    var result: node_t;

    begin
        new(result);
        result^.position := position;
        result^.prev := NIL;
        result^.next := NIL;
        node_create := result;
        result := NIL; 
    end;

function list_create(): list_t;

    var result: list_t;

    begin
        new(result);
        result^.head := NIL;
        result^.tail := NIL;
        list_create := result;
        result := NIL;
    end;

function get_head(list: list_t): node_t;

    begin
        get_head := list^.head; 
    end;

function get_tail(list: list_t): node_t;

    begin
        get_tail := list^.tail; 
    end;

function list_is_empty(list: list_t): boolean;

    begin
        list_is_empty := get_head(list) = NIL; 
    end;

procedure list_add(list: list_t; node: node_t);
    
    begin
        if (list_is_empty(list)) then 
            begin
                list^.head := node;
                list^.tail := node; 
            end
        else 
            begin
                list^.tail^.next := node;
                node^.prev := list^.tail;
                list^.tail := node; 
            end;
    end;

procedure list_remove_node(list: list_t; node: node_t);

    var prev, next: node_t;

    begin
        prev := node^.prev;
        next := node^.next;

        if (prev <> NIL) then prev^.next := next;
        if (next <> NIL) then next^.prev := prev;

        if (node = get_head(list)) then list^.head := next;
        if (node = get_tail(list)) then list^.tail := prev;
        
        dispose(node);
        prev := NIL;
        next := NIL;
    end;

procedure list_remove(list: list_t);

    var current: node_t;

    begin
        while (not list_is_empty(list)) do 
            begin
                current := get_head(list);
                list^.head := current^.next;
                dispose(current);
                current := NIL; 
            end
    end;

begin 
end.