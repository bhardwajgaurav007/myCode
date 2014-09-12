<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="java.util.List" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.Set" %>
<%@ page
	import="com.radaptive.rdpv.admin.model.Account,com.radaptive.common.UserPrincipal,com.radaptive.rdpv.common.util.SecurityUtil,com.radaptive.common.DateUtils,com.radaptive.common.StringUtil"%>
<%@ page import="com.radaptive.rdpv.common.util.PropertyReader" %>

<%
String index_action=(String)session.getAttribute("INDEX_ACTION");

String role_inActive=(String)session.getAttribute("ROLE_INACTIVE");
String group_inActive=(String)session.getAttribute("GROUP_INACTIVE");
String timeZoneOffset=(String)session.getAttribute("USER_TIME_ZONE_ID_PREF");
if(timeZoneOffset != null){
 if(timeZoneOffset.contains("-")) {
	timeZoneOffset = "-"+(timeZoneOffset.split("-")[1]);
} else if(timeZoneOffset.contains("+")) {
	timeZoneOffset = "+"+(timeZoneOffset.substring(timeZoneOffset.indexOf("+")+1,timeZoneOffset.length()));
} else {
	timeZoneOffset ="0";
}
}
	String contextPath = request.getContextPath();
	String windowCss = "theme2_demo1.css";
	Boolean navigationStyle = (Boolean)session.getAttribute("isPopup");
	String displayMode = (String)session.getAttribute("ticketDisplayMode");
	String currentApplication = (String)session.getAttribute("currentApplication");
	String userAgent = request.getHeader("user-agent");
	UserPrincipal principal = SecurityUtil.getLoggedInUserDetails();
	String accountName = principal.getUserName();
	String isOnlyApiUser = principal.getAccount().getIsOnlyApiUser();
	if(!StringUtil.isEmptyString(isOnlyApiUser) && isOnlyApiUser.equals("true")){
		response.sendRedirect("/logout/logout.action?method=logOut");
	}
	String imClientNeeded = PropertyReader.getInstance().getPropertyFromFile("IMCLIENT_SERVER","imclient.needed");
	String imServerURL = null;
	 if(imClientNeeded != null && "true".equalsIgnoreCase(imClientNeeded)){
		 imClientNeeded="true";
		imServerURL = PropertyReader.getInstance().getPropertyFromFile("IMCLIENT_SERVER","lightstreamer.server.url");
	 }
	
    String licenseWarning = PropertyReader.getInstance().getPropertyFromFile("LICENSE_PARAM", "license.warn.expiry"); 
    String eastPanelNeeded = PropertyReader.getInstance().getPropertyFromFile("EAST_PANEL", "eastPanelNeeded");
	 
	String jasperServiceNeeded = PropertyReader.getInstance().getPropertyFromFile("JASPER_SERVER","jasper.service.needed");
	/*String jasperServerURL = null;
	if(jasperServiceNeeded != null && "true".equalsIgnoreCase(jasperServiceNeeded)){
		jasperServiceNeeded = "true";
		String jasperServerIP = PropertyReader.getInstance().getPropertyFromFile("JASPER_SERVER","jasper.server.ip");
		String jasperServerPort = PropertyReader.getInstance().getPropertyFromFile("JASPER_SERVER","jasper.server.port");
		if(StringUtil.isEmptyString(jasperServerPort)) {
			jasperServerURL = "http://"+jasperServerIP+"/jasperserver-pro";
		} else {
			jasperServerURL = "http://"+jasperServerIP+":"+jasperServerPort+"/jasperserver-pro";
		}		
	}*/
	
	String javascriptVersion = PropertyReader.getInstance().getPropertyFromFile("APPLICATION_DEPLOYMENT","javascript.version");
	String mainLogoFileName = PropertyReader.getInstance().getPropertyFromFile("Logo","main.logo.image");
	String languageCode = "";
	String countryCode = "";
	if(SecurityUtil.getLoggedInAccount() != null && SecurityUtil.getLoggedInAccount().getLocale() != null){
    	languageCode = SecurityUtil.getLoggedInAccount().getLocale().getLanguageCode();
    	countryCode = SecurityUtil.getLoggedInAccount().getLocale().getCountryCode();
    	if(languageCode.equalsIgnoreCase("ta")){
    		mainLogoFileName = mainLogoFileName.trim();
        	if(mainLogoFileName.contains(".gif")){
        		mainLogoFileName = mainLogoFileName.split(".gif")[0] + "_" + languageCode + ".gif";
        	}
    	}
    }

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<%
out.println("<div align='center' id='loadingContainer' style='display:block;overflow: hidden;vertical-align: middle'>");
out.println("<table style='position:absolute;top:45%;left:45%;'><tr><td><img src='"); %><%= contextPath%><%out.println("/9159/images/loading-main.gif'/></td></tr></table>");
out.println("</div>");
%>

	<head>
		<link rel="stylesheet" type="text/css" href="<%= contextPath %>/9159/newext/examples/shared/example.css" />
		
		<script type="text/javascript" src="<%= contextPath %>/9159/newui/script/jquery/jquery.js"></script>
		
		    <script type="text/javascript" src="/9159/newext/examples/shared/include-ext.js"></script>
    <script type="text/javascript" src="/9159/newext/examples/shared/options-toolbar.js"></script>
    <script type="text/javascript" ></script>



    <style type="text/css">
        .x-panel-body p {
            margin: 10px;
            font-size: 12px;
        }
    </style>
		
		
