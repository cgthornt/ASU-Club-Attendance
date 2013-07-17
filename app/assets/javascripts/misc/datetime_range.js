// date.js should be included

var fromHiddenSelector = $(".datetime-range-form .from-hidden-field");
var fromDateSelector   = $(".datetime-range-form .date-from");
var fromTimeSelector   = $(".datetime-range-form .time-from");


var toHiddenSelector   = $(".datetime-range-form .to-hidden-field");
var toDateSelector   = $(".datetime-range-form .date-to");
var toTimeSelector   = $(".datetime-range-form .time-to");


function parseDate(dateString) {
  date = new Date(dateString);
  if(date == "Invalid Date")
    return null;
  return date;
}

function autoSetHumanFields(hiddenSelector, dateSelector, timeSelector) {
  time = parseDate(hiddenSelector.val());
  if(time == null) return; // If no time, do nothing
  dateSelector.val(time.toString("MM/dd/yyyy"));
  timeSelector.val(time.toString("hh:mm tt"));
}

function setHiddenFields(hiddenSelector, dateSelector, timeSelector) {
  date = dateSelector.val(); time = timeSelector.val(); // get date and times
  if(!date || !time) { // If date or time is empty, then set the hidden field to be empty
    hiddenSelector.val("");
    return;
  }
  
  // Parse the string
  timestamp = Date.parse(date + " " + time);
  hiddenSelector.val(timestamp.toUTCString());
}

function handleDateOrTimeChange(selector) {
  console.log("Changing!!");
  // Update hidden fields
  parentSelector = selector.closest(".datetime-range-form");
  currentType    = selector.data("type");
    setHiddenFields(
      parentSelector.find('.' + currentType + "-hidden-field"),
      parentSelector.find('.date-' + currentType),
      parentSelector.find('.time-' + currentType));
}

$(function() {
  // Set defaults using JS
  $(".datetime-range-form").each(function(index, element) {
    ele = $(element);
    autoSetHumanFields(ele.find('.from-hidden-field'), ele.find('.date-from'), ele.find('.time-from'))
    autoSetHumanFields(ele.find('.to-hidden-field'), ele.find('.date-to'), ele.find('.time-to'))
  });
  
  // Time Picker

  $(".datetime-range-form .time").timepicker({
    //show24Hours: false,
    //step: 30
  });
  
  $(".datetime-range-form .time").change(function() {
    handleDateOrTimeChange($(this));
  });

  // Date Picker
  $(".datetime-range-form .date").datepicker({
    changeMonth: true,
    changeYear: true,
    onSelect: function(selectedDate) {
      var otherType, otherConstraint, currentType;
      currentType = $(this).data("type");
      if(currentType == "from" ) {
        otherType = "to";
        otherConstraint = "minDate";
      } else {
        otherType = "from"
        otherConstraint = "maxDate";
      }
      parentSelector = $(this).closest(".datetime-range-form");
      otherSelector  = parentSelector.find(".date-" + otherType);
      otherSelector.datepicker("option", otherConstraint, selectedDate);
      handleDateOrTimeChange($(this));
    }
  });
  
  // Update hidden fields
  
  
});