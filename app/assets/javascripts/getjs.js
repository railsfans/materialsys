$(".left-menu a:not('.selected')").bind('click', function (e) {

    Ext.getCmp("work-space").removeAll();

    Ext.Ajax.request({

        url: $(this).attr("href"),

        method: "POST",

           success: function(response){
                   //     show_tip_message("success");
                        eval(response.responseText)
                    },

        failure: function(response){

            show_tip_message("failure!")

        }

    });

    $(".left-menu a").removeClass("selected");

    $(this).addClass("selected");

});

$(".left-menu a.selected").bind('click', function (e) {
    Ext.Msg.alert('tips','success');
    e.preventDefault();

});