</head>

<body>
<script type="text/javascript" >



Ext.require([
             'Ext.tab.*',
             'Ext.window.*',
             'Ext.tip.*',
             'Ext.layout.container.Border'
         ]);
         
         
Ext.define('User', {
    extend: 'Ext.data.Model',
    fields: [ 'Description', 'Data Form', 'phone' ]
});

	var userStore=Ext.create('Ext.data.Store', {
	    model: 'User',
	 remoteSort:true,
	    autoLoad: true,
	    listeners: {
	        beforeload: function(store, operation, eOpts){
	        	//console.dir(store.sorters.getAt(0)._direction);
	        	//console.dir(operation._sorters);
	        	//console.dir(eOpts);
	            if(store.sorters && store.sorters.getCount())
	            {
	            
	                var sorter = store.sorters.getAt(0);
	            	alert(sorter._property+"==="+sorter._direction);
	                store.getProxy().extraParams = {
	                    'sort'  : sorter._property,
	                    'dir'   :sorter._direction
	                };
	            }
	        }
	},
	    pageSize: 2,
	    proxy: {
	        type: 'ajax',
	        url : 'grid/radaptiveGrid.action?method=showExtSecuredGrid&isForm=false&title=Manage Data&gridName=MANAGE_DATA&gridHeight=449&gridWidth=1161',
	        reader: {
	            type: 'json',
	            root: 'results',
	            totalProperty: 'total'
	        }
	    }
	});
	
	
	
	
         Ext.onReady(function(){
             
            	

        	 showPanel();
         
        	 setTimeout(function(){showWindow()}, 1000);
         
         
         
         
         });




function showWindow(){
	
	
	var win,
    button = Ext.get('show-btn');

button.on('click', function(){

    if (!win) {
        win = Ext.create('widget.window', {
            title: 'Layout Window with title <em>after</em> tools',
            header: {
                titlePosition: 2,
                titleAlign: 'center'
            },
            closable: true,
            closeAction: 'hide',
            maximizable: true,
            animateTarget: button,
            width: 600,
            minWidth: 350,
            height: 350,
            tools: [{type: 'pin'}],
            layout: {
                type: 'border',
                padding: 5
            },
            items: [{
                region: 'west',
                title: 'Navigation',
                width: 200,
                split: true,
                collapsible: true,
                floatable: false
            }, {
                region: 'center',
                xtype: 'tabpanel',
                items: [{
                    // LTR even when example is RTL so that the code can be read
                    rtl: false,
                    title: 'Bogus Tab',
                    html: '<p>Window configured with:</p><pre style="margin-left:20px"><code>header: {\n    titlePosition: 2,\n    titleAlign: "center"\n},\nmaximizable: true,\ntools: [{type: "pin"}],\nclosable: true</code></pre>'
                }, {
                    title: 'Another Tab',
                    html: 'Hello world 2'
                }, {
                    title: 'Closable Tab',
                    html: 'Hello world 3',
                    closable: true
                }]
            }]
        });
    }
    button.dom.disabled = true;
    if (win.isVisible()) {
        win.hide(this, function() {
            button.dom.disabled = false;
        });
    } else {
        win.show(this, function() {
            button.dom.disabled = false;
        });
    }
});


}
         
         
  
   function showDataGrid(){
	   
	   Ext.create('Ext.grid.Panel', {
   	    renderTo: Ext.getBody(),
   	    selType: 'rowmodel',
   	    
   	    plugins: [
   	        Ext.create('Ext.grid.plugin.RowEditing', {
   	            clicksToEdit: 1
   	        })
   	],
   	 dockedItems: [{
   	        xtype: 'pagingtoolbar',
   	        store: userStore,   // same store GridPanel is using
   	        dock: 'bottom',
   	        displayInfo: true
   	    }],
   	    store: userStore,
   	    width: 600,
   	    height: 200,
   	    title: 'Application Users',
   	    columns: [
   	        {
   	            text: 'Description',
   	            width: 100,
   	            sortable: true,
   	            hideable: false,
   	            dataIndex: 'Description'
   	           
   	        },
   	        {
   	            text: 'Email Address',
   	            width: 150,
   	            dataIndex: 'email',
   	            hidden: true
   	        },
   	        {
   	            text: 'Phone Number',
   	            flex: 1,
   	            dataIndex: 'Data Form'
   	        }
   	    ]
   	});   



	   
	   
   }      
         
         
         

