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

#gets inputs, puts them into a 2d array and calls solve on the 2d array
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

#these next lines are for testing, I just define the grid in code

  grid = []

  row1 = [1, 2, 3, 4, 5, 6, 7, 8,  one_to_nine()]
  row2 = [2, 3, 4, 5, 6, 7, 8, 9,  one_to_nine()]
  row3 = [3, 4, 5, 6, 7, 8, 9, 1,  one_to_nine()]
  row4 = [4, 5, 6, 7, 8, 9, 1, 2,  one_to_nine()]
  row5 = [5, 6, 7, 8, 9, 1, 2, 3,  one_to_nine()]
  row6 = [6, 7, 8, 9, 1, 2, 3, 4,  one_to_nine()]
  row7 = [7, 8, 9, 1, 2, 3, 4, 5,  one_to_nine()]
  row8 = [8, 9, 1, 2, 3, 4, 5, 6,  one_to_nine()]
  row9 = [9, 1, 2, 3, 4, 5, 6, 7, one_to_nine()]
  grid = [row1,row2,row3,row4,row5,row6,row7,row8,row9]



  

  solved = solve(grid)
  output_solved(solved)

#solves the sudoku puzzle and returns it as a 2d array
solve = (grid) ->
  #This project is not complete.
  #To add new logic just define a function that accepts grid,
  #removes values from the arrays at unsolved spots, and returns the new grid array
  #Then add it to the solvers array  
  solvers = [row_removing]
  console.log("COCK")
  console.log(grid[0][8])
  console.log(grid[1][8])
  console.log(grid[2][8])
  console.log(grid[3][8])
  console.log(grid[4][8])
  console.log(grid[5][8])
  console.log("COCK")
  while(solved(grid) == false)
    for solve in [0..(solvers.length - 1)] by 1
      grid = solvers[solve](grid)
    console.log(grid[0][8])
    console.log(grid[1][8])
    console.log(grid[2][8])
    console.log(grid[3][8])
    console.log(grid[4][8])
    console.log(grid[5][8])
    update_grid(grid)
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

#removes possible values from a position if that value appears in the same row
row_removing = (grid) ->
  console.log("MOTHERFUCKER")
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      console.log(grid[rows][columns])
      if(Array.isArray(grid[rows][columns]))
        console.log("PENIS")
        for col_vals in [0..8] by 1
          if((col_vals == columns) or (Array.isArray(grid[rows][col_vals])))
            continue
          grid[rows][columns] = remove_value(grid[rows][col_vals], grid[rows][columns])
  return grid

#removes the value val from old_array and returns the updated array without val
remove_value = (val, old_array) ->
  console.log("FUCK")
  console.log(old_array)
  updated_array = []
  for counter in [0..(old_array.length - 1)] by 1
    if(old_array[counter] == val)
      continue
    updated_array.push(old_array[counter])
  console.log(updated_array)
  return updated_array

