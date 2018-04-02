({ 
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
                    { Country: "West South Central", value: 27.1, parentID: 90.3 },
                    { Country: "Mountain",value: 67.1, parentID: 90.3 },
                    { Country: "Pacific",value: 10.1, parentID: 14.5 } ,
                    { Country: "Pacific-East",value: 23.1, parentID: 14.5 } 
                   ];
        debugger;
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
                position: "left"
            },
          tooltip: {
            enabled: true,
            location: "edge",
            customizeTooltip: function (arg) {
                return {
                    text: arg.seriesName + " years: " + arg.valueText
                };
            }
        },
          onPointClick: function (e) {
               debugger;
                alert(e.target.value);
              alert(helper.filterData(e.target.initialValue,dataSource));
                // alert(helper.filterData(e.target.value,dataSource));
                if (isFirstLevel) {
                    isFirstLevel = false;
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
                }
          }     
        }).dxChart("instance"); 
   },

 filterData : function(name,data) 
{
    debugger;
    return data.filter(function (item) 
     {
         debugger;
        return item.parentID === name;
    });
},
 addPointerCursor : function(container) {
    container.addClass("pointer-on-bars");
},
 removePointerCursor :function(container) {
    container.removeClass("pointer-on-bars");
},
})