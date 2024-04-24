# PLAYER STRUCTURE:
+ current position on the grid
+ list of missiles the player sent
+ next vector (to generate the next position)

# MISSILES STRUCTURE:
+ doubly linked list containing the following: 
    + the player they were sent by ( this will be used to determine the next move )
    + current position on the grid 

# COLLISION:
+ collision will be generated once the missile hits the player or hits the wall

# KEY HANDLING: 
+ the unit handlef.pas will take care of this
+ PLAYER 1: the arrows
+ PLAYER 2: z ( for up ), s ( for down )

# GAME CONFIG:
+ GAME GRID: dynamic array where the number of rows and columns are given by the user

+ PLAYERS POSITION


