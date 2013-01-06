(function() {

  window.draw = function() {
    var boxes, i, _ref, _results;
    boxes = document.getElementsByTagName("th");
    _results = [];
    for (i = 0, _ref = boxes.length - 1; i <= _ref; i += 1) {
      _results.push(boxes[i].innerHTML = '<select class="input">\
                <option value="blank"></option>\
                <option value="1">1</option>\
                <option value="2">2</option>\
                <option value="3">3</option>\
                <option value="4">4</option>\
                <option value="5">5</option>\
                <option value="6">6</option>\
                <option value="7">7</option>\
                <option value="8">8</option>\
                <option value="9">9</option>\
              </select>');
    }
    return _results;
  };

  window.solve = function() {
    var boxes, i, inputs, results, _ref, _ref2, _results;
    boxes = document.getElementsByTagName("th");
    inputs = document.getElementsByClassName("input");
    results = [];
    for (i = 0, _ref = boxes.length - 1; i <= _ref; i += 1) {
      results[i] = inputs[i].options[inputs[i].selectedIndex].value;
    }
    _results = [];
    for (i = 0, _ref2 = boxes.length - 1; i <= _ref2; i += 1) {
      _results.push(boxes[i].innerHTML = results[i]);
    }
    return _results;
  };

}).call(this);
