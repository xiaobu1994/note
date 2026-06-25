# echarts的dataset应用

> 原创 已于 2023-02-18 16:23:43 修改 · 公开 · 1.8k 阅读 · 0 · 5 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/118901099

一、柱状图
1.1 普通柱状图

```js
option = {
    legend: {},
    tooltip: [{
	 trigger: 'item',
        axisPointer: {
            type: 'cross'
        }
	}],
    dataset: [{
        dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 43.3, '2016': 85.8, '2017': 93.7},
            {product: 'Milk Tea', '2015': 83.1, '2016': 73.4, '2017': 55.1},
            {product: 'Cheese Cocoa', '2015': 86.4, '2016': 65.2, '2017': 82.5},
            {product: 'Walnut Brownie', '2015': 72.4, '2016': 53.9, '2017': 39.1}
        ]
    },
	{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    },{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    },{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    }
	],
    xAxis: [{type: 'category'}],
          "yAxis": [
            {//第一个y轴位置在左侧
                position:'left',
                type : 'value',
                name: '求和1',
                axisLine: {
                show: true,
				 lineStyle: {
                    color: "#c23531"
                }
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {//第二个y轴在右侧
                position:'right',
                type : 'value',
                name: '求和2',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
			{//第三个y轴在右侧
                position:'right',
                type : 'value',
                offset: 40,
				name: '求和3',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
			{//第三个y轴在右侧
                position:'left',
                type : 'value',
                offset: 40,
				name: '求和4',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            }
        ],
    // Declare several bar series, each will be mapped
    // to a column of dataset.source by default.
    series: [
        
	    {type: 'bar',datasetIndex: 0,yAxisIndex:0},
        {type: 'bar',datasetIndex: 0,yAxisIndex:0},
        {type: 'bar',datasetIndex: 0,yAxisIndex:0},
		{type: 'bar',datasetIndex: 1,yAxisIndex:1},
        {type: 'bar',datasetIndex: 1,yAxisIndex:1},
        {type: 'bar',datasetIndex: 1,yAxisIndex:1},
		{type: 'bar',datasetIndex: 2,yAxisIndex:2},
        {type: 'bar',datasetIndex: 2,yAxisIndex:2},
        {type: 'bar',datasetIndex: 2,yAxisIndex:2},
		{type: 'bar',datasetIndex: 3,yAxisIndex:3},
        {type: 'bar',datasetIndex: 3,yAxisIndex:3},
        {type: 'bar',datasetIndex: 3,yAxisIndex:3}
		]
};
```

1.2 堆叠柱状图

```js
option = {
    legend: {},
    tooltip: [{
	 trigger: 'item',
        axisPointer: {
            type: 'cross'
        }
	}],
    dataset: [{
        dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 43.3, '2016': 85.8, '2017': 93.7},
            {product: 'Milk Tea', '2015': 83.1, '2016': 73.4, '2017': 55.1},
            {product: 'Cheese Cocoa', '2015': 86.4, '2016': 65.2, '2017': 82.5},
            {product: 'Walnut Brownie', '2015': 72.4, '2016': 53.9, '2017': 39.1}
        ]
    },
	{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    },{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    },{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    }
	],
    xAxis: [{type: 'category'}],
          "yAxis": [
            {//第一个y轴位置在左侧
                position:'left',
                type : 'value',
                name: '求和1',
                axisLine: {
                show: true,
				 lineStyle: {
                    color: "#c23531"
                }
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {//第二个y轴在右侧
                position:'right',
                type : 'value',
                name: '求和2',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
			{//第三个y轴在右侧
                position:'right',
                type : 'value',
                offset: 40,
				name: '求和3',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
			{//第三个y轴在右侧
                position:'left',
                type : 'value',
                offset: 40,
				name: '求和4',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            }
        ],
    // Declare several bar series, each will be mapped
    // to a column of dataset.source by default.
    series: [
       
	    {type: 'bar',stack:"dataset0",datasetIndex: 0,yAxisIndex:0},
		{type: 'bar',stack:"dataset0",datasetIndex: 0,yAxisIndex:0},
		{type: 'bar',stack:"dataset0",datasetIndex: 0,yAxisIndex:0},

        
		{type: 'bar',stack:"dataset1",datasetIndex: 1,yAxisIndex:1},
        {type: 'bar',stack:"dataset1",datasetIndex: 1,yAxisIndex:1},
        {type: 'bar',stack:"dataset1",datasetIndex: 1,yAxisIndex:1},
		{type: 'bar',stack:"dataset2",datasetIndex: 2,yAxisIndex:2},
        {type: 'bar',stack:"dataset2",datasetIndex: 2,yAxisIndex:2},
        {type: 'bar',stack:"dataset2",datasetIndex: 2,yAxisIndex:2},
		{type: 'bar',stack:"dataset3",datasetIndex: 3,yAxisIndex:3},
        {type: 'bar',stack:"dataset3",datasetIndex: 3,yAxisIndex:3},
        {type: 'bar',stack:"dataset3",datasetIndex: 3,yAxisIndex:3}
		]
};
```

