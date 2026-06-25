# Echarts 多Y轴设置

> 原创 于 2021-07-06 16:00:29 发布 · 公开 · 1.6k 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/118522780

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