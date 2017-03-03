$(document).ready(function(){
  $('.date').datepicker({
      format: 'yyyy-mm-dd',
      orientation: "auto",
      autoclose: true,
      todayHighlight: true,
  });
  $('.input-daterange input').each(function() {
    $(this).datepicker('clearDates');
  });
})
