#Just to avoid confusion: document.getElementsByTagName("th") gets all the boxes of the sudoku grid
#Starting by taking the boxes from left to right, starting from the top row down to the bottom row.
#Same method with "input" gets all inputs in same order

#Updates the HTML to show a blank sudoku grid
window.draw = ->
  #Gets all the rows of the sudoku grid from top to bottom
  rows = document.getElementsByTagName("tr")
  for q in [0..(rows.length - 1)] by 1
    rows[q].innerHTML = '<th class="col1"></th>
            <th class="col2"></th>
            <th class="col3"></th>
            <th class="col4"></th>
            <th class="col5"></th>
            <th class="col6"></th>
            <th class="col7"></th>
            <th class="col8"></th>
            <th class="col9"></th>'
  boxes = document.getElementsByTagName("th")
  for i in [0..(boxes.length - 1)] by 1
    boxes[i].innerHTML = '<select class="input">
                <option value="blank">blank</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
              </select>'
    #Color the boxes for readability
    if((i < 27) or (i > 53))
      if(((i%9) < 3) or ((i%9) > 5))
        boxes[i].style.backgroundColor = "#DEF3CA"
      else
        boxes[i].style.backgroundColor = "#45A8DF"
    else
      if(((i%9) < 3) or ((i%9) > 5))
        boxes[i].style.backgroundColor = "#45A8DF"
      else
        boxes[i].style.backgroundColor = "#DEF3CA"

#The central data structure is a 3d array of the puzzle. Think of it as a 2d array of the grid.
#If the value of a position is known, put that integer in its position.
#If the value of a position is not known, put an array of possibilities in that position.
window.get_input = ->
  inputs = document.getElementsByClassName("input")
  grid = []
  for create_grid in [0..8] by 1
    grid[create_grid] = []
  get_inputs = 0
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(inputs[get_inputs].value == "blank")
        grid[a_row][a_column] = one_to_nine()
      else
        grid[a_row][a_column] = parseInt(inputs[get_inputs].value)
      get_inputs++

#These next lines are for testing. For convenience, you can define the grid in code
  ###
  b = one_to_nine()
  grid = []
  row1 = [b,b,b,2,b,b,b,6,3]
  row2 = [3,b,b,b,b,5,4,b,1]
  row3 = [b,b,1,b,b,3,9,8,b]
  row4 = [b,b,b,b,b,b,b,9,b]
  row5 = [b,b,b,5,3,8,b,b,b]
  row6 = [b,3,b,b,b,b,b,b,b]
  row7 = [b,2,6,3,b,b,5,b,b]
  row8 = [5,b,3,7,b,b,b,b,8]
  row9 = [4,7,b,b,b,1,b,b,b]
  grid = [row1, row2, row3, row4, row5, row6,row7,row8,row9]
  ###
  solved = solve(grid)
  if(solved == false)
    output_contradiction()
  output_solved(solved)

#Solves the sudoku puzzle and returns it as a 2d array
#If there is a contradiction, then it returns false
solve = (grid) ->
  #This project is not complete. To add new logic just define a function that accepts grid,
  #removes values from the arrays at unsolved spots, and returns the new grid array. Then add it to the solvers array
  rounds_without_updates = 0
  solvers = [row_removing, column_removing, box_removing, row_possibilities, column_possibilities, box_possibilities]
  while(solved(grid) == false)
    grid_snapshot = grid_clone(grid)
    if (has_contradiction(grid))
      return false
    for solve in [0..(solvers.length - 1)] by 1
      grid = solvers[solve](grid)
      grid = update_grid(grid)
      if(has_changed(grid_snapshot, grid))
        break
    if(has_changed(grid_snapshot, grid) == false)
      rounds_without_updates++
    else
      rounds_without_updates = 0
    if(rounds_without_updates == 4)
      grid = guess(grid)
  return grid

#Returns an array with the numbers 1 through 9
one_to_nine = ->
  one_to_nine_array = []
  for fuck in [0..8] by 1
    one_to_nine_array[fuck] = fuck + 1
  return one_to_nine_array

#Any position there is only one possibility, puts that number into grid and returns updated grid
update_grid = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
       if(Array.isArray(grid[a_row][a_column]))
         if(grid[a_row][a_column].length == 1)
           grid[a_row][a_column] = grid[a_row][a_column][0]
  return grid

#Check if the sudoku grid is solved
solved = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        return false
  return true

#Updates the HTML to show the solved sudoku puzzle
output_solved = (solved) ->
  boxes = document.getElementsByTagName("th")
  box_counter = 0
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      boxes[box_counter].innerHTML = solved[a_row][a_column]
      box_counter++