function rowEditing(){
	
	
	 Ext.define('Employee', {
	        extend: 'Ext.data.Model',
	        fields: [
	            'name',
	            'email',
	            { name: 'start', type: 'date', dateFormat: 'n/j/Y' },
	            { name: 'salary', type: 'float' },
	            { name: 'active', type: 'bool' }
	        ]
	    });

	    // Generate mock employee data
	    var data = (function() {
	        var lasts = ['Jones', 'Smith', 'Lee', 'Wilson', 'Black', 'Williams', 'Lewis', 'Johnson', 'Foot', 'Little', 'Vee', 'Train', 'Hot', 'Mutt'],
	            firsts = ['Fred', 'Julie', 'Bill', 'Ted', 'Jack', 'John', 'Mark', 'Mike', 'Chris', 'Bob', 'Travis', 'Kelly', 'Sara'],
	            lastLen = lasts.length,
	            firstLen = firsts.length,
	            usedNames = {},
	            data = [],
	            eDate = Ext.Date,
	            now = new Date(),
	            s = new Date(now.getFullYear() - 4, 0, 1),
	            end = Ext.Date.subtract(now, Ext.Date.MONTH, 1),
	            getRandomInt = Ext.Number.randomInt,

	            generateName = function() {
	                var name = firsts[getRandomInt(0, firstLen - 1)] + ' ' + lasts[getRandomInt(0, lastLen - 1)];
	                if (usedNames[name]) {
	                    return generateName();
	                }
	                usedNames[name] = true;
	                return name;
	            };

	        while (s.getTime() < end) {
	            var ecount = getRandomInt(0, 3);
	            for (var i = 0; i < ecount; i++) {
	                var name = generateName();
	                data.push({
	                    start : eDate.add(eDate.clearTime(s, true), eDate.DAY, getRandomInt(0, 27)),
	                    name : name,
	                    email: name.toLowerCase().replace(' ', '.') + '@sencha-test.com',
	                    active: getRandomInt(0, 1),
	                    salary: Math.floor(getRandomInt(35000, 85000) / 1000) * 1000
	                });
	            }
	            s = eDate.add(s, eDate.MONTH, 1);
	        }

	        return data;
	    })();

	    // create the Data Store
	    var store = Ext.create('Ext.data.Store', {
	        // destroy the store if the grid is destroyed
	        autoDestroy: true,
	        model: 'Employee',
	        proxy: {
	            type: 'memory'
	        },
	        data: data,
	        sorters: [{
	            property: 'start',
	            direction: 'DESC'
	        }]
	    });

	    var rowEditing = Ext.create('Ext.grid.plugin.RowEditing', {
	        clicksToMoveEditor: 1,
	        autoCancel: false
	    });

	    // create the grid and specify what field you want
	    // to use for the editor at each column.
	    var grid = Ext.create('Ext.grid.Panel', {
	        store: store,
	        columns: [{
	            header: 'Name',
	            dataIndex: 'name',
	            flex: 1,
	            editor: {
	                // defaults to textfield if no xtype is supplied
	                allowBlank: false
	            }
	        }, {
	            header: 'Email',
	            dataIndex: 'email',
	            width: 160,
	            editor: {
	                allowBlank: false,
	                vtype: 'email'
	            }
	        }, {
	            xtype: 'datecolumn',
	            header: 'Start Date',
	            dataIndex: 'start',
	            width: 135,
	            editor: {
	                xtype: 'datefield',
	                allowBlank: false,
	                format: 'm/d/Y',
	                minValue: '01/01/2006',
	                minText: 'Cannot have a start date before the company existed!',
	                maxValue: Ext.Date.format(new Date(), 'm/d/Y')
	            }
	        }, {
	            xtype: 'numbercolumn',
	            header: 'Salary',
	            dataIndex: 'salary',
	            format: '$0,0',
	            width: 130,
	            editor: {
	                xtype: 'numberfield',
	                allowBlank: false,
	                minValue: 1,
	                maxValue: 150000
	            }
	        }, {
	            xtype: 'checkcolumn',
	            header: 'Active?',
	            dataIndex: 'active',
	            width: 60,
	            editor: {
	                xtype: 'checkbox',
	                cls: 'x-grid-checkheader-editor'
	            }
	        }],
	        renderTo: 'editor-grid',
	        width: 700,
	        height: 400,
	        title: 'Employee Salaries',
	        frame: true,
	        tbar: [{
	            text: 'Add Employee',
	            iconCls: 'employee-add',
	            handler : function() {
	                rowEditing.cancelEdit();

	                // Create a model instance
	                var r = Ext.create('Employee', {
	                    name: 'New Guy',
	                    email: 'new@sencha-test.com',
	                    start: Ext.Date.clearTime(new Date()),
	                    salary: 50000,
	                    active: true
	                });

	                store.insert(0, r);
	                rowEditing.startEdit(0, 0);
	            }
	        }, {
	            itemId: 'removeEmployee',
	            text: 'Remove Employee',
	            iconCls: 'employee-remove',
	            handler: function() {
	                var sm = grid.getSelectionModel();
	                rowEditing.cancelEdit();
	                store.remove(sm.getSelection());
	                if (store.getCount() > 0) {
	                    sm.select(0);
	                }
	            },
	            disabled: true
	        }],
	        plugins: [rowEditing],
	        listeners: {
	            'selectionchange': function(view, records) {
	                grid.down('#removeEmployee').setDisabled(!records.length);
	            }
	        }
	    });
	
	
	
}






