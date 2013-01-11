#just to avoid confusion: document.getElementsByTagName("th") gets all the boxes of the sudoku grid
#starting by taking the boxes from left to right, starting from the top row down to the bottom row.
#Same method with "input" gets all inputs in same order

#updates the HTML to show a blank sudoku grid
window.draw = ->
  #gets all the rows of the sudoku grid from top to bottom
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
    #color the boxes for readability
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
#If the value of a position is known, put that integer in its position. If the value of a position is not known, put an array of possibilities in that position.
window.get_input = ->
  inputs = document.getElementsByClassName("input")
  grid = []
  for create_grid in [0..8] by 1
    grid[create_grid] = []
  get_inputs = 0
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(inputs[get_inputs].value == "blank")
        grid[rows][columns] = one_to_nine() 
      else
        grid[rows][columns] = parseInt(inputs[get_inputs].value)  
      get_inputs++

#These next lines are for testing. For convenience, you can define the grid in code

  b = one_to_nine()
  grid = []

  row1 = [1,b,b,b,b,b,b,b,b]
  row2 = [2,b,b,b,b,b,b,b,b]
  row3 = [3,b,b,b,b,b,b,b,b]
  row4 = [4,b,b,b,b,b,b,b,b]
  row5 = [5,b,b,b,b,b,b,b,b]
  row6 = [b,b,b,b,b,b,b,b,b]
  row7 = [b,b,b,b,b,b,b,b,b]
  row8 = [b,b,b,b,b,b,b,b,b]
  row9 = [b,b,b,b,b,6,7,8,9]
  grid = [row1, row2, row3, row4, row5, row6,row7,row8,row9]

  solved = solve(grid)
  if(solved == false)
    output_contradiction()    
  output_solved(solved)

#solves the sudoku puzzle and returns it as a 2d array
#if there is a contradiction, then it returns false
solve = (grid) ->        
  #This project is not complete.
  #To add new logic just define a function that accepts grid,
  #removes values from the arrays at unsolved spots, and returns the new grid array
  #Then add it to the solvers array  
  rounds_without_updates = 0
  solvers = [row_removing, column_removing, box_removing, row_possibilities, column_possibilities, box_possibilities]
  while(solved(grid) == false)
    grid_snapshot = grid
    if (has_contradiction(grid))
      return false
    for solve in [0..(solvers.length - 1)] by 1
      grid = solvers[solve](grid)
      grid = update_grid(grid)
    if(has_changed(grid_snapshot, grid) == false)
      rounds_without_updates++
    else
      rounds_without_updates = 0
    if(rounds_without_updates == 2)
      console.log("HAPPY HAPPY JOY JOY")
  return grid

#returns an array with the numbers 1 through nine
one_to_nine = ->
  one_to_nine_array = []
  for counter in [0..8] by 1
    one_to_nine_array[counter] = counter + 1
  return one_to_nine_array

#any position there is only one possibility, puts that number into grid and returns updated grid
update_grid = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
       if(Array.isArray(grid[rows][columns]))
         if(grid[rows][columns].length == 1)
           grid[rows][columns] = grid[rows][columns][0]
  return grid

#check if the sudoku grid is solved
solved = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        return false
  return true

#updates the HTML to show the solved sudoku puzzle
output_solved = (solved) ->
  boxes = document.getElementsByTagName("th")
  box_counter = 0
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      boxes[box_counter].innerHTML = solved[rows][columns]
      box_counter++

#updates the HTML to show that there was a contradiction
output_contradiction = ->
  message = document.getElementById('messages')
  message.innerHTML = "EPIC FAIL! Your sudoku puzzle is impossible to solve. Click refresh to get a new sudoku board and check to make sure that you entered your sudoku puzzle correctly"
  

#removes possible values from a position if that value appears in the same row
row_removing = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        for col_vals in [0..8] by 1
          if((col_vals == columns) or (Array.isArray(grid[rows][col_vals])))
            continue
          grid[rows][columns] = remove_value(grid[rows][col_vals], grid[rows][columns])
  return grid

#removes the value val from old_array and returns the updated array without val
remove_value = (val, old_array) ->
  updated_array = []
  for counter in [0..(old_array.length - 1)] by 1
    if(old_array[counter] == val)
      continue
    updated_array.push(old_array[counter])
  return updated_array

#removes possible values from a position if that value appears in the same column
column_removing = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        for row_vals in [0..8] by 1
          if((row_vals == rows) or (Array.isArray(grid[row_vals][columns])))
            continue
          grid[rows][columns] = remove_value(grid[row_vals][columns], grid[rows][columns])
  return grid

#removes possible values from all position if that value appears in the same 3x3 box
box_removing = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        grid = box_solve(grid, rows, columns)
  return grid

#returns an updated grid with possibilities removed that occur in the same 3x3 box as position specified by row rows and column columns
box_solve = (grid, rows, columns) ->  
  row_range = box_range(rows)
  column_range = box_range(columns)
  for row_count in row_range by 1
    for column_count in column_range by 1
      if(((row_count == rows) and (column_count == columns)) or Array.isArray(grid[row_count][column_count]))
        continue
      grid[rows][columns] = remove_value(grid[row_count][column_count], grid[rows][columns])
  return grid

