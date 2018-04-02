({  
    toggleStackedBarChart:function(component,event,helper){ 
        debugger;
        component.set("v.permittsByOutstandingLabel",true);
        helper.loadStackedBarChart(component, event, helper);         
    },
    displayBarchart : function(component, event, helper){
        var jobOwnerIds = event.getParams().jobOwnerIds;
        var loggedInContact = event.getParams().loggedInContact;
        var dashboardRec = event.getParams().dashboardId;
        if(dashboardRec != null){
            component.set('v.jobOwnerIds',jobOwnerIds);           
            component.set('v.loggedInContact',loggedInContact);   
            component.set('v.dashboardRec',dashboardRec);    
            component.set("v.renderCharts",true); 
            if(component.get("v.checkload") == true)
            helper.loadBarChart(component, event, helper);
        }
    },
    loadBarChart : function(component, event, helper){
        debugger;
        var action = component.get("c.getBarChartData");        
        var param = component.get('v.jobOwnerIds');        
        action.setStorable();
        action.setParams({ 
            jobOwnerIds : param, 
            userConfigRec : component.get('v.dashboardRec')
        });
        action.setCallback(this , function(a) {
            debugger;
            if (a.getState() === "SUCCESS") {
                var chartdataarray = a.getReturnValue();
            }
            var chartvalue = [];
            var count = 0;            
            var totalcount = 0;
            var hiddencount = 0;
            
            for (var v in chartdataarray)
            {
                chartvalue.push({
                    name : chartdataarray[v]["drill"]["Name"],
                    value : parseInt(chartdataarray[v]["drill"]["count"])
                });
                                count += parseInt(chartdataarray[v]["drill"]["count"]);
                               totalcount = chartdataarray[v].totalCount
                
            }
            hiddencount = totalcount-count
            component.set('v.totalcount',totalcount);
            component.set('v.count',count);
            component.set('v.hiddencount',hiddencount);
           $("#containerBar").dxChart({
         //        $("#Outstandingchart1").dxChart({
                dataSource: chartvalue,
                palette: "bright",
                commonSeriesSettings: {
                    type: "bar",
                    valueField: "value",
                    argumentField: "name"
                },
                equalBarWidth: false,
                seriesTemplate: {
                    nameField: "name"
                },
                animation: {
                    enabled: true
                },
                valueAxis: {
                    title: {
                        text: ""
                    },
                    position: "left"
                },
                legend: {
                    visible: false,
                    verticalAlignment: "bottom",
                    horizontalAlignment: "center"
                },
                customizeLabel: function() {
                    return {
                        visible: true,
                        customizeText: function () {
                            return this.valueText;
                        }
                    };
                },
                tooltip: {
                    enabled: true,
                    location: "edge",
                    customizeTooltip: function (args) {
                        //debugger;
                        return {
                            html: "<div class='state-tooltip'><h4><b>" +
                            args.point.argument + "</b></h4><div>Total: " +
                            args.point.value +
                            "</div>" + "</div>"
                        };
                    }
                },
                onPointClick: function(e) {
                    debugger;
                    var point = e.target;
                    if(point.isSelected()) {
                        point.clearSelection();
                    } else { 
                        point.select();
                    }
                    var status = point.argument;                  
                    var chartEvent = $A.get("e.c:JO_PassSelectedStatus");
                    chartEvent.setParams({
                        SelectedStatus: status,
                    });
                    chartEvent.fire(); 
                }
            }).dxChart("instance"); 
            
            helper.hideWaiting(component, event, helper);
        });
        $A.enqueueAction(action);        
    },
    loadPieChart : function(component, event, helper) {
        var action = component.get("c.getPieChartData");
        var param = component.get('v.jobOwnerIds');
        action.setStorable();
        action.setParams({
            jobOwnerIds : param,
            userConfigRec : component.get('v.dashboardRec')
        });
        action.setCallback(this , function(a)
                           {
                               debugger;
                               var state = a.getState();
                               if (state === "SUCCESS") {
                                   var chartdataarray = a.getReturnValue();
                               }
                               var chartvalue = [];
                               for (var v in chartdataarray)
                               {
                                   chartvalue.push({
                                       name : chartdataarray[v]["name"],
                                       value : parseInt(chartdataarray[v]["data"])
                                   });
                               }
              $("#containerPie").dxPieChart({
                                    
                 legend: {
                     visible: false
                 },
                 animation: {
                     enabled: true
                 },
                 resolveLabelOverlapping: "shift",
                 palette: "bright",
                 dataSource: chartvalue,
                 series: [
                     {
                         argumentField: "name",
                         valueField: "value",
                         label: {
                             visible: true,
                             connector: {
                                 visible: true,
                                 width: 1
                             },
                             customizeText: function(arg) {
                                 debugger;
                                 return arg.point.argument + " (" + arg.point.value + ")";
                             }
                         }
                     }
                 ],
                 //title: "Area of Countries",
                 "export": {
                     enabled: false
                 },
                 tooltip: {
                     enabled: true,
                     customizeTooltip: function (args) {
                         debugger;
                         return {
                             html: "<div class='state-tooltip'><h4><b>" +
                             args.point.argument + "</b></h4><div>Total: " +
                             args.point.value +
                             "</div>" + "</div>"
                         };
                     }
                 },
                 onPointClick: function (e) {
                     var point = e.target;
                     if(point.isSelected()) {
                         point.clearSelection();
                     } else { 
                         point.select();
                     }
                     var status = point.argument;                             
                     var chartEvent = $A.get("e.c:JO_PassSelectedStatus");
                     chartEvent.setParams({
                         SelectedStatus: status,
                     });
                     chartEvent.fire();
                 },
                 
             });
           
         });
        $A.enqueueAction(action);
    },
 
 loadStackedBarChart: function(component, event, helper){
     debugger;
     var colors = "";//["#6babac", "#ac6b7b"];
     
    var a = document.getElementsByClassName("dxc-series");
     //console.log('---->'+e);
var data = [
    { arg: "NEW", val: 493603615, parentID: "" },
    { arg: "SUBMITTED", val: 438575293, parentID: "" },
    { arg: "RECEIVED", val: 331126555, parentID: "" },
    { arg: "Russia", val: 146804372, parentID: "NEW" },
    { arg: "Germany", val: 82175684, parentID: "NEW" },
    { arg: "Turkey", val: 79463663, parentID: "NEW" },
    { arg: "France", val: 66736000, parentID: "NEW" },
    { arg: "United Kingdom", val: 63395574, parentID: "NEW" },
    { arg: "United States", val: 325310275, parentID: "SUBMITTED" },
    { arg: "Mexico", val: 121005815, parentID: "SUBMITTED" },
    { arg: "Canada", val: 36048521, parentID: "SUBMITTED" },
    { arg: "Cuba", val: 11239004, parentID: "SUBMITTED" },
    { arg: "Brazil", val: 205737996, parentID: "RECEIVED" },
    { arg: "Colombia", val: 48400388, parentID: "RECEIVED" },
    { arg: "Venezuela", val: 30761000, parentID: "RECEIVED" },
    { arg: "Peru", val: 28220764, parentID: "RECEIVED" },
    { arg: "Chile", val: 18006407, parentID: "RECEIVED" },
    { arg: "Connecticut", val: 30761000, parentID: "Russia" },
    { arg: "Maine", val: 28220764, parentID: "Russia" },
    { arg: "Massachusetts", val: 205737996, parentID: "Russia" },
    { arg: "New Hampshire", val: 48400388, parentID: "Russia" },
    { arg: "Rhode Island", val: 30761000, parentID: "Russia" },
    { arg: "Vermont", val: 28220764, parentID: "Russia" },
     { arg: "Delaware", val: 121005815, parentID: "Germany" },
    { arg: "Florida", val: 36048521, parentID: "Germany" },
    { arg: "Georgia", val: 11239004, parentID: "Germany" },
    { arg: "Maryland", val: 205737996, parentID: "Germany" },
    { arg: "North Carolina", val: 48400388, parentID: "Germany" },
    { arg: "South Carolina", val: 30761000, parentID: "Germany" },
    { arg: "Virginia", val: 146804372, parentID: "Mexico" },
    { arg: "West Virginia", val: 82175684, parentID: "Mexico" },
    { arg: "District of Columbia", val: 79463663, parentID: "Mexico" },
    { arg: "Arizona Strip", val: 66736000, parentID: "Mexico" },
    { arg: "Grand Canyon", val: 63395574, parentID: "Mexico" },
    { arg: "North Central Arizona", val: 146804372, parentID: "Canada" },
    { arg: "Northeast Arizona", val: 82175684, parentID: "Canada" },
    { arg: "Northern Arizona", val: 79463663, parentID: "Canada" },
    { arg: "Phoenix metropolitan area", val: 66736000, parentID: "Canada" },
    { arg: "Southern Arizona", val: 63395574, parentID: "Canada" },
    { arg: "Arkansas Delta", val: 146804372, parentID: "Canada" },
    { arg: "Arkansas River Valley", val: 82175684, parentID: "Colombia" },
    { arg: "Arkansas Timberlands", val: 79463663, parentID: "Colombia" },
    { arg: "Central Arkansas", val: 66736000, parentID: "Colombia" },
    { arg: "Crowley's Ridge", val: 63395574, parentID: "Colombia" },
    { arg: "Northwest Arkansas", val: 146804372, parentID: "Colombia" },
    { arg: "South Arkansas", val: 82175684, parentID: "Brazil" },
    { arg: "Central Naugatuck Valley", val: 79463663, parentID: "Brazil" },
    { arg: "Greater Hartford", val: 66736000, parentID: "Brazil" },
    { arg: "Litchfield Hills", val: 63395574, parentID: "Brazil" },
    { arg: "Naugatuck River Valley", val: 146804372, parentID: "Brazil" },
    { arg: "Southwestern Connecticut", val: 82175684, parentID: "Peru" },
    { arg: "Big Bend", val: 79463663, parentID: "Peru" },
    { arg: "Emerald Coast", val: 66736000, parentID: "Peru" },
    { arg: "First Coast", val: 63395574, parentID: "Peru" },
];
      var firstBackButton;
    var secondBackButton;
   var isFirstLevel = true,isSecondLevel = false,
        chartContainer = $("#Outstandingchart1"),
        chart = chartContainer.dxChart({	
            dataSource: helper.filterData("",data),
           // title: "The Most Populated Countries by Continents",
              series: {
                type: "bar",
                valueField: "val",
                argumentField: "arg"
            },
            legend: {
                visible: false
            },
            valueAxis: {
                showZero: false
            },
            onPointClick: function (e) {
                if (isFirstLevel ) {
                    isFirstLevel = false;
                    isSecondLevel = true;
                   firstBackButton= helper.filterData(e.target.originalArgument,data);
     				//alert('varf---->'+firstBackButton);
                    chart.option({
    
                        dataSource: helper.filterData(e.target.originalArgument,data),
 
    					customizePoint: function () {
      
                              var pointSettings = { color: ""};
    						return pointSettings;
                        }
                    });
                    $("#backButton").dxButton("instance").option("visible", true);
                }
                else if (isSecondLevel) {
                    isFirstLevel = false;
                    isSecondLevel = false;
     helper.removePointerCursor(chartContainer);
    secondBackButton = helper.filterData(e.target.originalArgument,data);
    //alert('vars---->'+secondBackButton);                   
                    chart.option({
                        dataSource: helper.filterData(e.target.originalArgument,data),
   
                       
                    });
                    $("#backButton").dxButton("instance").option("visible", true);
                }
            },
            customizePoint: function () {
                var pointSettings ={};
                if (!isSecondLevel) {
                    pointSettings.hoverStyle = {
                        hatching: "none"
                    };
                }
                return pointSettings;
            },
          commonSeriesSettings: {
            type: "bar",
            valueField: "val",
            argumentField: "arg"
        },
         equalBarWidth: false,
          seriesTemplate: {
            nameField: "arg"
           }
        }).dxChart("instance");

    $("#backButton").dxButton({ 
        icon: "chevronleft",
        visible: false,
        onClick: function (e) {
            if (!isFirstLevel && isSecondLevel ) {
   // alert('hif');
      debugger;
                isFirstLevel = true;
                 isSecondLevel = false;
                helper.addPointerCursor(chartContainer);
                chart.option("dataSource", helper.filterData("",data));
                this.option("visible", false);
            }
    else if(!isSecondLevel){
               // alert('hi');
       debugger;
                isFirstLevel = false;
                 isSecondLevel = true;
                helper.addPointerCursor(chartContainer);
                chart.option("dataSource", firstBackButton);
                this.option("visible", true);
    
    }
        }
    });

    helper.addPointerCursor(chartContainer);
},

 filterData : function(name,data) {
    return data.filter(function (item) {
        return item.parentID === name;
    });
},

 addPointerCursor : function(container) {
    container.addClass("pointer-on-bars");
},

 removePointerCursor :function(container) {
    container.removeClass("pointer-on-bars");
},
 loadStackedBarChartDivision : function(component, event, helper){

  var isFirstLevel = true;
    var dataSource = 
    [
    { state: "North", young: 30, middle: 90.3, older: 14.5, parentID: "" }, 
    { state: "East", young: 13.5, middle: 49, older: 5.8 , parentID: "" },
    { state: "South", young: 9.6, middle: 43.4, older: 9 , parentID: "" },
    { state: "West", young: 6.7, middle: 28.6, older: 5.1, parentID: "" },
    { Country: "South Atlantic", value: 12.1, parentID: 30},
    { Country: "East South Central", value: 9.1, parentID: 30},
    { Country: "Pacific",value: 10.1, parentID: 30 } ,
    { Country: "Pacific-East",value: 23.1, parentID: 30 },
    { Country: "West South Central", value: 27.1, parentID: 90.3 },
    { Country: "Mountain",value: 67.1, parentID: 90.3 },
    { Country: "Pacific",value: 10.1, parentID: 90.3 } ,
    { Country: "Pacific-East",value: 23.1, parentID: 90.3 } ,
    { Country: "Cuba", value: 11239004, parentID:14.5 },
    { Country: "Brazil", value: 205737996, parentID: 14.5 },
    { Country: "Colombia", value: 48400388, parentID: 14.5 },
    { Country: "Venezuela", value: 30761000, parentID: 14.5 },
    { Country: "Peru", value: 28220764, parentID: 13.5 },
    { Country: "Chile", value: 18006407, parentID: 13.5 },
    { Country: "Connecticut", value: 30761000, parentID: 13.5 },
    { Country: "Maine", value: 28220764, parentID: 13.5 },
    { Country: "Massachusetts", value: 205737996, parentID: 13.5 },
    { Country: "New Hampshire", value: 48400388, parentID: 49 },
    { Country: "Rhode Island", value: 30761000, parentID: 49 },
    { Country: "Vermont", value: 28220764, parentID: 49 },
    { Country: "Delaware", value: 121005815, parentID: 49 },
    { Country: "Florida", value: 36048521, parentID: 5.8 },
    { Country: "Georgia", value: 11239004, parentID: 5.8 }
                   ];
      var  chartContainer = $("#Outstandingdivchart1");
      var  chart = chartContainer.dxChart({
            dataSource: dataSource,
            commonSeriesSettings: {
                argumentField: "state",
                type: "stackedBar"
            },
            series: [
                { valueField: "young", name: "0-14" },
                { valueField: "middle", name: "15-64" },
                { valueField: "older", name: "65 and older" }
            ],
            legend: {
                visible: false,
                verticalAlignment: "bottom",
                horizontalAlignment: "center",
                itemTextPosition: 'top'
            },
            valueAxis: {
                title: {
                    
                },
                position: "left"
            },
          onPointClick: function (e) {
             // alert(helper.filterData(e.target.initialValue,dataSource));
                if (isFirstLevel) {
                    isFirstLevel = false;
                     helper.removePointerCursor(chartContainer);
                    //removePointerCursor(chartContainer);
                    chart.option({
                        dataSource:  helper.filterData(e.target.initialValue,dataSource),
                        commonSeriesSettings: { argumentField: "Country",  type: "bar" },
                        series: {
                            type: "bar",
                            valueField: "value",
                            argumentField: "Country"
                        },
                        legend: {
                                    visible: false,
                                    verticalAlignment: "bottom",
                                    horizontalAlignment: "center",
                                    itemTextPosition: 'top'
                                },
                       valueAxis: {
                                    title: {
                                    },
                                    position: "left"
                                }
                   			 });
                     $("#backButton").dxButton("instance").option("visible", true);
                }
                debugger; 
          }     
        }).dxChart("instance"); 
       $("#backButton").dxButton({ 
        icon: "chevronleft",
        visible: false,
        onClick: function (e) {
            if (!isFirstLevel) {
   // alert('hif');
      debugger;
                isFirstLevel = true;
               
                helper.addPointerCursor(chartContainer);
                chart.option({
                        dataSource:  helper.filterData("",dataSource),
                    // this.option("visible", false);
                    commonSeriesSettings: {
                argumentField: "state",
                type: "stackedBar"
            },
            series: [
                { valueField: "young", name: "0-14" },
                { valueField: "middle", name: "15-64" },
                { valueField: "older", name: "65 and older" }
            ],
            legend: {
                visible: false,
                verticalAlignment: "bottom",
                horizontalAlignment: "center",
                itemTextPosition: 'top'
            },
            valueAxis: {
                               position: "left"
            },
               
            });
   
        }
    }
});
    helper.addPointerCursor(chartContainer);
   
 
 },
 filterData : function(name,data) 
{
    debugger;
    return data.filter(function (item) 
     {
        return item.parentID === name;
    });
},
 addPointerCursor : function(container) {
    container.addClass("pointer-on-bars");
},
 removePointerCursor :function(container) {
    container.removeClass("pointer-on-bars");
},
    loadStackedBarChartAgency : function(component, event, helper){
        debugger;
        var dataSource = [{
            state: "Connecticut",
            young: 28.6,
            middle: 6.7,
            older: 9
        }, {
            state: "Maine",
            young: 19.6,
            middle: 23.4,
            older: 4
        }, {
            state: "Massachusetts",
            young: 9.5,
            middle: 13,
            older: 25.8
        }, {
            state: "New Hampshire",
            young: 20,
            middle: 30.3,
            older: 54.5
            }, {
            state: "Rhode Island",
            young: 9.5,
            middle: 13,
            older: 25.8
        }, {
            state: "Vermont",
            young: 20,
            middle: 30.3,
            older: 54.5
             }, {
            state: "Delaware",
            young: 19.6,
            middle: 23.4,
            older: 4
        }, {
            state: "Florida",
            young: 39.5,
            middle: 43,
            older: 25.8
        }, {
            state: "Georgia",
            young: 20,
            middle: 30.3,
            older: 54.5
            }, {
            state: "Maryland",
            young: 29.5,
            middle: 53,
            older: 5.8
        }, {
            state: "North Carolina",
            young: 10,
            middle: 50.3,
            older: 14.5
             }, {
            state: "South Carolina",
            young: 29.5,
            middle: 43,
            older: 15.8
        }, {
            state: "Virginia",
            young: 30,
            middle: 20.3,
            older: 34.5
            }, {
            state: "District of Columbia",
            young: 19.5,
            middle: 33,
            older: 25.8
        }, {
            state: "West Virginia",
            young: 10,
            middle: 20.3,
            older: 44.5
        }];
        $("#Outstandingdivchart1").dxChart({
            dataSource: dataSource,
            commonSeriesSettings: {
                argumentField: "state",
                type: "stackedBar"
            },
            series: [
                { valueField: "young", name: "0-14" },
                { valueField: "middle", name: "15-64" },
                { valueField: "older", name: "65 and older" }
            ],
            legend: {
                visible: false,
                verticalAlignment: "bottom",
                horizontalAlignment: "center",
                itemTextPosition: 'top'
            },
            valueAxis: {
                title: {
                    
                },
                position: "left"
            }
           
        }).dxChart("instance"); 
    },
    hideWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", false);    
    },
    showWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", true);
    },
})