二、饼状图

```js
option = {
    legend: {},
    tooltip: [{
	 
	}],
    dataset: [{
        dimensions: ['product', 'total'],
        source: [
           {product:'THCVDC25 ',total:5},
{product:'THDRYA22 ',total:5},
{product:'THCVDC22 ',total:5},
{product:'THCVDC21 ',total:5},
{product:'THCVDC24 ',total:5},
{product:'THDRYA23 ',total:5},
{product:'THDRYA21 ',total:5},
{product:'THCVDC23 ',total:5},
        ]
    }]
	,
    xAxis: [{type: 'category'}],
          "yAxis": [{}]
        ,
    
    series: [
        
	    {type: 'pie'}
       
		
		]
};
```

三、条形图

```js
option = {
    legend: [{}],
    tooltip: [{
	 trigger: 'item',
        axisPointer: {
            type: 'cross'
        }
	}],
    dataset: [{
        dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 43.3, '2016': 85.8, '2017': 93.7},
            {product: 'Milk Tea', '2015': 83.1, '2016': 73.4, '2017': 55.1},
            {product: 'Cheese Cocoa', '2015': 86.4, '2016': 65.2, '2017': 82.5},
            {product: 'Walnut Brownie', '2015': 72.4, '2016': 53.9, '2017': 39.1}
        ]
    },
	{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    },{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    },{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 77.8, '2017': 60.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    }
	],
    xAxis: [
	{//第一个y轴位置在左侧
                position:'bottom',
                type : 'value',
                name: '求和1',
                axisLine: {
                show: true,
				 lineStyle: {
                    color: "#c23531"
                }
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {//第二个y轴在右侧
                position:'top',
                type : 'value',
                name: '求和2',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
			{//第三个y轴在右侧
                position:'bottom',
                type : 'value',
                offset: 40,
				name: '求和3',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
			{//第三个y轴在右侧
                position:'top',
                type : 'value',
                offset: 40,
				name: '求和4',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            }],
          "yAxis": [
            {type: 'category'}
        ],
    
    series: [
        
	    {type: 'bar',datasetIndex: 0,xAxisIndex:0},
        {type: 'bar',datasetIndex: 0,xAxisIndex:0},
        {type: 'bar',datasetIndex: 0,xAxisIndex:0},
		{type: 'bar',datasetIndex: 1,xAxisIndex:1},
        {type: 'bar',datasetIndex: 1,xAxisIndex:1},
        {type: 'bar',datasetIndex: 1,xAxisIndex:1},
		{type: 'bar',datasetIndex: 2,xAxisIndex:2},
        {type: 'bar',datasetIndex: 2,xAxisIndex:2},
        {type: 'bar',datasetIndex: 2,xAxisIndex:2},
		{type: 'bar',datasetIndex: 3,xAxisIndex:3},
        {type: 'bar',datasetIndex: 3,xAxisIndex:3},
        {type: 'bar',datasetIndex: 3,xAxisIndex:3}
		]
};
```

四、折线图

```js
option = {
    legend: {},
    tooltip: [{
	 trigger: 'item',
        axisPointer: {
            type: 'cross'
        }
	}],
    dataset: [{
        dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 43.3, '2016': 85.8, '2017': 93.7},
            {product: 'Milk Tea', '2015': 83.1, '2016': 73.4, '2017': 55.1},
            {product: 'Cheese Cocoa', '2015': 86.4, '2016': 65.2, '2017': 82.5},
            {product: 'Walnut Brownie', '2015': 72.4, '2016': 53.9, '2017': 39.1}
        ]
    },
	{dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 30.3, '2016': 37.8, '2017': 30.7},
            {product: 'Milk Tea', '2015': 70.1, '2016': 88.4, '2017': 62.1},
            {product: 'Cheese Cocoa', '2015': 55.4, '2016': 99.2, '2017': 47.5},
            {product: 'Walnut Brownie', '2015': 66.4, '2016': 100.9, '2017': 35.1}
        ]
    }
	],
    xAxis: [{type: 'category'}],
          "yAxis": [
            {//第一个y轴位置在左侧
                position:'left',
                type : 'value',
                name: 'y1',
                axisLine: {
                show: true,
				 lineStyle: {
                    color: "#c23531"
                }
            },
                axisLabel: {
                    formatter: '{value} '
                }
            },
            {//第二个y轴在右侧
                position:'right',
                type : 'value',
                name: 'y2',
                axisLine: {
                show: true
            },
                axisLabel: {
                    formatter: '{value} '
                }
            }
        ],
    // Declare several line series, each will be mapped
    // to a column of dataset.source by default.
    series: [
        
	    {name:"y1-2015",type: 'line',datasetIndex: 0,yAxisIndex:0},
        {name:"y1-2016",type: 'line',datasetIndex: 0,yAxisIndex:0},
        {name:"y1-2017",type: 'line',datasetIndex: 0,yAxisIndex:0},
		{name:"y2-2015",type: 'line',datasetIndex: 1,yAxisIndex:1},
        {name:"y2-2016",type: 'line',datasetIndex: 1,yAxisIndex:1},
        {name:"y2-2017",type: 'line',datasetIndex: 1,yAxisIndex:1}
		
		]
};
```

