// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require hubspot/tether.min.js
//= require hubspot/drop.min.js
//= require moment.min.js
//= require_tree .
//= require_self


$(document).ready(function(){
	// var accountSwicher;

	// accountSwicher = new Drop({
	//   target: document.querySelector('.account-switcher'),
	//   content: 'Welcome to the future!',
	//   position: 'bottom left',
	//   openOn: 'click'
	// });


	$('tbody.rowlink').rowlink();
	$('.chosen-select').chosen({allow_single_deselect: true});
	$('.rangepicker').daterangepicker({opens: 'left', applyClass: 'btn-info'});
	$('.tooltip-it').tooltip({placement: 'top', trigger: 'hover'})
	$('[data-numeric]').payment('restrictNumeric');

	// SEARCH
	$(document).on('click', '.filter-donations', function(){
		$('.table').toggleClass('show-filters');
	});

	$('.rangepicker').on('apply.daterangepicker', function(ev, picker) {
	  $('.table-responsive form').submit();
	});

	$(document).on("change, keyup", ".table-input", function(){
		$('.table-responsive form').submit();
	});

	$(document).on("change", ".table-filter", function(){
		$('.table-responsive form').submit();
	});
});


$(document).on('click', '.handle', function(){
	$(this).parent().toggleClass('open');
});