#gets the range of positions (0-2, 3-5, or 6-8) that a position belongs to
box_range = (position) ->
  if((position >= 0) and (position <= 2))
    return [0,1,2]
  else if ((position >= 3) and (position <= 5))
    return [3,4,5]
  else
    return [6,7,8]

#checks all positions and sets the value of a position if it's the only position in the row with a possible value
row_possibilities = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        for possible_val in grid[rows][columns] by 1
          grid = unique_row_possibility(grid, rows, columns, possible_val)
          if(Array.isArray(grid[rows][columns]) == false)
            break
  return grid
        
#Checks position at row rows and column columns to see if value possible_val is a unique possibility in a row.
#If it is unique, grid is updated and returned
unique_row_possibility = (grid, rows, columns, possible_val) ->
  only_possible_place = true
  for col_vals in [0..8] by 1
    if((col_vals == columns) or (Array.isArray(grid[rows][col_vals]) == false))
      continue
    for other_possible_val in grid[rows][col_vals]
      if other_possible_val == possible_val
        only_possible_place = false
  if(only_possible_place == true)
    grid[rows][columns] = possible_val
  return grid

#checks all possibilities and sets the value of a position if it's the only position in the column with a possible value
column_possibilities = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        for possible_val in grid[rows][columns] by 1
          grid = unique_column_possibility(grid, rows, columns, possible_val)
          if(Array.isArray(grid[rows][columns]) == false)
            break
  return grid

#Checks position at row rows and column columns to see if value possible_val is a unique possibility in a column.
#If it is unique, grid is updated and returned
unique_column_possibility = (grid, rows, columns, possible_val) ->
  only_possible_place = true
  for row_vals in [0..8] by 1
    if((row_vals == rows) or (Array.isArray(grid[row_vals][columns]) == false))
      continue
    for other_possible_val in grid[row_vals][columns]
      if other_possible_val == possible_val
        only_possible_place = false
  if(only_possible_place == true)
    grid[rows][columns] = possible_val
  return grid

#checks all possibilities and sets the value of a position if it's the only position in a 3x3 box with a possible value
box_possibilities = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        for possible_val in grid[rows][columns] by 1
          grid = unique_box_possibility(grid, rows, columns, possible_val)
        if(Array.isArray(grid[rows][columns] == false))
          break
  return grid

#Checks position at row rows and column columns to see if value possible_val is a unique possibility in a 3x3 box.
#If it is unique, grid is updated and returned
unique_box_possibility = (grid, rows, columns, possible_val) ->
  only_possible_place = true
  row_range = box_range(rows)
  column_range = box_range(columns)
  for row_count in row_range by 1
    for column_count in column_range by 1
      if(((row_count == rows) and (column_count == columns)) or (Array.isArray(grid[row_count][column_count]) == false))
        continue
      for other_possible_val in grid[row_count][column_count] by 1
        if other_possible_val == possible_val
          only_possible_place = false
  if(only_possible_place == true)
    grid[rows][columns] = possible_val
  return grid

#checks if there is a contradiction in the sudoku puzzle and returns true or false
has_contradiction = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      check_contradictions = [zero_possibilities, row_repeats, column_repeats, box_repeats]
      for counter in [0..3] by 1
        con_exists = check_contradictions[counter](grid, rows, columns)
        if(con_exists == true)
          return true
  return false

#returns true if at position [rows][columns] there are no possibilities
zero_possibilities = (grid, rows, columns) ->
  if((Array.isArray(grid[rows][columns])) and (grid[rows][columns].length == 0))
    return true
  return false

#returns true if another position in the row rows has the same value as [rows][columns]
row_repeats = (grid, rows, columns) ->
  if(Array.isArray(grid[rows][columns]) == false)
    for column_vals in [0..8] by 1
      if((column_vals == columns) or (Array.isArray(grid[rows][column_vals])))
        continue
      if(grid[rows][column_vals] == grid[rows][columns])
        return true
  return false

#returns true if another position in the column columns has the same value as [rows][columns]
column_repeats = (grid, rows, columns) ->
  if(Array.isArray(grid[rows][columns]) == false)
    for row_vals in [0..8] by 1
      if((row_vals == rows) or (Array.isArray(grid[row_vals][columns])))
        continue
      if(grid[row_vals][columns] == grid[rows][columns])
        return true
  return false

#returns true if another position in the 3x3 box has the same value as [rows][columns]
box_repeats = (grid, rows, columns) ->
  if(Array.isArray(grid[rows][columns]) == false)
    row_range = box_range(rows)
    column_range = box_range(columns)
    for row_count in row_range by 1
      for column_count in column_range by 1
        if(((row_count == rows) and (column_count == columns)) or (Array.isArray(grid[row_count][column_count])))
          continue
        if(grid[row_count][column_count] == grid[rows][columns])
          return true
  return false

