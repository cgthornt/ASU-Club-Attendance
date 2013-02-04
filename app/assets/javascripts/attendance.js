// Show custom input
function toggleManualInput() {
  $("#asurite-completion").toggle();
  $("#user-information").toggle();
}

$(function() {
  // On init, focus!
  $("#asurite").focus();
  
  $(".manual-lookup").click(function() {
    toggleManualInput();
    return false;
  });
  
  $("#asuritefun").submit(function() {
    var statusText = $("#help-text");
    var url        = $(this).data('url') + "?asurite=" + $("#asurite").val();
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
        $("#new_member").submit();
      } else {
        statusText.html("Unable to lookup information with given ASURITE. <a href=\"#\" class=\"manual-lookup\">Enter Manually</a>");
        $("#asurite").attr('disabled', false);
      }
    })
    .error(function() {
      statusText.html("Internal Error. <a href=\"#\" class=\"manual-lookup\">Enter Manually</a>")
      $("#asurite").attr('disabled', false);
    });
    
    
    return false;
  })
  
});