五、散点图
多个图例

```js
option = {
    legend: {},
    tooltip: [{
	 
	}],
    dataset: [{
        dimensions: ['product', '2015', '2016', '2017'],
        source: [
            {product: 'Matcha Latte', '2015': 43.3, '2016': 85.8, '2017': 93.7},
            {product: 'Milk Tea', '2015': 83.1, '2016': 73.4, '2017': 55.1},
            {product: 'Cheese Cocoa', '2015': 86.4, '2016': 65.2, '2017': 82.5},
            {product: 'Walnut Brownie', '2015': 72.4, '2016': 53.9, '2017': 39.1}
        ]
    }]
	,
    xAxis: [{type: 'category'}],
          "yAxis": [{}]
        ,
    
    series: [
        
	    {type: 'scatter',symbolSize: 20},
        {type: 'scatter',symbolSize: 20},
        {type: 'scatter',symbolSize: 20}
		
		]
};
```

单个图例

```js
option = {
    legend: {},
    tooltip: [{
	 
	}],
    dataset: [{
        dimensions: ['product','2015'],
        source: [
            {'product': 'Matcha Latte', '2015': 43.3},
            {'product': 'Matcha Latte', '2015': 43.3},
            {'product': 'Milk Tea', '2015': 83.1},
            {'product': 'Cheese Cocoa', '2015': 86.4},
            {'product': 'Walnut Brownie', '2015': 72.4}
        ]
    }]
	,
    xAxis: [{type: 'category'}],
          "yAxis": [{}]
        ,
    
    series: [
        
	    {type: 'scatter',symbolSize: 20}

		
		]
};
```

数组的形式
有图例名称

```js
option = {
 legend : {},
 tooltip : {},
 dataset : [
 {
  source : [    
["Income","Life Expectancy"], 
[28604,77],   
[31163,77.4],   
[1516,68]   
]
}, {
  source : [    
["Income","Life Expectancy"], 
 
[44056,81.8],
[43294,81.7],
[13334,76.9],
[21291,78.5]
]
}
],
 xAxis : {
 
  type : 'category'
 
 },
 yAxis : {
  
 },
 
 series : [ 
 {
  name:"1990",
  type : 'scatter',
datasetIndex:0
 
 }, 
 {
   name:"2015",
   type : 'scatter',
   datasetIndex:1
 
  }
  ]
};
```

无图例名称

```js
option = {
 legend : {},
 tooltip : {},
 dataset : [
 {
  source : [    

[28604,77],   
[31163,77.4],   
[1516,68]   
]
}, {
  source : [    

 
[44056,81.8],
[43294,81.7],
[13334,76.9],
[21291,78.5]
]
}
],
 xAxis : {
 
  type : 'category'
 
 },
 yAxis : {
  
 },
 
 series : [ 
 {
  
  type : 'scatter',
datasetIndex:0
 
 }, 
 {
   
   type : 'scatter',
   datasetIndex:1
 
  }
  ]
};
```

雷达图

```
option={
      "legend": [
        {}
      ],
      "title": [
        {
          "text": "雷达图"
        }
      ],
      "radar": [
        {
          "indicator": [
            {
              "name": "THCVDC21"
            },
            {
              "name": "THCVDC22"
            },
            {
              "name": "THCVDC23"
            },
            {
              "name": "THCVDC24"
            },
            {
              "name": "THCVDC25"
            },
            {
              "name": "THDRYA21"
            },
            {
              "name": "THDRYA22"
            },
            {
              "name": "THDRYA23"
            }
          ]
        }
      ],
      "series": [
        {
          "data": [
            {
              "name": "2021/04/01 08:11:34",
              "value": [
                "null",
                "null",
                "null",
                "null",
                "null",
                "5",
                "5",
                "5"
              ]
            },
            {
              "name": "2021/04/01 08:28:49",
              "value": [
                "null",
                "5",
                "5",
                "5",
                "5",
                "5",
                "5",
                "5"
              ]
            }
          ],
          "type": "radar",
          "name": "雷达图"
        }
      ]
    }
```

