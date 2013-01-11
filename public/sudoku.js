(function() {
  var box_possibilities, box_range, box_removing, box_repeats, box_solve, column_possibilities, column_removing, column_repeats, grid_clone, guess, guess_to_solve, has_changed, has_contradiction, one_to_nine, output_contradiction, output_solved, remove_value, row_possibilities, row_removing, row_repeats, solve, solved, unique_box_possibility, unique_column_possibility, unique_row_possibility, update_grid, zero_possibilities;

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
    var b, columns, create_grid, get_inputs, grid, inputs, row1, row2, row3, row4, row5, row6, row7, row8, row9, rows, solved;
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
    b = one_to_nine();
    grid = [];
    row1 = [b, b, b, 2, b, b, b, 6, 3];
    row2 = [3, b, b, b, b, 5, 4, b, 1];
    row3 = [b, b, 1, b, b, 3, 9, 8, b];
    row4 = [b, b, b, b, b, b, b, 9, b];
    row5 = [b, b, b, 5, 3, 8, b, b, b];
    row6 = [b, 3, b, b, b, b, b, b, b];
    row7 = [b, 2, 6, 3, b, b, 5, b, b];
    row8 = [5, b, 3, 7, b, b, b, b, 8];
    row9 = [4, 7, b, b, b, 1, b, b, b];
    grid = [row1, row2, row3, row4, row5, row6, row7, row8, row9];
    solved = solve(grid);
    if (solved === false) output_contradiction();
    return output_solved(solved);
  };

  solve = function(grid) {
    var grid_snapshot, rounds_without_updates, solve, solvers, _ref;
    rounds_without_updates = 0;
    solvers = [row_removing, column_removing, box_removing, row_possibilities, column_possibilities, box_possibilities];
    while (solved(grid) === false) {
      grid_snapshot = grid_clone(grid);
      if (has_contradiction(grid)) return false;
      for (solve = 0, _ref = solvers.length - 1; solve <= _ref; solve += 1) {
        grid = solvers[solve](grid);
        grid = update_grid(grid);
        if (has_changed(grid_snapshot, grid)) break;
      }
      if (has_changed(grid_snapshot, grid) === false) {
        rounds_without_updates++;
      } else {
        rounds_without_updates = 0;
      }
      if (rounds_without_updates === 4) grid = guess(grid);
    }
    return grid;
  };

  one_to_nine = function() {
    var fuck, one_to_nine_array;
    one_to_nine_array = [];
    for (fuck = 0; fuck <= 8; fuck += 1) {
      one_to_nine_array[fuck] = fuck + 1;
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

  output_contradiction = function() {
    var message;
    message = document.getElementById('messages');
    return message.innerHTML = "EPIC FAIL! Your sudoku puzzle is impossible to solve. Click refresh to get a new sudoku board and check to make sure that you entered your sudoku puzzle correctly";
  };

  row_removing = function(grid) {
    var col_vals, columns, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
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
    updated_array = [];
    for (counter = 0, _ref = old_array.length - 1; counter <= _ref; counter += 1) {
      if (old_array[counter] === val) continue;
      updated_array.push(old_array[counter]);
    }
    return updated_array;
  };

  column_removing = function(grid) {
    var columns, row_vals, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          for (row_vals = 0; row_vals <= 8; row_vals += 1) {
            if ((row_vals === rows) || (Array.isArray(grid[row_vals][columns]))) {
              continue;
            }
            grid[rows][columns] = remove_value(grid[row_vals][columns], grid[rows][columns]);
          }
        }
      }
    }
    return grid;
  };

  box_removing = function(grid) {
    var columns, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          grid = box_solve(grid, rows, columns);
        }
      }
    }
    return grid;
  };

  box_solve = function(grid, rows, columns) {
    var column_count, column_range, row_count, row_range, _i, _j, _len, _len2, _step, _step2;
    row_range = box_range(rows);
    column_range = box_range(columns);
    for (_i = 0, _len = row_range.length, _step = 1; _i < _len; _i += _step) {
      row_count = row_range[_i];
      for (_j = 0, _len2 = column_range.length, _step2 = 1; _j < _len2; _j += _step2) {
        column_count = column_range[_j];
        if (((row_count === rows) && (column_count === columns)) || Array.isArray(grid[row_count][column_count])) {
          continue;
        }
        grid[rows][columns] = remove_value(grid[row_count][column_count], grid[rows][columns]);
      }
    }
    return grid;
  };

  box_range = function(position) {
    if ((position >= 0) && (position <= 2)) {
      return [0, 1, 2];
    } else if ((position >= 3) && (position <= 5)) {
      return [3, 4, 5];
    } else {
      return [6, 7, 8];
    }
  };

  row_possibilities = function(grid) {
    var columns, possible_val, rows, _i, _len, _ref, _step;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          _ref = grid[rows][columns];
          for (_i = 0, _len = _ref.length, _step = 1; _i < _len; _i += _step) {
            possible_val = _ref[_i];
            grid = unique_row_possibility(grid, rows, columns, possible_val);
            if (Array.isArray(grid[rows][columns]) === false) break;
          }
        }
      }
    }
    return grid;
  };

  unique_row_possibility = function(grid, rows, columns, possible_val) {
    var col_vals, only_possible_place, other_possible_val, _i, _len, _ref;
    only_possible_place = true;
    for (col_vals = 0; col_vals <= 8; col_vals += 1) {
      if (col_vals === columns) continue;
      if (Array.isArray(grid[rows][col_vals]) === false) {
        if (grid[rows][col_vals] === possible_val) only_possible_place = false;
        continue;
      }
      _ref = grid[rows][col_vals];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        other_possible_val = _ref[_i];
        if (other_possible_val === possible_val) only_possible_place = false;
      }
    }
    if (only_possible_place === true) grid[rows][columns] = possible_val;
    return grid;
  };

  column_possibilities = function(grid) {
    var columns, possible_val, rows, _i, _len, _ref, _step;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          _ref = grid[rows][columns];
          for (_i = 0, _len = _ref.length, _step = 1; _i < _len; _i += _step) {
            possible_val = _ref[_i];
            grid = unique_column_possibility(grid, rows, columns, possible_val);
            if (Array.isArray(grid[rows][columns]) === false) break;
          }
        }
      }
    }
    return grid;
  };

  unique_column_possibility = function(grid, rows, columns, possible_val) {
    var only_possible_place, other_possible_val, row_vals, _i, _len, _ref;
    only_possible_place = true;
    for (row_vals = 0; row_vals <= 8; row_vals += 1) {
      if (row_vals === rows) continue;
      if (Array.isArray(grid[row_vals][columns]) === false) {
        if (grid[row_vals][columns] === possible_val) only_possible_place = false;
        continue;
      }
      _ref = grid[row_vals][columns];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        other_possible_val = _ref[_i];
        if (other_possible_val === possible_val) only_possible_place = false;
      }
    }
    if (only_possible_place === true) grid[rows][columns] = possible_val;
    return grid;
  };

  box_possibilities = function(grid) {
    var columns, possible_val, rows, _i, _len, _ref, _step;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          _ref = grid[rows][columns];
          for (_i = 0, _len = _ref.length, _step = 1; _i < _len; _i += _step) {
            possible_val = _ref[_i];
            grid = unique_box_possibility(grid, rows, columns, possible_val);
          }
          if (Array.isArray(grid[rows][columns] === false)) break;
        }
      }
    }
    return grid;
  };

  unique_box_possibility = function(grid, rows, columns, possible_val) {
    var column_count, column_range, only_possible_place, other_possible_val, row_count, row_range, _i, _j, _k, _len, _len2, _len3, _ref, _step, _step2, _step3;
    only_possible_place = true;
    row_range = box_range(rows);
    column_range = box_range(columns);
    for (_i = 0, _len = row_range.length, _step = 1; _i < _len; _i += _step) {
      row_count = row_range[_i];
      for (_j = 0, _len2 = column_range.length, _step2 = 1; _j < _len2; _j += _step2) {
        column_count = column_range[_j];
        if ((row_count === rows) && (column_count === columns)) continue;
        if (Array.isArray(grid[row_count][column_count]) === false) {
          if (grid[row_count][column_count] === possible_val) {
            only_possible_place = false;
          }
          continue;
        }
        _ref = grid[row_count][column_count];
        for (_k = 0, _len3 = _ref.length, _step3 = 1; _k < _len3; _k += _step3) {
          other_possible_val = _ref[_k];
          if (other_possible_val === possible_val) only_possible_place = false;
        }
      }
    }
    if (only_possible_place === true) grid[rows][columns] = possible_val;
    return grid;
  };

  has_contradiction = function(grid) {
    var check_contradictions, columns, con_exists, counter, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        check_contradictions = [zero_possibilities, row_repeats, column_repeats, box_repeats];
        for (counter = 0; counter <= 3; counter += 1) {
          con_exists = check_contradictions[counter](grid, rows, columns);
          if (con_exists === true) return true;
        }
      }
    }
    return false;
  };

  zero_possibilities = function(grid, rows, columns) {
    if ((Array.isArray(grid[rows][columns])) && (grid[rows][columns].length === 0)) {
      return true;
    }
    return false;
  };

  row_repeats = function(grid, rows, columns) {
    var column_vals;
    if (Array.isArray(grid[rows][columns]) === false) {
      for (column_vals = 0; column_vals <= 8; column_vals += 1) {
        if ((column_vals === columns) || (Array.isArray(grid[rows][column_vals]))) {
          continue;
        }
        if (grid[rows][column_vals] === grid[rows][columns]) return true;
      }
    }
    return false;
  };

  column_repeats = function(grid, rows, columns) {
    var row_vals;
    if (Array.isArray(grid[rows][columns]) === false) {
      for (row_vals = 0; row_vals <= 8; row_vals += 1) {
        if ((row_vals === rows) || (Array.isArray(grid[row_vals][columns]))) {
          continue;
        }
        if (grid[row_vals][columns] === grid[rows][columns]) return true;
      }
    }
    return false;
  };

  box_repeats = function(grid, rows, columns) {
    var column_count, column_range, row_count, row_range, _i, _j, _len, _len2, _step, _step2;
    if (Array.isArray(grid[rows][columns]) === false) {
      row_range = box_range(rows);
      column_range = box_range(columns);
      for (_i = 0, _len = row_range.length, _step = 1; _i < _len; _i += _step) {
        row_count = row_range[_i];
        for (_j = 0, _len2 = column_range.length, _step2 = 1; _j < _len2; _j += _step2) {
          column_count = column_range[_j];
          if (((row_count === rows) && (column_count === columns)) || (Array.isArray(grid[row_count][column_count]))) {
            continue;
          }
          if (grid[row_count][column_count] === grid[rows][columns]) return true;
        }
      }
    }
    return false;
  };

  has_changed = function(grid_snapshot, grid) {
    var columns, rows;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if ((Array.isArray(grid_snapshot[rows][columns])) && (Array.isArray(grid[rows][columns]) === false)) {
          return true;
        }
      }
    }
    return false;
  };

  guess = function(grid) {
    var columns, lowest_column, lowest_length, lowest_row, rows;
    lowest_length = 10;
    lowest_row;
    lowest_column;
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns]) === false) continue;
        if (grid[rows][columns].length < lowest_length) {
          lowest_row = rows;
          lowest_column = columns;
          lowest_length = grid[rows][columns].length;
        }
        if (lowest_length === 2) break;
      }
      if (lowest_length === 2) break;
    }
    return guess_to_solve(grid, lowest_row, lowest_column);
  };

  guess_to_solve = function(grid, lowest_row, lowest_column) {
    var possibilities, temporary_grid, _i, _len, _ref, _step;
    _ref = grid[lowest_row][lowest_column];
    for (_i = 0, _len = _ref.length, _step = 1; _i < _len; _i += _step) {
      possibilities = _ref[_i];
      temporary_grid = grid_clone(grid);
      temporary_grid[lowest_row][lowest_column] = grid[lowest_row][lowest_column][possibilities];
      temporary_grid = solve(temporary_grid);
      if (temporary_grid !== false) {
        grid = temporary_grid;
        break;
      }
    }
    if (temporary_grid === false) return false;
    return grid;
  };

  grid_clone = function(grid) {
    var clone, columns, possibilities, rows, _i, _len, _ref, _step;
    clone = [[], [], [], [], [], [], [], [], []];
    for (rows = 0; rows <= 8; rows += 1) {
      for (columns = 0; columns <= 8; columns += 1) {
        if (Array.isArray(grid[rows][columns])) {
          clone[rows][columns] = [];
          _ref = grid[rows][columns];
          for (_i = 0, _len = _ref.length, _step = 1; _i < _len; _i += _step) {
            possibilities = _ref[_i];
            clone[rows][columns][possibilities] = grid[rows][columns][possibilities];
          }
        } else {
          clone[rows][columns] = grid[rows][columns];
        }
      }
    }
    return clone;
  };

}).call(this);
