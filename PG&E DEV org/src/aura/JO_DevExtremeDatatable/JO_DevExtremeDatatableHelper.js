({
    fetchNotifications : function(component, event, helper) {
        debugger;
        var action = component.get("c.fetchNotifications");
        var fieldSetValues = component.get("v.fieldSetValues");
        var arrfieldNames = [];
        action.setParams
        ({
            sObjectName: component.get("v.sObjectName"),
            criteriafield: component.get("v.criteriafield"),
            conatcIds: component.get("v.contactIds"),
            userConfigRec: component.get("v.userConfigRec"),
            fieldNameJson: JSON.stringify(arrfieldNames),
            notificationIds : component.get('v.notificationIds')
        });
        action.setCallback(this, function(a) {
            component.set('v.Notificationdetails', a.getReturnValue());
            var dataa = a.getReturnValue();
            var condata = JSON.parse(dataa);
            
            var dataGrid = $("#gridContainer").dxDataGrid({
                dataSource: condata,
                allowColumnReordering: true,
                allowColumnResizing: true,
                columnAutoWidth: true,
                showColumnLines: true,
                showRowLines: true,
                rowAlternationEnabled: false,
                showBorders: true,
                wordWrapEnabled: true,
                selection: {
                    mode: "multiple"
                },
                "export": {
                    enabled: true,
                    fileName: "Condata",
                    allowExportSelectedData: true
                },
                groupPanel: {
                    visible: true
                },
                columnChooser: {
                    enabled: true
                },
                columnFixing: { 
                    enabled: true
                },
                filterRow: {
                    visible: true,
                    applyFilter: "auto"
                },
                searchPanel: {
                    visible: true,
                    width: 240,
                    placeholder: "Search..."
                },
                headerFilter: {
                    visible: true
                },
                pager: {
                    showPageSizeSelector: true,
                    allowedPageSizes: [5, 10, 20, 30]
                },
                columns: [{
                    dataField: "Name",
                    caption: "Notification Name",
                    fixed: true,
                    minWidth: 200,
                    headerFilter: {
                        allowSearch: true
                    }
                },
                          {
                              caption: "Type",
                              dataField: "NotificationType__c",
                              minWidth: 150,
                              headerFilter: {
                                  allowSearch: true
                              }
                          },
                          {
                              caption: "Notification Description",
                              dataField: "NotificationDesc__c",
                              minWidth: 120,
                              headerFilter: {
                                  allowSearch: true
                              }
                          },
                          {
                              caption: "Customer",
                              dataField: "Customer__c",
                              minWidth: 120,
                              headerFilter:
                              {
                                  allowSearch: true
                              }
                          },
                          {
                              caption: "Job Owner",
                              dataField: "Jb_Owner__c",
                              minWidth: 120,
                              headerFilter:
                              {
                                  allowSearch: true
                              }
                          },
                          {
                              caption: "Notification Status",
                              dataField: "Notification_Status__c",
                              minWidth: 120,
                              headerFilter: {
                                  allowSearch: true
                              }
                          },
                          {
                              caption: "Priority Type",
                              dataField: "NotifPriorityType__c",
                              minWidth: 120,
                              headerFilter: {
                                  allowSearch: true
                              }
                          }/*,
                          {
                              dataField: "Level__c",
                              caption: "Level",
                              minWidth: 120,
                              headerFilter: {
                                  allowSearch: true
                              }
                          },
                          {
                              dataField: "LeadSource",
                              caption: "Lead Source",
                              minWidth: 120,
                              headerFilter: {
                                  allowSearch: true
                              }
                          },
                          {
                              dataField: "Birthdate",
                              caption: "Birth Date",
                              minWidth: 120,
                              alignment: "right",
                              dataType: "date",
                              headerFilter: {
                                  dataSource: function(data) {
                                      data.dataSource.postProcess = function(results) {
                                          results.push({
                                              text: "Weekends",
                                              value: [[getOrderDay, "=", 0],
                                                      "or",
                                                      [getOrderDay, "=", 6]]
                                          });
                                          
                                          return results;
                                      };
                                  }
                              }
                          },
                          {
                              caption: "Email",
                              dataField: "Email",
                              minWidth: 180,
                              headerFilter: {
                                  allowSearch: true
                              }
                          }*/],
                onToolbarPreparing: function(e) {
                    var dataGrid = e.component;
                    
                    e.toolbarOptions.items.unshift({
                        location: "after",
                        widget: "dxButton",
                        options: {
                            icon: "refresh",
                            onClick: function() {
                                dataGrid.refresh();
                            }
                        }
                    });
                }
            });
        });
    }
    
})