盒须图

```js
option = {
    title: [
        {
            text: 'Michelson-Morley Experiment',
            left: 'center'
        }
    ],
    dataset: [{
        source: [
            ["周一", 740, 900, 1070, 930, 850, 950, 980, 980, 880, 1000, 980, 930, 650, 760, 810, 1000, 1000, 960, 960],
            ["周二", 940, 960, 940, 880, 800, 850, 880, 900, 840, 830, 790, 810, 880, 880, 830, 800, 790, 760, 800],
            ["周三", 880, 880, 860, 720, 720, 620, 860, 970, 950, 880, 910, 850, 870, 840, 840, 850, 840, 840, 840],
            ["周四", 810, 810, 820, 800, 770, 760, 740, 750, 760, 910, 920, 890, 860, 880, 720, 840, 850, 850, 780],
            ["周五", 840, 780, 810, 760, 810, 790, 810, 820, 850, 870, 870, 810, 740, 810, 940, 950, 800, 810, 870]
        ]
    }],
    tooltip: {
       
    },
  
    xAxis: {
        type: 'category',
      
    },
    yAxis: {
        type: 'value',
        name: 'km/s minus 299,000',
        splitArea: {
            show: true
        }
    },
    series: [
        {
            name: 'boxplot',
            type: 'boxplot'
            
        }
    ]
};
```

组合图

```js
option = {
    tooltip: {
        trigger: 'axis',
        axisPointer: {
            type: 'cross',
            crossStyle: {
                color: '#999'
            }
        }
    },
    toolbox: {
        feature: {
            dataView: {show: true, readOnly: false},
            magicType: {show: true, type: ['line', 'bar']},
            restore: {show: true},
            saveAsImage: {show: true}
        }
    },
    legend: {
       
    },
    xAxis: [
        {
            type: 'category'
        }
    ],
    yAxis: [
        {
            type: 'value',
            name: '水量',
            min: 0,
            max: 250,
            interval: 50,
            axisLabel: {
                formatter: '{value} ml'
            }
        },
        {
            type: 'value',
            name: '温度',
            min: 0,
            max: 25,
            interval: 5,
            axisLabel: {
                formatter: '{value} °C'
            }
        }
    ],
	 dataset: [
 {
        dimensions: ['product', '蒸发量', '降水量'],
        source: [
            {product: '一月', '蒸发量': 43.3, '降水量': 85.8},
            {product: '二月', '蒸发量': 83.1, '降水量': 73.4},
            {product: '三月', '蒸发量': 86.4, '降水量': 65.2},
            {product: '四月', '蒸发量': 72.4, '降水量': 53.9},
            {product: '五月', '蒸发量': 72.4, '降水量': 53.9}
        ]
    },
	  {
	  dimensions: ['product', '平均温度'],
        source: [
            {product: '一月', '平均温度': 2},
            {product: '二月', '平均温度': 22.1},
            {product: '三月', '平均温度': 20.4},
            {product: '四月', '平均温度': 18.4},
            {product: '五月', '平均温度': 12}
        ]
    }
	
],
    series: [
        {
           
            type: 'bar'
        },
        {
            
            type: 'bar'
        },
        {   name:'平均温度',
            type: 'bar',
            datasetIndex:1,
            yAxisIndex: 1
            
        }
    ]
};
```

双层X轴

```text
option = {
  xAxis:[{
    type: 'category',
    data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    xAxisIndex:0,
   axisTick:{
      show:true,
      length:50,
      alignWithLabel:false,
       interval:(index, value) => {
         //024代表下面的TEST几的下标列表
      if([0,2,4].includes(index))return true;
      return false;
    }
   }
  },
  {
    
    type: 'category',
    //TEST 重复数据后为''
    data: ['TEST', '','TEST2','',  'TEST3','', ''],
    xAxisIndex:1,
    position:'bottom',
    axisLabel:{
     padding:[20,0,0,0],
    },
    axisTick:{
      show:false
    }

  }
  
  ],
  yAxis: {
    type: 'value',
    max: 275.22,
    min: 110.1232,
    
interval:160/10
  },
  series: [
    {
      data: [150, 230, 224, 218, 135, 147, 260],
      type: 'bar'
    }
  ]
};
```