function showPanel(){

	
	var mygriddd=Ext.create('Ext.grid.Panel', {
   	    
   	    
   	    plugins: [
   	        Ext.create('Ext.grid.plugin.RowEditing', {
   	            clicksToEdit: 1
   	        })
   	],
   	 dockedItems: [{
   	        xtype: 'pagingtoolbar',
   	        store: userStore,   // same store GridPanel is using
   	        dock: 'bottom',
   	        displayInfo: true
   	    }],
   	    store: userStore,
   	   
   	    title: 'Application Users',
   	    columns: [
   	        {
   	            text: 'Description',
   	            width: 100,
   	            sortable: true,
   	            hideable: false,
   	            dataIndex: 'Description'
   	           
   	        },
   	        {
   	            text: 'Email Address',
   	            width: 150,
   	            dataIndex: 'email',
   	            hidden: true
   	        },
   	        {
   	            text: 'Phone Number',
   	            flex: 1,
   	            dataIndex: 'Data Form'
   	        }
   	    ]
   	});   
	
	
	var treeStore=Ext.create('Ext.data.TreeStore', {
		   

	    root: {
	        text: 'Ext JS',
	        expanded: true,
	        children: [
	            {
	                text: 'app',
	                children: [
	                    { leaf:true, text: 'Application.js' }
	                ]
	            },
	            {
	                text: 'button',
	                expanded: true,
	                children: [
	                    { leaf:true, text: 'Button.js' },
	                    { leaf:true, text: 'Cycle.js' },
	                    { leaf:true, text: 'Split.js' }
	                ]
	            },
	            {
	                text: 'container',
	                children: [
	                    { leaf:true, text: 'ButtonGroup.js' },
	                    { leaf:true, text: 'Container.js' },
	                    { leaf:true, text: 'Viewport.js' }
	                ]
	            },
	            {
	                text: 'core',
	                children: [
	                    {
	                        text: 'dom',
	                        children: [
	                            { leaf:true, text: 'Element.form.js' },
	                            { leaf:true, text: 'Element.static-more.js' }
	                        ]
	                    }
	                ]
	            },
	            {
	                text: 'dd',
	                children: [
	                    { leaf:true, text: 'DD.js' },
	                    { leaf:true, text: 'DDProxy.js' },
	                    { leaf:true, text: 'DDTarget.js' },
	                    { leaf:true, text: 'DragDrop.js' },
	                    { leaf:true, text: 'DragDropManager.js' },
	                    { leaf:true, text: 'DragSource.js' },
	                    { leaf:true, text: 'DragTracker.js' },
	                    { leaf:true, text: 'DragZone.js' },
	                    { leaf:true, text: 'DragTarget.js' },
	                    { leaf:true, text: 'DragZone.js' },
	                    { leaf:true, text: 'Registry.js' },
	                    { leaf:true, text: 'ScrollManager.js' },
	                    { leaf:true, text: 'StatusProxy.js' }
	                ]
	            },
	            {
	                text: 'core',
	                children: [
	                    { leaf:true, text: 'Element.alignment.js' },
	                    { leaf:true, text: 'Element.anim.js' },
	                    { leaf:true, text: 'Element.dd.js' },
	                    { leaf:true, text: 'Element.fx.js' },
	                    { leaf:true, text: 'Element.js' },
	                    { leaf:true, text: 'Element.position.js' },
	                    { leaf:true, text: 'Element.scroll.js' },
	                    { leaf:true, text: 'Element.style.js' },
	                    { leaf:true, text: 'Element.traversal.js' },
	                    { leaf:true, text: 'Helper.js' },
	                    { leaf:true, text: 'Query.js' }
	                ]
	            },
	            { leaf:true, text: 'Action.js' },
	            { leaf:true, text: 'Component.js' },
	            { leaf:true, text: 'Editor.js' },
	            { leaf:true, text: 'Img.js' },
	            { leaf:true, text: 'Layer.js' },
	            { leaf:true, text: 'LoadMask.js' },
	            { leaf:true, text: 'ProgressBar.js' },
	            { leaf:true, text: 'Shadow.js' },
	            { leaf:true, text: 'ShadowPool.js' },
	            { leaf:true, text: 'ZIndexManager.js' }
	        ]
	    }
	});
	
	
	
	var treee=Ext.create('Ext.tree.Panel', {
	    
	    title: 'Simple Tree',
	    width: 300,
	    height: 250,
	    rootVisible: false,
	    store:treeStore,
	    listeners: {
	    	itemclick : function(tree, record, item, index, e,options) {
	    		  
	    		var isParent=record.data.leaf;  
	    		 if(isParent) {
	    		var nodeText = record.data.text,
	    		tabPanel = viewport.items.get(1),
	    		tabBar = tabPanel.getTabBar(),

	    		//not allow to create multiple Tab
	    		tabIndex;
	    		//for ( var i = 0; i<tabBar.items.length; i++) {
	    		//if (tabBar.items.get(i).getText() === nodeText) {
	    		//tabIndex = i;
	    		//}
	    		//}
	    		//not allow to create multiple Tab

	    		if(Ext.isEmpty(tabIndex)) {
	    		var lengthTabbar=tabBar.items.length;

	    			
	    		tabPanel.add({
	    		title :record.data.text,
	    		bodyPadding : 10,
	    		id:'panel'+lengthTabbar,
	    		closable: !!true,
	    		//html :getTabHtml(record.data.text,record.data)
	    		items:getFileHtml(record.data.text,record.data,lengthTabbar+"id") 

	    		});
	    		tabIndex = tabPanel.items.length - 1;
	    		}
	    		tabPanel.setActiveTab(tabIndex);


	    		}
	    		//getDynamicHtml(tabPanel);
	    		}
	    }
	});	
	
	
	
	
	
	
	
	
	
	
	
	 var windowheight= window.innerHeight;
	  var windowwidth=window.innerWidth;
	  
	var panel = Ext.create('Ext.panel.Panel', {

	 
	    xtype: 'layout-border',
	  renderTo: 'editor-grid',
	    requires: [
	        'Ext.layout.container.Border'
	    ],
	    layout: 'border',
	    width: windowwidth-50,
	    height: window.innerHeight,

	    bodyBorder: false,
	    
	    defaults: {
	        collapsible: true,
	        split: true,
	        bodyPadding: 10
	    },

	    items: [
	        {
	        	maximizable: true,
	            title: 'Footer',
	            region: 'east',
	            height: windowheight,
	            minHeight: 75,
	           
	            html: '<input type="button" id="show-btn" value="Layout Window"/><br/><br/>'
	        },
	        {
	            title: 'Navigation',
	            region:'west',
	            floatable: false,
	            margin: '5 0 0 0',
	            width: 125,
	            minWidth: 100,
	            maxWidth: 250,
	            items: treee
	        },
	        {
	            title: 'Main Content',
	            collapsible: false,
	            region: 'center',
	            margin: '5 0 0 0',
	            items:mygriddd
	        }
	    ]

	});
	
	
	
}





</script>

<div id="editor-grid"></div>
</body>

</html>

