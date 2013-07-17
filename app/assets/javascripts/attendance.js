
var originalHelpText;

// Show custom input
function toggleManualInput() {
  // ASU completion is visible, so show manual
  if(!$("#asurite-completion").hasClass('asurite-completion-away')) {
    $("#asurite-completion").hide();
    $("#user-information").show();
    $("#member_first_name").focus();

  // Manual is shown, so show automatic
  } else {

    $("#user-information").hide();
    $("#asurite-completion").show();
    $("#help-text").html(originalHelpText);
    enableManualLookup($('#help-text .manual-lookup'));
    $("#asurite").focus();
  }

  $("#asurite-completion").toggleClass('asurite-completion-away');
}

function enableManualLookup(ele) {
  if(!ele) ele = $('.manual-lookup');
  ele.click(function() {
    $("#help-text").html('<span>&nbsp;</span>');
    toggleManualInput();
    return false;
  });
}

$(function() {

  originalHelpText = $("#help-text").html();
  // Save orig text HTML.
  // originalHelpText = $("#help-text").html(); //$("#help-text").html();

  // On init, focus!
  $("#asurite").focus();

  enableManualLookup();

  $("#asuritefun").submit(function() {
    var asurite = $("#asurite").val();


    var statusText = $("#help-text");
    var url        = $(this).data('url') + "?asurite=" + asurite;
    var origStatus = statusText.html();
    statusText.html("Loading...");
    $("#asurite").attr('disabled', true);
    
    jqxhr = $.getJSON(url, function(data) {
      if(data['success']) {  // Successful data is successful; update forms
        statusText.html("Submitting...");
        user = data['data'];
        $("#member_first_name").val(user['first_name']);
        $("#member_last_name").val(user['last_name']);
        $("#member_email").val(user['email']);
        $("#member_asurite").val(user['asurite']);
        $("#new_member").submit();
      } else {

        str = 'Unable to lookup information with given ASURITE or email.<br>' +
              'Fill out this form and use this email in the future to sign in.';

        statusText.html(str);
        $("#member_email").val(asurite);
        $("#asurite").attr('disabled', false);
        // enableManualLookup();
        toggleManualInput();
      }
    })
    .error(function() {
      statusText.html("Internal Error. <a href=\"#\" class=\"manual-lookup\">Enter Manually</a>")
      $("#asurite").attr('disabled', false);
    });
    
    
    return false;
  })
  
});