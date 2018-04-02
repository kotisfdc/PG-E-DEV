({
    fetchNotification : function(component, event, helper) {
        debugger;
        component.set("v.onetimeload",true);
        component.set("v.toggleSpinner", true);
        var action = component.get("c.fetchNotifications");
        //var action = component.get("c.getNotificationRec");
        var fieldSetValues = component.get("v.fieldSetValues");
        var setfieldNames = new Set();
        for(var i = 0; i< fieldSetValues.length ; i++)
            setfieldNames.add(fieldSetValues[i].name);
        
        var arrfieldNames = [];
        setfieldNames.forEach(v => arrfieldNames.push(v));
        action.setParams
        ({
            "sObjectName": component.get("v.sObjectName"),
            "criteriafield": component.get("v.criteriafield"),
            "conatcIds": component.get("v.contactIds"),
            "userConfigRec": component.get("v.userConfigRec"),
            "fieldNameJson": JSON.stringify(arrfieldNames),
            "idWrapperStr": component.get('v.idWrapper'),
            "federationid" : component.get('v.FedIDs')
        });
        
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS'){
                debugger;
                component.set('v.Notificationdetails', response.getReturnValue());
                var data = response.getReturnValue();
                var dataa = response.getReturnValue();
                var condata = JSON.parse(dataa);
                component.set('v.gridData',condata);
            }
            else
            {
                console.log('failed')
            }
            helper.dataGridBuilder(component, event, helper, component.get('v.gridData'),component.get('v.portfoliofields'),component.get('v.viewname'));
            component.set("v.toggleSpinner", false);
            
        });
        $A.enqueueAction(action);
        
    },
    
    
    dataGridBuilder :function(component, event, helper, condata,portfoliofields,viewname){
        component.set("v.onetimeload",false);
        var columnsList = [];
        var coldataportfolio = [];
        if(portfoliofields != null && portfoliofields.length > 0){
            for(var i = 0 ;i<portfoliofields.length; i++){
                if(portfoliofields[i].name.indexOf('__c') == -1) {
                    if(portfoliofields[i].label != "ZIAFS"){
                        debugger;
                        coldataportfolio.push({
                            dataField: portfoliofields[i].name,
                            caption: portfoliofields[i].label,
                            order: portfoliofields[i].order,
                            cellTemplate: function(element, info) {                    
                                var lkn = '';
                                if(info.column.dataField == "Name"){
                                    lkn = '<a href="'+$A.get("$Label.c.JO_LinkUrl") + info.data.Id + '/view" target="_blank">' + info.text + '</a>';
                                }
                                else {
                                    var temp = (info.column.dataField.split(".").length > 1 ?  info.column.dataField.split(".")[0] : '');
                                    //lkn = '<a href="/one/one.app#/sObject/' + info.data.Id + '/view" target="_blank">' + info.text + '</a>';
                                    lkn = '<a href="'+$A.get("$Label.c.JO_LinkUrl") + (info.data[temp] != null ? info.data[temp]["Id"] : '') + '/view" target="_blank">' + info.text + '</a>';
                                }
                                element.append(lkn).css("color", "blue");    
                                headerFilter: {
                                    allowSearch: false
                                }
                            }
                        });
                    }
                }
                else
                {
                    coldataportfolio.push({
                        dataField: portfoliofields[i].name,
                        caption: portfoliofields[i].label,
                        order: portfoliofields[i].order,
                        headerFilter: {
                            allowSearch: true
                        }
                    });
                }
            }
        }
        var fieldSetValues = component.get("v.fieldSetValues");
        for(var i = 0; i< fieldSetValues.length ; i++){
         debugger;            
            if(fieldSetValues[i].name.indexOf('__c') == -1) {
                debugger;
                columnsList.push({
                    dataField: fieldSetValues[i].name,
                    caption: fieldSetValues[i].label,
                    order: fieldSetValues[i].order,
                    cellTemplate: function(element, info) {                        
                        var lkn = '';
                        if(info.column.dataField == "Name"){
                            lkn = '<a href="'+$A.get("$Label.c.JO_LinkUrl") + info.data.Id + '/view" target="_blank">' + info.text + '</a>';
                        }
                       else {
                            var temp = (info.column.dataField.split(".").length > 1 ?  info.column.dataField.split(".")[0] : '');
                            
                            lkn = '<a href="'+$A.get("$Label.c.JO_LinkUrl") + (info.data[temp] != null ? info.data[temp]["Id"] : '') + '/view" target="_blank">' + info.text + '</a>';
                            //lkn = '<a href="/one/one.app#/sObject/' + info.data.Id + '/view" target="_blank">' + info.text + '</a>';
                            
                        }
                        element.append(lkn).css("color", "blue");    
                        headerFilter: {
                            allowSearch: false
                        }
                    }
                });
            }
           else {
                columnsList.push({
                    dataField: fieldSetValues[i].name,
                    caption: fieldSetValues[i].label,
                    order: fieldSetValues[i].order,
                    //fixed: true,
                    //minWidth: 200,
                    headerFilter: {
                        allowSearch: true
                    }
                });
            }
            
        }
        
        // for to display ZIAFS
        columnsList.push({
            dataField: "Name",
            caption: "ZIAFS",
            allowFiltering: false,
            alignment: "center",
            cellTemplate: function(element, info) {
                //debugger;
                if( info.text != ""){
                    var span = $('<span><div class="btn"></div></span>');
                    span.find('.btn').dxButton({
                        icon: 'globe',
                        onClick: function (e) {
                            window.open($A.get("$Label.c.JO_Znotif_Url") + info.text+$A.get("$Label.c.JO_Znotif_Url_Sufix"));
                            //$A.get("$Label.c.ZOrder ") + info.text
                        }
                    });
                    span.appendTo(element);           
                    headerFilter: {
                        allowSearch: false
                    }
                }
            }
        });
        //for to display ZOrder
        columnsList.push({
            dataField: "Notification_Order__r.Name",
            caption: "ZOrder",
            alignment: "center",
            allowFiltering: false,
            cellTemplate: function(element, info) {
                //  debugger;
                if( info.text != ""){
                    var span = $('<span><div class="btn"></div></span>');
                    span.find('.btn').dxButton({
                        icon: 'globe',
                        onClick: function (e) {
                            debugger;
                            window.open($A.get("$Label.c.JO_ZOrder_URL") + info.text+$A.get("$Label.c.JO_Zorder_Url_Sufix"));
                            //$A.get("$Label.c.ZOrder") + info.text
                        }
                    });
                    span.appendTo(element);           
                    headerFilter: {
                        allowSearch: false
                    }
                }
                
            }
        });
        var portdisabled,portname,iconname;
        
        
        /* Added code for Tab panel */
        
        if(coldataportfolio.length > 0)
        {
            portdisabled = false;
            iconname = "comment";
            portname = viewname+" ("+condata.length+")";
        }
        else
        {
            portdisabled = true;
            portname = "";
            iconname = "";
        }
      
        var tab = [
            {     
                id: 0,
                text: "Notifications",
                icon: "user", 
                columns: columnsList,
                data: condata
                
            },
            { 
                id: 1,
                text: "Order Operations", 
               
                columns: columnsList,
                data: condata
                //disabled: portdisabled
            }
        ];
        var tabs = [
            {     
                id: 0,
                text: $A.get("$Label.c.JO_TabName")+" ("+condata.length+")",
                icon: "user", 
                columns: columnsList,
                data: condata
                
            },
            { 
                id: 1,
                text: portname, 
                icon: iconname, 
                columns: coldataportfolio,
                data: condata,
                disabled: portdisabled
            }
        ];
        var headerTemplate = function (header, info) {
            $('<div>').html(info.column.caption).css('font-weight', 'bold').appendTo(header);
        };
        debugger;
        var dataGrid;
        //if($("#gridContainer").data("dxDataGrid") == undefined){
        dataGrid = $("#gridContainer").dxDataGrid({
            dataSource: condata,
            allowColumnReordering: true,
            allowColumnResizing: true,
            columnAutoWidth: true,
            showColumnLines: true,
            showRowLines: true,
            rowAlternationEnabled: true,
            showBorders: true,
            wordWrapEnabled: false,
            noDataText: "No Data Found",
            "export": {
                enabled: true,
                fileName: "PortfolioView",
                allowExportSelectedData: false
            },
            groupPanel: {
                visible: false
            },
            columnChooser: {
                enabled: false
            },
            columnFixing: { 
                enabled: true
            },
            filterRow: {
                visible: false,
                applyFilter: "auto"
            },
            searchPanel: {
                visible: false,
                width: 240,
                placeholder: "Search..."
            },
            headerFilter: {
                visible: true
            },
            
            pager: {
                showPageSizeSelector: true,
                allowedPageSizes: [5, 10, 20, 30],
                showInfo: true
            },
            columns: columnsList,
            customizeColumns: function (columns) {
                $.each(columns, function (_, element) {
                    element.headerCellTemplate = headerTemplate;
                });
            },
        }).dxDataGrid("instance");
        if(columnsList.length > 0)
        {
            for(var v in columnsList)
            {
                $("#gridContainer").dxDataGrid("columnOption", columnsList[v].caption, "visibleIndex", parseInt(columnsList[v].order)-1);
            }
        }
        var tabsInstance = $("#tabs > .tabs-container").dxTabs({
            dataSource: tabs,
            selectedItem: tabs[0],
            showNavButtons: true,
            onItemClick: function(e) {
                debugger;
                
                var indexno = e.itemIndex;
                var dataGrid = $("#gridContainer").dxDataGrid({
                    dataSource: tabs[e.itemIndex].data,
                    allowColumnReordering: true,
                    allowColumnResizing: true,
                    columnAutoWidth: true,
                    showColumnLines: true,
                    showRowLines: true,
                    rowAlternationEnabled: true,
                    showBorders: true,
                    wordWrapEnabled: false,
                    noDataText: "No Data Found",
                    "export": {
                        enabled: true,
                        fileName: "PortfolioView",
                        allowExportSelectedData: false
                    },
                    groupPanel: {
                        visible: false
                    },
                    columnChooser: {
                        enabled: false
                    },
                    columnFixing: { 
                        enabled: true
                    },
                    filterRow: {
                        visible: false,
                        applyFilter: "auto"
                    },
                    searchPanel: {
                        visible: false,
                        width: 240,
                        placeholder: "Search..."
                    },
                    headerFilter: {
                        visible: true
                    },
                    pager: {
                        showPageSizeSelector: true,
                        allowedPageSizes: [5, 10, 20, 30],
                        showInfo: true
                    },
                    
                    columns: tabs[e.itemIndex].columns,
                    customizeColumns: function (columns) {
                        $.each(columns, function (_, element) {
                            element.headerCellTemplate = headerTemplate;
                        });
                    },
                }).dxDataGrid("instance");
                if(e.itemIndex == 1)
                {
                    for(var v in tabs[e.itemIndex].columns)
                    {
                        $("#gridContainer").dxDataGrid("columnOption", tabs[e.itemIndex].columns[v].caption, "visibleIndex", parseInt(tabs[e.itemIndex].columns[v].order)-1);
                    }
                }
                else if(e.itemIndex == 0)
                {
                    for(var v in tabs[e.itemIndex].columns)
                    {
                        $("#gridContainer").dxDataGrid("columnOption", tabs[e.itemIndex].columns[v].caption, "visibleIndex", parseInt(tabs[e.itemIndex].columns[v].order)-1);
                    }
                    $("#gridContainer").dxDataGrid("columnOption", columnsList.length-2, "visibleIndex", 2);
                    $("#gridContainer").dxDataGrid("columnOption", columnsList.length-1, "visibleIndex", 3);
                }
            }
        }).dxTabs("instance");
        /*if(event.getParams() != undefined  && event.getType() != "aura:valueInit" && event.getType() != "ltng:afterScriptsLoaded"){
            debugger;
            if($("#gridContainer").data("dxDataGrid") != undefined){
                $("#gridContainer").data("dxDataGrid").clearFilter();
                
                var paramsall = event.getParams().notificationIds;
                var params = paramsall == null ? null : (paramsall[0] == undefined ? paramsall : paramsall[0]) ;
                if(params != null && params.status != undefined && params.status.length > 0) {
                    $("#gridContainer").dxDataGrid("filter", [
                        ["Notification_Order__r.OrderStatus__c", "=", params.status[0]],
                        "or",
                        [[ "Notification_Status__c", "=", params.status[0]],["Notification_Order__r.Name", "=",null]]
                    ]);
                }
                else if(params != null && params.notifyNo != undefined &&  params.notifyNo.length > 0) {
                    var sizel  = params.notifyNo.length;
                    var fltrLst = [];
                    for(var fltr in params.notifyNo){
                        fltrLst.push(['Name', '=', [params.notifyNo[fltr]]]);
                        if(sizel > 1){
                            sizel -= 1;
                            fltrLst.push('or');
                        }
                    }
                    if($("#gridContainer").data("dxDataGrid") != undefined && fltrLst != undefined)
                        $("#gridContainer").dxDataGrid("filter",fltrLst);
                }                 
                    else if(params != null && params.orderNo != undefined &&  params.orderNo.length > 0) {
                        var sizel  = params.orderNo.length;
                        var fltrLst = [];
                        for(var fltr in params.orderNo){
                            fltrLst.push(['Notification_Order__r.Name', '=', [params.orderNo[fltr]]]);
                            if(sizel > 1){
                                sizel -= 1;
                                fltrLst.push('or')
                            }                    
                        }
                        if($("#gridContainer").data("dxDataGrid") != undefined && fltrLst != undefined)
                            $("#gridContainer").dxDataGrid("filter",fltrLst);                
                    }  
                        else if(params != null && params.status != undefined && params.status.length == 0 && params.notifyNo != undefined &&  params.notifyNo.length == 0 && params.orderNo != undefined &&  params.orderNo.length == 0)
                        {
                            var fltrLst = [];
                            fltrLst.push(['Name', '=', '']);
                            if($("#gridContainer").data("dxDataGrid") != undefined && fltrLst != undefined)
                                $("#gridContainer").dxDataGrid("filter",fltrLst);
                        }
            }
        }
        */
        $("#gridContainer").dxDataGrid("columnOption", columnsList.length-2, "visibleIndex", 2);
        $("#gridContainer").dxDataGrid("columnOption", columnsList.length-1, "visibleIndex", 3);
        
        $("#gridContainer").dxDataGrid({
            
            dataSource: {
                store: condata,
            },
            keyExpr: "ID",
            masterDetail: 
            {
                enabled: true,
                template: function(container, options)
                { 
                    
                    var currentEmployeeData = options.data;
                   
                    $("<div>")
                    .dxTabs({
                        dataSource: tab,
                        selectedItem: tab[0],
                        showNavButtons: true,
                        onItemClick: function(e) {
                            debugger;
                            
                            var indexno = e.itemIndex;
                            var dataGrid = $("#gridContainer").dxDataGrid({
                                dataSource: tab[e.itemIndex].data,
                                allowColumnReordering: true,
                                allowColumnResizing: true,
                                columnAutoWidth: true,
                                showColumnLines: true,
                                showRowLines: true,
                                rowAlternationEnabled: true,
                                showBorders: true,
                                wordWrapEnabled: false,
                                noDataText: "No Data Found",
                                "export": {
                                    enabled: true,
                                    fileName: "PortfolioView",
                                    allowExportSelectedData: false
                                },
                                groupPanel: {
                                    visible: false
                                },
                                columnChooser: {
                                    enabled: false
                                },
                                columnFixing: { 
                                    enabled: true
                                },
                                filterRow: {
                                    visible: false,
                                    applyFilter: "auto"
                                },
                                searchPanel: {
                                    visible: false,
                                    width: 240,
                                    placeholder: "Search..."
                                },
                                headerFilter: {
                                    visible: true
                                },
                                pager: {
                                    showPageSizeSelector: true,
                                    allowedPageSizes: [5, 10, 20, 30],
                                    showInfo: true
                                },
                                
                                columns: tab[e.itemIndex].columns,
                                customizeColumns: function (columns) {
                                    $.each(columns, function (_, element) {
                                        element.headerCellTemplate = headerTemplate;
                                    });
                                },
                            }).dxDataGrid("instance");
                            if(e.itemIndex == 1)
                            {
                                for(var v in tab[e.itemIndex].columns)
                                {
                                    $("#gridContainer").dxDataGrid("columnOption", tab[e.itemIndex].columns[v].caption, "visibleIndex", parseInt(tab[e.itemIndex].columns[v].order)-1);
                                }
                            }
                            else if(e.itemIndex == 0)
                            {
                                for(var v in tab[e.itemIndex].columns)
                                {
                                    $("#gridContainer").dxDataGrid("columnOption", tab[e.itemIndex].columns[v].caption, "visibleIndex", parseInt(tab[e.itemIndex].columns[v].order)-1);
                                }
                                $("#gridContainer").dxDataGrid("columnOption", columnsList.length-2, "visibleIndex", 2);
                                $("#gridContainer").dxDataGrid("columnOption", columnsList.length-1, "visibleIndex", 3);
                            }
                        }
                    })
                    .appendTo(container);
                    /* $("<div>")
                    .addClass("master-detail-caption")
                    .text(currentEmployeeData.Name + "'s Notifications:")
                    .appendTo(container);*/
                
                    $("<div>")
                    .dxDataGrid({
                    /*dataField: fieldSetValues[i].name,
                    caption: fieldSetValues[i].label,
                    order: fieldSetValues[i].order,*/
                    columnAutoWidth: true,
                    showBorders: true,
                   columns: [
                        {
                            dataField: "Name",
                            caption: "Notification Name",
                            dataType: "text"
                        },
                        {
                            dataField: "NotificationType__c",
                            caption: "Type",
                            dataType: "Picklist"
                        }, {
                            dataField: "Notification_Order__c",
                            caption: "Order",
                            dataType: "Lookup"
                        },{
                            dataField: "Owner.Name",
                            caption: "Job Owner",
                            dataType: "Lookup"
                        }, {
                            dataField: "Notification_Status__c",
                            caption: "Notification Status",
                            dataType: "Picklist"
                        },{
                            dataField: "Notification_Order__r.OrderStatus__c",
                            caption: "Order Status",
                            dataType: "Picklist"
                        }    
                        
                        /*"Priority", {
                            caption: "Completed",
                            dataType: "boolean",
                            calculateCellValue: function(rowData) {
                                return rowData.Status == "Completed";
                            }
                        }*/],
                        dataSource: (currentEmployeeData.Notifications__r != null ? currentEmployeeData.Notifications__r.records : '')
                    }).appendTo(container);
                }
           }
        });
    }
})