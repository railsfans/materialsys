Ext.onReady(function() {

			$(".left-menu a:not('.selected')").bind('click', function (e) {
			    Ext.getCmp("work-space").removeAll();
			    e.preventDefault();
			    $(".left-menu a").removeClass("selected");
			    $(this).addClass("selected");
			});
			$(".left-menu a.selected").bind('click', function (e) {
			    e.preventDefault();
			});

            var broswer="";
		    var platform="";	    
		    if(Ext.isIE){ 	
		        if(Ext.isIE6){
		            broswer = "Internet Explorer 6.x"
		        }else if(Ext.isIE7){
		            broswer = "Internet Explorer 7.x"
		        }else if(Ext.isIE8){
		            broswer = "Internet Explorer 8.x"
		        }
		    }else if(Ext.isSafari){
		        if(Ext.isSafari2){
		            broswer = "Safari 2.x"
		        }else if(Ext.isSafari3){
		           broswer = "Safari 3.x"
		        }else if(Ext.isSafari4){
		            broswer = "Safari 4.x"
		        }
		    }else if(Ext.isChrome){
		        broswer = "Chrome"
		    }else if(Ext.isGecko){
		        broswer = "Firefox"
		        if(Ext.isGecko2){
		            broswer = "Firefox 2.x"
		        }else if(Ext.isGecko3){
		            broswer = "Firefox 3.x"
		        }
		    }else if(Ext.isOpera){
		        broswer = "Opera"
		    }else if(Ext.isWebKit){
		        broswer = "WebKit"
		    }else{
		        broswer = "unknown"
		    }    
		    if(Ext.isWindows){
		        platform = "Windows"
		    }else if(Ext.isLinux){
		        platform = "Linux"
		    }else if(Ext.isMac){
		        platform = "Mac OS"
		    }else{
		        broswer = "unknown"
		    }	
		    $("#platform").text(platform);	
		    $("#broswer").text(broswer);
		    
		    Ext.regModel("OrgInfo", {
		    	fields: ['parent_id','name', 'code']
		    });
			var myStore = new Ext.data.TreeStore({
				model : 'OrgInfo',
				nodeParam : 'parent_id', 
				proxy: {
		            type: 'ajax',
		            url: 'code/all.json',
		            reader: 'json'
		        },
				autoLoad: true,
		        root: {
		            name: '',
		            id: 1
		        }
			});
		
			function alertMsg(record)
			{
		        Ext.Ajax.request({
		             url: 'code/list.js',
		             success: function(response){
		                  eval(response.responseText)
		             },
		             failure: function(response){
		                  show_tip_message("false!")
		             },
		             params: { id : record }
		         });
			};
		
    
			var tree_panel = Ext.create('Ext.tree.Panel', {
			    listeners: {
				    'itemclick': function( grid, record, item, index, e, eOpts) {
				        if(record.get('parent_id')!=0 && record.get('parent_id')!=1 && record.get('code').length!=8){
				        alertMsg(record.get('id'));
				      }
				    }
			    },
			    renderTo: 'tree',
			    columns: [{
		  	      xtype: 'treecolumn', 
			        text: '编码列表',
			        dataIndex: 'name',
			        width: 150,
			        sortable: true
			    }, {
			        text: '编码',
			        dataIndex: 'code',
			        flex: 1,
			        sortable: true
			    }],
			    store : myStore,
			    rootVisible: true,
			    border: false,
		        autoScroll : true,
		        containerScroll: true,
	            bodyBorder: false,
	            frame: false
			}); 
    
            tree_panel.on('itemcontextmenu', function(view, record, item, index, event){
                if (record.get('parent_id')==''){
    				var menu1 = new Ext.menu.Menu({
				        items: [{
					                text: '添加类别', iconCls:"silk-user_add", handler: function() {
				                    	user_action_handler("add")
				                    }
				                }],
				         listeners : {
					        'click' : function() {
					           
					        }}
			    	}); 
					    
				    function user_action_handler(type){
				     if(record.get('parent_id')=='' || record.get('parent_id')==1 || record.get('code').length==2)
				     {
			            Ext.Ajax.request({
							    url: 'code/get.js',
							    success: function(response){
			                        	eval(response.responseText)
			                    },
				                failure: function(response) {
				                        show_tip_message("false")
				                    }                
	                	});
	                }
	                else {
	              		alert('无法操作');
	              	}
					}	    
		            menu1.showAt(event.getXY());
		            event.stopEvent();
	            }
                else if (record.get('parent_id')==1){
	             	var menu1 = new Ext.menu.Menu({
				        items: [{
				                text: '添加类别', iconCls:"silk-user_add", handler: function() {
	        						user_action_handler("add")
								}},
				                {
				                text: '编辑当前', iconCls:"silk-user_add", handler: function() {
	        						user_action_handler("edit")
								}},
				             	{
				                text: '删除当前', iconCls:"silk-user_add", handler: function() {
	        						user_action_handler("remove")
								}}],
				         listeners : {
					        'click' : function() {
					           
					        }}
				  	}); 
			    
				    function user_action_handler(type){
				    	if(record.get('parent_id')=='' || record.get('parent_id')==1 || record.get('code').length==2)
				     	{
				            Ext.Ajax.request({
								    url: 'code/get.js',
								    success: function(response){
			                        eval(response.responseText)
				                    },
					                failure: function(response) {
					                        show_tip_message("false")
					                    }                
					                });
		              	}
		              	else {
		              		alert('无法操作');
		              	}
						}
						menu1.showAt(event.getXY());
			            event.stopEvent();
		            }
	            else {
	            	var menu1 = new Ext.menu.Menu({
						items: [{
						        text: '编辑当前', iconCls:"silk-user_add", handler: function() {
	                    			user_action_handler("edit")
	                			}},
						        {
						         text: '删除当前', iconCls:"silk-user_add", handler: function() {
	                    			user_action_handler("remove")
	               			    }}],
				         listeners : {
					        'click' : function() {
					           
					        }}
					}); 
						    
				    function user_action_handler(type){
				   	    if(record.get('parent_id')=='' || record.get('parent_id')==1 || record.get('code').length==2){
	            Ext.Ajax.request({
					    url: 'code/get.js',
					    success: function(response){
			                    eval(response.responseText)
			                },
			            failure: function(response) {
			                    show_tip_message("false")
			                }                
			            });
			            }
			            else {
			              	alert('无法操作');
			            }
						}
			            menu1.showAt(event.getXY());
			            event.stopEvent();
			            }
		    },this);
		    
        Ext.QuickTips.init();
   
        var viewport = Ext.create('Ext.Viewport', {
            id: 'border-example',
            layout: 'border',
            items: [
            Ext.create('Ext.Component', {
                region: 'north',
                height: 32, 
                contentEl: 'header'
            }), {
                region: 'south',
                contentEl: 'footer',
                height: 20,
            }, 
            {
                region: 'west',
                stateId: 'navigation-panel',
                id: 'menu', 
                title: '目录',
                split: true,
                width: 200,
                minWidth: 175,
                maxWidth: 400,
                collapsible: true,
                animCollapse: true,
                margins: '0 0 0 5',
                layout: 'accordion',
                items: [{
                    contentEl: 'repo-management',
                    title:  '物料库存管理',
                    iconCls: 'nav', 
                    autoScroll: true
                }, 
                {
                    title: '物料编码管理',
                    iconCls: 'info',
                    contentEl: 'tree',
                    autoScroll: true
                }, {
                    title: '供应商的管理',
                    iconCls: 'ss',
                    contentEl: 'suppliertree',
                    autoScroll: true
                }, {
                    title: '项目物料管理',
                    iconCls: 'yy',
                    contentEl: 'bom-management',
                    autoScroll: true
                }, {
                	  contentEl: 'user-management',
                    title: '个人信息管理',
                    iconCls: 'settings', 
                    autoScroll: true
                } 
                ]
            },
            {
                region: 'center', 
                id: "work-space",
                border:true,
                layout:"fit",
                items: [     
                 {
                    contentEl: 'home-page',
                    autoScroll: true
                }]
            }]
        });

});
   
