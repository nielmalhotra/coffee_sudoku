coffee_sudoku
=============

A sudoku solver written in coffeescript, html, css, and sinatra. All the hard calculating is done client side.

You can view the finished result <a href="http://sudokusolver.nielmalhotra.com">here</a>.

This solver is pretty simple. It creates a 2d array of the entire sudoku board. Position 0,0 is the top left corner and 8,8 is the bottom right corner. If the value of a position is known, then that position in the 2d array is an integer. If the value is not known, then the value at that position is an array of the possible values of that position.

The solver then removes values from positions if that value occurs in the same box, row, or column. If an array has one value, then that position in the grid is updated to only hold that integer.

Next, the solver sets a value of a position if it's the only position in its row, column, or box that could possibly have that value.

These cycles continue to repeat. If four cycles occur and there are no updates, then a guess is made and the solver continues. If a contradiction happens, then guesses are continually tried until the correct solution is found. Also, if more guesses are needed, the guess and solve methods are applied recursively until a solution is reached (first time I've used recursion outside of a classroom).

There is also a checker to make sure that the puzzle is solvable. If a position has no possible values or if a value occurs twice in the same box, row, or column, then an error is raised.

The code could probably be refactored to be cleaner. There were a ridiculous amount of nested loops, which were pretty much necessary given the nature of the problem (I think the worst was six loops deep). I abstracted the loops into functions, but I think there is room for improvement.

Also, the design could be updated. I'm thinking about learning a little bit about web design, so I might try to update the look of my sudoku solver as an exercise in web design sometime later.