#Updates the HTML to show that there was a contradiction
output_contradiction = ->
  message = document.getElementById('messages')
  message.innerHTML = "EPIC FAIL! Your sudoku puzzle is impossible to solve. Edit your sudoku puzzle and try again."


#Removes possible values from a position if that value appears in the same row
row_removing = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        for col_vals in [0..8] by 1
          if((col_vals == a_column) or (Array.isArray(grid[a_row][col_vals])))
            continue
          grid[a_row][a_column] = remove_value(grid[a_row][col_vals], grid[a_row][a_column])
  return grid

#Removes the value val from old_array and returns the updated array without val
remove_value = (val, old_array) ->
  updated_array = []
  for counter in [0..(old_array.length - 1)] by 1
    if(old_array[counter] == val)
      continue
    updated_array.push(old_array[counter])
  return updated_array

#Removes possible values from a position if that value appears in the same column
column_removing = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        for row_vals in [0..8] by 1
          if((row_vals == a_row) or (Array.isArray(grid[row_vals][a_column])))
            continue
          grid[a_row][a_column] = remove_value(grid[row_vals][a_column], grid[a_row][a_column])
  return grid

#Removes possible values from a position if that value appears in the same 3x3 box
box_removing = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        grid = box_solve(grid, a_row, a_column)
  return grid

#Returns an updated grid with possibilities removed that occur in the same 3x3 box as position specified by row a_row and column a_column
box_solve = (grid, a_row, a_column) ->
  row_range = box_range(a_row)
  column_range = box_range(a_column)
  for row_count in row_range by 1
    for column_count in column_range by 1
      if(((row_count == a_row) and (column_count == a_column)) or Array.isArray(grid[row_count][column_count]))
        continue
      grid[a_row][a_column] = remove_value(grid[row_count][column_count], grid[a_row][a_column])
  return grid

#Gets the range of positions (0-2, 3-5, or 6-8) that a position belongs to
box_range = (position) ->
  if((position >= 0) and (position <= 2))
    return [0,1,2]
  else if ((position >= 3) and (position <= 5))
    return [3,4,5]
  else
    return [6,7,8]

#Checks all positions and sets the value of a position if it's the only position in the row with a possible value
row_possibilities = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        for possible_val in grid[a_row][a_column] by 1
          grid = unique_row_possibility(grid, a_row, a_column, possible_val)
          if(Array.isArray(grid[a_row][a_column]) == false)
            break
  return grid

#Checks position at row a_row and column a_column to see if value possible_val is a unique possibility in a row.
#If it is unique, grid is updated and returned
unique_row_possibility = (grid, a_row, a_column, possible_val) ->
  only_possible_place = true
  for col_vals in [0..8] by 1
    if(col_vals == a_column)
      continue
    if(Array.isArray(grid[a_row][col_vals]) == false)
      if(grid[a_row][col_vals] == possible_val)
        only_possible_place = false
      continue
    for other_possible_val in grid[a_row][col_vals]
      if other_possible_val == possible_val
        only_possible_place = false
  if(only_possible_place == true)
    grid[a_row][a_column] = possible_val
  return grid

#Checks all possibilities and sets the value of a position if it's the only position in the column with a possible value
column_possibilities = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        for possible_val in grid[a_row][a_column] by 1
          grid = unique_column_possibility(grid, a_row, a_column, possible_val)
          if(Array.isArray(grid[a_row][a_column]) == false)
            break
  return grid

#Checks position at row a_row and column a_column to see if value possible_val is a unique possibility in a column.
#If it is unique, grid is updated and returned
unique_column_possibility = (grid, a_row, a_column, possible_val) ->
  only_possible_place = true
  for row_vals in [0..8] by 1
    if(row_vals == a_row)
      continue
    if(Array.isArray(grid[row_vals][a_column]) == false)
      if(grid[row_vals][a_column] == possible_val)
        only_possible_place = false
      continue
    for other_possible_val in grid[row_vals][a_column]
      if other_possible_val == possible_val
        only_possible_place = false
  if(only_possible_place == true)
    grid[a_row][a_column] = possible_val
  return grid

#Checks all possibilities and sets the value of a position if it's the only position in a 3x3 box with a possible value
box_possibilities = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        for possible_val in grid[a_row][a_column] by 1
          grid = unique_box_possibility(grid, a_row, a_column, possible_val)
        if(Array.isArray(grid[a_row][a_column] == false))
          break
  return grid

