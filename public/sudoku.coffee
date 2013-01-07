#just to avoid confusion: document.getElementsByTagName("th") gets all the boxes of the sudoku grid
#starting by taking the boxes from left to right, starting from the top row down to the bottom row.
#Same method with "input" gets all inputs in same order

#creates a blank sudoku grid
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
  solved = solve(grid)
  output_solved(solved)

#solves the sudoku puzzle and returns it as a 2d array
solve = (grid) ->
  #This project is not complete.
  #To add new logic just define a function that accepts grid,
  #removes values from the arrays at unsolved spots, and returns the new grid array
  #Then add it to the solvers array  
  solvers = [row_removing]
  while(solved(grid) == false)
    for solve in [0..(solvers.length - 1)] by 1
      grid = solvers[solve](grid)
    update_grid(grid)
  return grid

#returns an array with the numbers 1 through nine
one_to_nine = ->
  one_to_nine_array = []
  for counter in [0..8]
    one_to_nine_array[counter] = counter + 1
  return one_to_nine_array

#any position there is only one possibility, puts that number into grid and returns updated grid
update_grid = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
       if(Array.isArray(grid[rows][columns]))
         if(grid[rows][columns].length = 1)
           grid[rows][columns] = grid[rows][columns][0]
  return grid

#check if the sudoku grid is solved
solved = (grid) ->
  for rows in [0..8] by 1
    for columns in [0..8] by 1
      if(Array.isArray(grid[rows][columns]))
        return false
  return true
