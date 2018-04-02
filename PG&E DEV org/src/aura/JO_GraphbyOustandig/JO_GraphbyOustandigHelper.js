({
	 loadStackedBarChart : function(component, event, helper){
        debugger;
       // component.set('v.permittsByOutstandingLabel',true);
        var dataSource = [{
            state: "Northeast",
            young: 6.7,
            middle: 28.6,
            older: 5.1
        }, {
            state: "Midwest",
            young: 9.6,
            middle: 43.4,
            older: 9
        }, {
            state: "South",
            young: 13.5,
            middle: 49,
            older: 5.8
        }, {
            state: "West",
            young: 30,
            middle: 90.3,
            older: 14.5
        }];
        component.set('v.countval',dataSource.length);
        $("#Outstandingchart").dxChart({
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
})