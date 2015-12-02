$('.modals').html('<%= j render "payment_modal" %>')
$('.payment-modal').modal
  show: true
  backdrop: true
  keyboard: true

$('[data-toggle="tooltip"]').tooltip
  html: true
