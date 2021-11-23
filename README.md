# MINI-CIVILIZATION

This projects aims to reproduce basic mechanisms of the Civilization game.

Some basic description:
* you start with 1 character and 100 golds
* the game will be played turn by turn (every command will
  immediately be applied, consuming 1 or more turns).
* the character can build two kinds of buildings:
  - a gold mine which costs 30 golds and generates 5 golds by turn.
  - a house which costs 30 golds and need 2 turns to produce a character for 15 golds.
* all the game will run on an (infinite) map with cells on integer coordinates. Two building 
  cannot share the same cell. The characters can share a same cell and be on
 a cell containing a building.
* the characters can move at the speed of 1 cell per turn (left, right, top or bottom,
  not by the diagonals).
* every "object" (character or building) has a unique numeric id (a simple 
  incrementing integer will be good enough for this game).
* the goal is to reach the highest gold amount in 100 turns.


## Minimal set of commands to implement
* display the character with its id on the screen at its correct position.
* move the character `i` to the given direction: `move(i, left)` (the direction
  can be `left, right, up` or `down`. This takes 1 turn.
* display the turn count on the screen.
* make the character `i` build a mine or a house at its current position: `build(i, mine)`.
  Building a mine or a house take 2 turns.
  The command fails either if (and the turn is consumed):
  - there already is a building at this position,
  - the gold amount is not high enough to build it,
  - `i` is not a building.
* It is possible that for a given turn, the player cannot perform any action
  (e.g., all the characters are building something or all the buildings are busy)
  in this case the player can use the `pass` command which will do "nothing".
 
  If a `i` character is already building something and the player run a command like `move(i, left)`,
  the resources used for the building are lost. The place is freed for further buildings.

* Make gold mines generate 10 golds by turn.
* add the character creation: `create_human(i)` where `i` is the house id.
  Like for buildings creation, 
  the command can fail for similar reasons.



## Additional optional features
* Now that we have multiple charaters and buildings, we may want give multiple orders at the time.
  Create the `batch [ command1, command2, ...]`commad where `commandX` can be any other previously
  defined commands.

  If any command fail, the whole command fails. If two 
* display the list of idle units somewhere on the screen (characters and houses).
* make the gold mine efficiency decrease if there are other mines in their immediate neighboorhood:
   - for 0 other mines => 5 golds/turn
   - for 1 other mines => 2 golds/turn
   - for 2 other mines => 0 golds/turn
* implement the `goto(i, x, y)` which will move the character `i` at the cell of coordinates 
  `(x,y)`. The character will still move 1 cell by turn, so the deplacement will spread across
   multiple turns.
* make it possible for the user to save the current session as a file and to restore the session by loading the file.
  *Hint: the whole state of the session only depends on the user commands.*



