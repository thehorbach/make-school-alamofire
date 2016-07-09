var exerciseId = "0"
var chapterId = "0"

function showNextExerciseButton() {
  var button = document.getElementById("nextExercise");
  button.style.display = "inline-block";
}

function resizeTable() {

  try {
    var totalWidth = 0;

    var table = document.getElementById('runTable');

    var row = table.rows[0];

    var maxWidth = 300;
    var maxWidthIndices = [];

    var widths = [];

    for (var j = 0, col; col = row.cells[j]; j++) {

       var width = col.offsetWidth;

       totalWidth += width;

       if (width == maxWidth) {
          maxWidthIndices.push(j);
       }

       widths.push(width);
    }  

    var tableWidth = table.offsetWidth;
    var divWidth = document.getElementById('resultDiv').offsetWidth;


    var updateWidths = false

    if (totalWidth > tableWidth || (totalWidth < divWidth && maxWidthIndices.length > 0)) {
      updateWidths = true;

      if (totalWidth < divWidth) {
        tableWidth = divWidth;
      }

      newWidth = (tableWidth - (totalWidth - maxWidthIndices.length * maxWidth)) / maxWidthIndices.length;

      for (var i in maxWidthIndices) {
        widths[maxWidthIndices[i]] = newWidth;
      }

    }


    if (updateWidths == false) {
      return;
    }

    for (var i = 0, row; row = table.rows[i]; i++) {
       for (var j = 0, col; col = row.cells[j]; j++) {
          col.style.maxWidth = String(widths[j]) + "px";
       }  
    }

  }
  catch(err) {
  }


}

function submit() {
    startLoading();

    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if (req.responseText != null && req.responseText != "") {
          var jsonText = req.responseText;
          var jsonData = JSON.parse(jsonText);

          var resultDiv = document.getElementById("resultDiv");

          var tests = jsonData["tests"];

          tests = tests.replace(/EMOJI_CORRECT/g, '✅');
          tests = tests.replace(/EMOJI_INCORRECT/g, '❌');

          resultDiv.innerHTML = tests

          Prism.highlightAll();

          // update the status
          if (jsonData["status"] == 0) {
            showFailure(jsonData["message"])
          } else {
            showSuccess()
            showNextExerciseButton()
          }

          stopLoading();

          resizeTable();
        }
    }

    req.open("POST", "http://127.0.0.1:1337/api/eval/" + chapterId + "/" + exerciseId, true);
    req.send();
}

function nextExercise() {
    startLoading();
    
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if (req.responseText != null && req.responseText != "") {
          var jsonText = req.responseText;
          var jsonData = JSON.parse(jsonText);

          stopLoading();
        }
    }

    req.open("POST", "http://127.0.0.1:1337/api/nextExercise/" + chapterId + "/" + exerciseId, true);
    req.send();
}

function getExerciseInfo() {
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {

        if (req.responseText != null && req.responseText != "") {
          var jsonText = req.responseText;
          var jsonData = JSON.parse(jsonText);

          if (jsonData["solved"] == true) {
            showNextExerciseButton()
          }
        }
    }

    req.open("POST", "http://127.0.0.1:1337/api/exerciseStatus/" + chapterId + "/" + exerciseId, true);
    req.send();
}

function openPDF() {
    var req = new XMLHttpRequest();

    req.open("POST", "http://127.0.0.1:1337/api/openPDF/" + chapterId, true);
    req.send();
}

// function startLoading() {
//   var spinner = '<div id="floatingBarsG"><div class="blockG" id="rotateG_01"></div><div class="blockG" id="rotateG_02"></div><div class="blockG" id="rotateG_03"></div><div class="blockG" id="rotateG_04"></div><div class="blockG" id="rotateG_05"></div><div class="blockG" id="rotateG_06"></div><div class="blockG" id="rotateG_07"></div><div class="blockG" id="rotateG_08"></div></div>'

//   document.getElementById("ajax-loading").innerHTML = spinner
// }

function startLoading() {
  document.getElementById("ajax-loading").innerHTML = '<img src="ajax-loader.gif" width="16" height="16" class="spinner"/>';
}

function stopLoading() {
  document.getElementById("ajax-loading").innerHTML = '';
}

function showAlert(message,type,emoji) {
  var cls = "alert ";
  if (type == "Success") {
    cls += "alert-success";
  }
  if (type == "Failure") {
    cls += "alert-danger";
  }

  var messageHTML = message + " " + '<span class="emoji">' + emoji + "</span>";

  var html = '<div class="' + cls + '" role="alert">' + messageHTML + '</div>';

  document.getElementById("alert").innerHTML = html;
}

function hideAlert() {
  document.getElementById("alert").innerHTML = ''; 
}

function sample(array) {
  return array[Math.floor(Math.random()*array.length)];
}

function showSuccess() {

  var emojis = ['😀', '😃', '😄', '😉', '😎', '😸', '😆', '😊', '😺'];

  var successMessages = ["Correct!", 
                         "Success!", 
                         "Well done!", 
                         "Keep going!", 
                         "The force is strong with this one.",
                         "Bazinga!"];

  showAlert(sample(successMessages),"Success",sample(emojis));
}

function showFailure(message) {

  if (message == null || message.length == 0) {

    var failureMessages = ["Not yet.", 
                           "Keep trying.", 
                           "Incorrect.",
                           "This doesn't seem right.",
                           "Some test cases failed."];

    message = sample(failureMessages);
  }

  var emojis = ['😶', '😓', '😐', '😢', '😞', '😕', '😬', '😖', '😒'];

  showAlert(message,"Failure",sample(emojis));
}

window.onload = function() {
  exerciseId = document.getElementById("exerciseId").value;
  chapterId = document.getElementById("chapterId").value;
  getExerciseInfo();

};
