var exerciseId = "1";
var chapterId = "1";

function submit() {
    startLoading();
    
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if (req.responseText != null && req.responseText != "") {
          var jsonText = req.responseText;
          var jsonData = JSON.parse(jsonText);

          var resultDiv = document.getElementById("resultDiv");

          // update the status
          if (jsonData["status"] == 0) {
            resultDiv.innerHTML = '<span style="color:#FF3300;">Not yet :)</span>';
          } else {
            resultDiv.innerHTML = '<span style="color:#00CC00;">Done!</span>';

            // replace the submit button with a next exercise button
            var submitTd = document.getElementById("submit");
            submitTd.innerHTML = '<button onclick="nextExercise()">Next exercise</button>';
          }
          
          var testsDiv = document.getElementById("testsDiv");

          testsDiv.innerHTML = jsonData["tests"];

          stopLoading();
        }
    }

    req.open("GET", "http://127.0.0.1:1337/api/eval/" + chapterId + "/" + exerciseId, true);
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

    req.open("GET", "http://127.0.0.1:1337/api/nextExercise/" + chapterId + "/" + exerciseId, true);
    req.send();
}

function startLoading() {
  document.getElementById("ajax-loading").innerHTML = '<img src="ajax-loader.gif"/>';
}

function stopLoading() {
  document.getElementById("ajax-loading").innerHTML = '';
}

