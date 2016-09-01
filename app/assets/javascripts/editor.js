// editorData is defined in editorData.js

var initialCode = function(functionName, parameters, language) {
  switch (language) {
    case 'javascript':
      return 'var ' + functionName + ' = function(' + parameters.join(', ') + ") {\n};\n";
    case 'python':
      return 'def ' + camelToUnderscore(functionName) + '(' + parameters.map(camelToUnderscore).join(', ') + "):\n";
    case 'ruby':
      return 'def ' + camelToUnderscore(functionName) + '(' + parameters.map(camelToUnderscore).join(', ') + ")\nend\n";
    default:
      throw 'Invalid language for initialCode';
  }
};

var camelToUnderscore = function(stringName) {
  return stringName.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase();
};

var showCodeForLanguage = function(language) {
  $('.language-specific').hide();
  $('.' + language + '-specific').show();
  $("[data-var-camel]").each(function() {
    var variable_name = $(this).data('varCamel');
    if (language === 'python' || language === 'ruby') {
      variable_name = camelToUnderscore(variable_name);
    }
    $(this).text(variable_name);
  });
};

// For now, just put in a textarea if it's iOS because ACE editor is broken
var iOS = function() {
  return /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
};

var setUpEditor = function(questionName, languageSelection, base64InitialCode, base64PreviousStepCode, functionName, parameters) {
  var currentStepCode = atob(base64InitialCode);
  var previousStepCode = atob(base64PreviousStepCode);

  var questionData = editorData[questionName];
  var previousQuestionName = questionData['previousStep'];
  var previousQuestionData = previousQuestionName ? editorData[previousQuestionName] : null;
  languageSelection = languageSelection || 'javascript';
  $('#language-selector').val(languageSelection);
  showCodeForLanguage(languageSelection);

  if (previousStepCode) {
    var value =
      previousStepCode ||
      initialCode(previousQuestionData['functionName'], previousQuestionData['parameters'], languageSelection);
    if (iOS()) {
      $('#previous-code').val(value);
      $('#previous-code').show();
    } else {
      var previousCode = ace.edit("previous-code");
      previousCode.setTheme("ace/theme/iplastic");
      previousCode.getSession().setMode("ace/mode/" + languageSelection);
      previousCode.setOptions({minLines: 1, maxLines: Infinity, highlightActiveLine: false,
                highlightGutterLine: false, highlightSelectedWord: false, autoScrollEditorIntoView:  false});
      previousCode.setReadOnly(true);
      previousCode.$blockScrolling = Infinity;

      previousCode.setValue(value);
      previousCode.clearSelection();
    }
  } else {
    $('#previous-code-container').hide();
  }

  var editorValue = currentStepCode || initialCode(functionName, parameters, languageSelection);
  if (iOS()) {
    $('#code-input').val(editorValue);
    $('#code-input').show();
  } else {
    var editor = ace.edit("code-input");
    editor.setTheme("ace/theme/monokai");

    editor.getSession().setMode("ace/mode/" + languageSelection);
    editor.setOptions({minLines: 20, maxLines: Infinity});
    editor.$blockScrolling = Infinity;

    editor.setValue(editorValue);
    editor.clearSelection();
  }

  $('#language-selector').on('change', function(event) {
    languageSelection = event.target.value;
    var editorValue = initialCode(functionName, parameters, languageSelection);
    if (iOS()) {
      $('#code-input').val(editorValue);
    } else {
      editor.getSession().setMode("ace/mode/" + languageSelection);
      editor.setValue(editorValue);
    }

    showCodeForLanguage(languageSelection);
  });

  // Submitting code
  $('#code-submit').on('click', function() {
    var value = iOS() ? $('#code-input').val() : editor.getValue();

    var token = document.querySelector('meta[name="csrf-token"]').content;

    $.ajax({url: '/submit?authenticity_token=' + encodeURIComponent(token), method: 'POST', data: {code: value, level: $('#level-id').attr('data-id'), language: languageSelection}}).done(
      function(response) {
        if (response['success']) {
          var message = 'The answer is correct!';

          if (questionData['nextURL']) {
            var next_step_word;
            if (questionData['nextURL'].includes('recap')) {
              next_step_word = 'Recap';
            } else {
              next_step_word = 'Next ';
              next_step_word += questionData['endOfLevel'] ? 'Level' : 'Step';
            }
            message += ' <a href="/' + questionData['nextURL'] + '">' + next_step_word + ' </a>';
          } else {
            message += ' More content will be added to the beta later.';
          }

          $('#answer-wrong').hide();

          $('#answer-correct').html(message);
          $('#answer-correct').show();
        } else {
          $('#answer-correct').hide();

          $('#answer-wrong').html(response['error_message']);
          $('#answer-wrong').show();
        }
      }
    ).fail(
      function() {
        $('#answer-wrong').html('There was an error in evaluating the submission.  Please try again later.');
        $('#answer-wrong').show();
      }
    ).always(function() {
      $('#answer-loading').hide();
      $('#code-submit').removeAttr('disabled');
    });

    $('#code-submit').attr('disabled', 'disabled');

    $('#answer-loading').show();
    $('#answer-correct').hide();
    $('#answer-wrong').hide();
  });
};
