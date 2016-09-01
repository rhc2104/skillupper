// Shows the traversal of a matrix
var matrixAnimation = function(order, idPrefix) {
  var stepDelay = 500;
  var loopDelay = 2000;

  for (var i in order) {
    var func = function(x) {
      setTimeout(
        function(){$('#' + idPrefix + '-' + order[x]).css('background-color', '#CCCCCC')},
        stepDelay * x
      );
    };
    func(i);
  }

  var restart = function() {
    for (var i in order) {
      $('#' + idPrefix + '-' + order[i]).css('background-color', '#fffbf7');
    }
    matrixAnimation(order, idPrefix);
  }

  setTimeout(restart, (stepDelay * order.length) + loopDelay);
}
