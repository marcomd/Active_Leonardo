// Leonardo
// Use this file to add your javascript

$(document).ready(function() {
    //Add this class to an input form to auto submit on change
    $('.autosubmit').live('change', function() {
      setTimeout("$('#"+this.id+"').parents('form:first').submit();", 300);
      return false;
    });
});