// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require pagy
window.addEventListener("turbolinks:load", Pagy.init);
$(document).ready(function() {
  $("#form_search input").on('keydown', function (e) {
    if ( e.which == 13 ) return false;
  });
    $("#form_search input").on('keyup', function (e) {
      var wordFind = $("#search input").value;
       var input = $("<input>").attr("type", "hidden").attr("name", "usertype").val($( "#select_usertype option:selected" ).text());
      $("#form_search").append(input);
      $.get($("#form_search").attr("action"), $("#form_search").serialize(), null, "script");
      // return false;
    });
    $("#form_dropdown select").on('change', function (e) {
      $("#buscador").val(null);
      $.get($("#form_dropdown").attr("action"), $("#form_dropdown").serialize(), null, "script");
      return false;
    });
});
