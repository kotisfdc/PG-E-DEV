({
    MethodfromAccounttocontact : function(component, event,helper) {
        debugger;
        var action = component.get("c.getAccountdetails");
        action.setCallback(this, function(a) {
            var data = a.getReturnValue();
            component.set('v.Accountdetails', a.getReturnValue());
            var dataa = a.getReturnValue();
            var accdata = JSON.parse(dataa);
            console.log(accdata);
            debugger;
            var clms = [{
                dataField: "Name",
                caption: "Account Name",
                width: 200,
            },
                        {
                            dataField: "Industry",
                            caption: "Industry",
                            width: 130,
                        },
                        {
                            dataField: "AnnualRevenue",
                            alignment: "right",
                            format: "currency",
                            width: 150,
                        },
                        {
                            caption: "Fax",
                            dataField: "Fax",
                            width: 150,
                        },
                        {
                            caption: "Phone",
                            dataField: "Phone",
                            width: 150,
                        },
                        {
                            dataField: "AccountNumber",
                            caption: "Account Number",
                            width: 130,
                        },
                        {
                            dataField: "NumberOfEmployees",
                            caption: "Number Of Employees",
                            width: 130,
                        },
                        {
                            dataField: "SLAExpirationDate__c",
                            caption: "SLA Expiration Date",
                            alignment: "right",
                            dataType: "date",
                            width: 150,
                           
                        },
                        {
                            caption: "Rating",
                            dataField: "Rating",
                        }];
          
            var dataGrid = $("#gridContainer").dxDataGrid({
                dataSource: {
                    store: accdata,
                },
                sorting: {
                    mode: "multiple"
                },
                columnAutoWidth: true,
                filterRow: {
                    visible: true,
                    applyFilter: "auto"
                },
                pager: {
                    showPageSizeSelector: true,
                    allowedPageSizes: [5, 10, 20]
                },
               keyExpr: "Id",
                columns: clms,
                masterDetail: {
                    enabled: true,
                    template: function(container, options) { 
                        var currentEmployeeData = options.data;
                        
                        $("<div>")
                        .addClass("master-detail-caption")
                        .text(currentEmployeeData.Name + "'s Contacts :")
                        .appendTo(container);
                        
                        $("<div>")
                        .dxDataGrid({
                            columnAutoWidth: true,
                            showBorders: true,
                            columns: ["Name","Email", {
                                dataField: "Birthdate",
                                dataType: "date"
                            }, {
                                dataField: "Phone",
                                dataType: "Phone"
                            }, "LeadSource"],
                            dataSource: (currentEmployeeData.Contacts != null ? currentEmployeeData.Contacts.records : '')
                        }).appendTo(container);
                    }
                }
            }).dxDataGrid('instance');
          
        });
        $A.enqueueAction(action);
    }
})