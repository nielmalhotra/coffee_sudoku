(function() {
  var one_to_nine, output_solved, remove_value, row_removing, solve, solved, update_grid;

  window.draw = function() {
    var boxes, i, q, rows, _ref, _ref2, _results;
    rows = document.getElementsByTagName("tr");
    for (q = 0, _ref = rows.length - 1; q <= _ref; q += 1) {
      rows[q].innerHTML = '<th class="col1"></th>\
	    <th class="col2"></th>\
	    <th class="col3"></th>\
	    <th class="col4"></th>\
	    <th class="col5"></th>\
	    <th class="col6"></th>\
	    <th class="col7"></th>\
	    <th class="col8"></th>\
	    <th class="col9"></th>';
    }
    boxes = document.getElementsByTagName("th");
    _results = [];
    for (i = 0, _ref2 = boxes.length - 1; i <= _ref2; i += 1) {
      boxes[i].innerHTML = '<select class="input">\
                <option value="blank">blank</option>\
                <option value="1">1</option>\
                <option value="2">2</option>\
                <option value="3">3</option>\
                <option value="4">4</option>\
                <option value="5">5</option>\
                <option value="6">6</option>\
                <option value="7">7</option>\
                <option value="8">8</option>\
                <option value="9">9</option>\
              </select>';
      if ((i < 27) || (i > 53)) {
        if (((i % 9) < 3) || ((i % 9) > 5)) {
          _results.push(boxes[i].style.backgroundColor = "#DEF3CA");
        } else {
          _results.push(boxes[i].style.backgroundColor = "#45A8DF");
        }
      } else {
        if (((i % 9) < 3) || ((i % 9) > 5)) {
          _results.push(boxes[i].style.backgroundColor = "#45A8DF");
        } else {
          _results.push(boxes[i].style.backgroundColor = "#DEF3CA");
        }
      }
    }
    return _results;
  };

  window.get_input = function() {
    var columns, create_grid, get_inputs, grid, inputs, row1, row2, row3, row4, row5, row6, row7, row8, row9, rows, solved;
    inputs = document.getElementsByClassName("input");
    grid = [];
    for (create_grid = 0; create_grid <= 8; create_grid += 1) {
      grid[create_grid] = [];
    }
    get_inputs = 0;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (inputs[get_inputs].value === "blank") {
          grid[rows][columns] = one_to_nine();
        } else {
          grid[rows][columns] = parseInt(inputs[get_inputs].value);
        }
        get_inputs++;
      }
    }
    grid = [];
    row1 = [1, 2, 3, 4, 5, 6, 7, 8, one_to_nine()];
    row2 = [2, 3, 4, 5, 6, 7, 8, 9, one_to_nine()];
    row3 = [3, 4, 5, 6, 7, 8, 9, 1, one_to_nine()];
    row4 = [4, 5, 6, 7, 8, 9, 1, 2, one_to_nine()];
    row5 = [5, 6, 7, 8, 9, 1, 2, 3, one_to_nine()];
    row6 = [6, 7, 8, 9, 1, 2, 3, 4, one_to_nine()];
    row7 = [7, 8, 9, 1, 2, 3, 4, 5, one_to_nine()];
    row8 = [8, 9, 1, 2, 3, 4, 5, 6, one_to_nine()];
    row9 = [9, 1, 2, 3, 4, 5, 6, 7, one_to_nine()];
    grid = [row1, row2, row3, row4, row5, row6, row7, row8, row9];
    solved = solve(grid);
    return output_solved(solved);
  };

  solve = function(grid) {
    var solve, solvers, _ref;
    solvers = [row_removing];
    console.log("COCK");
    console.log(grid[0][8]);
    console.log(grid[1][8]);
    console.log(grid[2][8]);
    console.log(grid[3][8]);
    console.log(grid[4][8]);
    console.log(grid[5][8]);
    console.log("COCK");
    while (solved(grid) === false) {
      for (solve = 0, _ref = solvers.length - 1; solve <= _ref; solve += 1) {
        grid = solvers[solve](grid);
      }
      console.log(grid[0][8]);
      console.log(grid[1][8]);
      console.log(grid[2][8]);
      console.log(grid[3][8]);
      console.log(grid[4][8]);
      console.log(grid[5][8]);
      update_grid(grid);
    }
    return grid;
  };

  one_to_nine = function() {
    var counter, one_to_nine_array;
    one_to_nine_array = [];
    for (counter = 0; counter <= 8; counter += 1) {
      one_to_nine_array[counter] = counter + 1;
    }
    return one_to_nine_array;
  };

  update_grid = function(grid) {
    var columns, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          if (grid[rows][columns].length === 1) {
            grid[rows][columns] = grid[rows][columns][0];
          }
        }
      }
    }
    return grid;
  };

  solved = function(grid) {
    var columns, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) return false;
      }
    }
    return true;
  };

  output_solved = function(solved) {
    var box_counter, boxes, columns, rows, _results;
    boxes = document.getElementsByTagName("th");
    box_counter = 0;
    _results = [];
    for (rows = 0; rows <= 8; rows += 1) {
      _results.push((function() {
        var _results2;
        _results2 = [];
        for (columns = 0; columns <= 8; columns += 1) {
          boxes[box_counter].innerHTML = solved[rows][columns];
          _results2.push(box_counter++);
        }
        return _results2;
      })());
    }
    return _results;
  };

  row_removing = function(grid) {
    var col_vals, columns, rows;
    console.log("MOTHERFUCKER");
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        console.log(grid[rows][columns]);
        if (Array.isArray(grid[rows][columns])) {
          console.log("PENIS");
          for (col_vals = 0; col_vals <= 8; col_vals += 1) {
            if ((col_vals === columns) || (Array.isArray(grid[rows][col_vals]))) {
              continue;
            }
            grid[rows][columns] = remove_value(grid[rows][col_vals], grid[rows][columns]);
          }
        }
      }
    }
    return grid;
  };

  remove_value = function(val, old_array) {
    var counter, updated_array, _ref;
    console.log("FUCK");
    console.log(old_array);
    updated_array = [];
    for (counter = 0, _ref = old_array.length - 1; counter <= _ref; counter += 1) {
      if (old_array[counter] === val) continue;
      updated_array.push(old_array[counter]);
    }
    console.log(updated_array);
    return updated_array;
  };

}).call(this);
