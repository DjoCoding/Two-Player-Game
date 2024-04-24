USES GAME;

procedure main();

    var fps, number_iterations: integer;

    begin   
        write('iterations to get one ball: ');readln(number_iterations);
        write('fps: ');readln(fps);
        run(number_iterations, fps);
    end;

begin
    main();
end.