#Checks position at row a_row and column a_column to see if value possible_val is a unique possibility in a 3x3 box.
#If it is unique, grid is updated and returned
unique_box_possibility = (grid, a_row, a_column, possible_val) ->
  only_possible_place = true
  row_range = box_range(a_row)
  column_range = box_range(a_column)
  for row_count in row_range by 1
    for column_count in column_range by 1
      if((row_count == a_row) and (column_count == a_column))
        continue
      if(Array.isArray(grid[row_count][column_count]) == false)
        if(grid[row_count][column_count] == possible_val)
          only_possible_place = false
        continue
      for other_possible_val in grid[row_count][column_count] by 1
        if other_possible_val == possible_val
          only_possible_place = false
  if(only_possible_place == true)
    grid[a_row][a_column] = possible_val
  return grid

#Checks if there is a contradiction in the sudoku puzzle and returns true or false
has_contradiction = (grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      check_contradictions = [zero_possibilities, row_repeats, column_repeats, box_repeats]
      for counter in [0..3] by 1
        con_exists = check_contradictions[counter](grid, a_row, a_column)
        if(con_exists == true)
          return true
  return false

#Returns true if at position [a_row][a_column] there are no possibilities
zero_possibilities = (grid, a_row, a_column) ->
  if((Array.isArray(grid[a_row][a_column])) and (grid[a_row][a_column].length == 0))
    return true
  return false

#Returns true if another position in the row a_row has the same value as [a_row][a_column]
row_repeats = (grid, a_row, a_column) ->
  if(Array.isArray(grid[a_row][a_column]) == false)
    for column_vals in [0..8] by 1
      if((column_vals == a_column) or (Array.isArray(grid[a_row][column_vals])))
        continue
      if(grid[a_row][column_vals] == grid[a_row][a_column])
        return true
  return false

#Returns true if another position in the column a_column has the same value as [a_row][a_column]
column_repeats = (grid, a_row, a_column) ->
  if(Array.isArray(grid[a_row][a_column]) == false)
    for row_vals in [0..8] by 1
      if((row_vals == a_row) or (Array.isArray(grid[row_vals][a_column])))
        continue
      if(grid[row_vals][a_column] == grid[a_row][a_column])
        return true
  return false

#Returns true if another position in the 3x3 box has the same value as [a_row][a_column]
box_repeats = (grid, a_row, a_column) ->
  if(Array.isArray(grid[a_row][a_column]) == false)
    row_range = box_range(a_row)
    column_range = box_range(a_column)
    for row_count in row_range by 1
      for column_count in column_range by 1
        if(((row_count == a_row) and (column_count == a_column)) or (Array.isArray(grid[row_count][column_count])))
          continue
        if(grid[row_count][column_count] == grid[a_row][a_column])
          return true
  return false

#Returns true if there is a position with a value that had only possibilities before
has_changed = (grid_snapshot, grid) ->
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if((Array.isArray(grid_snapshot[a_row][a_column])) and (Array.isArray(grid[a_row][a_column]) == false))
        return true
  return false

#If our logic can't figure anything out, there's no choice but to guess.
#This function takes the position with the lowest possibilities and makes guesses.
#False is returned if it's impossible to solve
guess = (grid) ->
  lowest_length = 10
  lowest_row
  lowest_column
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]) == false)
        continue
      if(grid[a_row][a_column].length < lowest_length)
        lowest_row = a_row
        lowest_column = a_column
        lowest_length = grid[a_row][a_column].length
      if(lowest_length == 2)
        break
    if(lowest_length == 2)
      break
  return guess_to_solve(grid,lowest_row,lowest_column)

#Tries to solve the grid by applying guesses at [lowest_row][lowest_column]. Returns false if impossible to solve
guess_to_solve = (grid,lowest_row,lowest_column) ->
  for possibilities in [0..(grid[lowest_row][lowest_column].length - 1)] by 1
    temporary_grid = grid_clone(grid)
    temporary_grid[lowest_row][lowest_column] = grid[lowest_row][lowest_column][possibilities]
    temporary_grid = solve(temporary_grid)
    if(temporary_grid != false)
      grid = temporary_grid
      break
  if(temporary_grid == false)
    return false
  return grid

#returns an exact, new clone of the grid
grid_clone = (grid) ->
  clone = [[],[],[],[],[],[],[],[],[]]
  for a_row in [0..8] by 1
    for a_column in [0..8] by 1
      if(Array.isArray(grid[a_row][a_column]))
        clone[a_row][a_column] = []
        for possibilities in [0..(grid[a_row][a_column].length - 1)] by 1
          clone[a_row][a_column][possibilities] = grid[a_row][a_column][possibilities]
      else
        clone[a_row][a_column] = grid[a_row][a_column]
  return clone
