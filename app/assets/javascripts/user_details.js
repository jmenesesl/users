$(document).ready(function() {
  $("#render_table").click(function (e) {
    var tmp =  $('#email').text();
    tmp = tmp.split('@');
    tmp = tmp[0].trim();
    var id =  $('#id_user').val();
    console.log(id);
    var values = {
            'term': tmp,
            'user_id': id
    };
    console.log(values);

    $.ajax({
        url: "relatedUsers",
        type: "GET",
        data: values
    });
    // e.preventDefault();
  });
});
