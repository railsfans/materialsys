//********************************   警告提示信息    **************************************//
Ext.QuickTips.init();
function show_tip_message(message){
    Ext.Msg.show({
        title: '提示',
        msg: message,
        icon: Ext.Msg.INFO,
        minWidth: 200,
        maxWidth:300,
        buttons: Ext.Msg.OK
    });
}
