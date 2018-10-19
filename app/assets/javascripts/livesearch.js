(function($) {
  $.searchbox = {}

  $.extend(true, $.searchbox, {
    settings: {
        url: 'search',
        param: 'search',
        dom_id: '#livesearch',
        minChars: 2,
        loading_css: '#livesearch_loading',
        del_id: '#livesearch_del'
    },

    loading: function() {
        $($.searchbox.settings.loading_css).show()
    },

    idle: function() {
        $($.searchbox.settings.loading_css).hide()
    },

    start: function() {
      $.searchbox.loading()
      $(document).trigger('before.searchbox')
    },

    stop: function() {
      $.searchbox.idle()
      $(document).trigger('after.searchbox')
    },

    kill: function() {
        $($.searchbox.settings.dom_id).fadeOut(50)
        $($.searchbox.settings.dom_id).html('')
        $($.searchbox.settings.del_id).fadeOut(100)
    },

    reset: function() {
        $($.searchbox.settings.dom_id).html('')
        $($.searchbox.settings.dom_id).fadeOut(50)
        $('#SearchSearch').val('')
        $($.searchbox.settings.del_id).fadeOut(100)
    },

    process: function(terms) {

        if(/\S/.test(terms)) {
            $.ajax({
                    type: 'GET',
                    url:  $.searchbox.settings.url,
                    data: {search: terms.trim()},
                    complete: function(data) {
                        $($.searchbox.settings.del_id).fadeIn(50)
                        $($.searchbox.settings.dom_id).html(data.responseText)

                        if (!$($.searchbox.settings.dom_id).is(':empty')) {
                            $($.searchbox.settings.dom_id).fadeIn(100)
                        }

                        $.searchbox.stop();
                    }
                });
            return false;
        }else{
            $.searchbox.kill();
        }
    }
  });



    $.fn.searchbox = function(config) {
        var settings = $.extend(true, $.searchbox.settings, config || {})

        $(document).trigger('init.searchbox')
        $.searchbox.idle()

        return this.each(function() {
            var $input = $(this)

            $input
            .keyup(function() {
                if ($input.val() != this.previousValue) {

                    if(/\S/.test($input.val().trim()) &&  $input.val().trim().length > $.searchbox.settings.minChars){
                        $.searchbox.start()
                        $.searchbox.process($input.val())
                    }else{
                        $.searchbox.kill()
                    }

                    this.previousValue = $input.val()

                }
            })
        })
    }
})(jQuery);
