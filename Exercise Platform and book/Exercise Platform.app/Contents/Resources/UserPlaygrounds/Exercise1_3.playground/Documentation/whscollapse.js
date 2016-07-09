$(function() {
  var toggleButton = function(button) {
    var text = button.text()
    
    if (text.indexOf('[+]') > -1) {
      text = text.replace('[+]', '[-]');
    } else {
      text = text.replace('[-]', '[+]');
    }

    button.text(text);

    button.blur();
    button.removeClass('active')
  }

  $('.collapse-container').each(function(index) {
    var container = $(this);
    var button = container.find('.btn');

    var content = container.find('.collapse');

    content.on('show.bs.collapse', function() {
      toggleButton(button);
    });

    content.on('hide.bs.collapse', function() {
      toggleButton(button);
    });
  });
});