# datatables对某列进行求和

> 原创 于 2020-08-14 14:48:35 发布 · 公开 · 1.1k 阅读 · 0 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/108004465

前言:

> 还有footerCallback属性，可让您定义页脚显示回调函数，该函数将在每个"绘制"事件上调用。
> initComplete和footerCallback之间的区别在于，initComplete被调用一次，并且在每个"绘制"事件中被调用footerCallback。
> 如果要显示整个表的总和，initComplete就足够了。 否则，如果您只需要在页脚数据中显示与当前页面相关的数据(如在页脚回调示例中)，请改用footerCallback。

一、footerCallback 方法

> 如果服务端不分页则 data是为所有数据，分页后则为当前页面的数据 所有这个方法不适用于服务器分页

```js
          "footerCallback": function (row, data, start, end, display) {
                var api = this.api(), data;
                // Remove the formatting to get integer data for summation
                var intVal = function (i) {
                    return typeof i === 'string' ?
                        i.replace(/[\$,]/g, '') * 1 :
                        typeof i === 'number' ?
                            i : 0;
                };

                // Total over all pages 分页后数据只是当前页面的
                total1 = api
                    .column(1)
                    .data()
                    .reduce(function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0);

                total2 = api
                    .column(2)
                    .data()
                    .reduce(function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0);

                total3 = api
                    .column(3)
                    .data()
                    .reduce(function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0);

                // Total over this page
                pageTotal1 = api
                    .column(1, {page: 'current'})
                    .data()
                    .reduce(function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0);

                pageTotal2 = api
                    .column(2, {page: 'current'})
                    .data()
                    .reduce(function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0);
                pageTotal3 = api
                    .column(3, {page: 'current'})
                    .data()
                    .reduce(function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0);

                // Update footer
                $(api.column(1).footer()).html(
                    '共计: ¥' + pageTotal1
                );
                $(api.column(2).footer()).html(
                    '共计: ' + pageTotal2
                );
                $(api.column(3).footer()).html(
                    '共计: ¥' + pageTotal3
                );
            }
```

二、initComplete方法

**分页情况下：** 

> json.extraInfo需要自定义参数 自己去查

```js

   "initComplete": function (settings, json) {//初始化完成执行的函数
                 var api = this.api();
                 $(api.column(3).footer()).html(
                     '共计: ¥' + json.extraInfo
                 );
             }
```

计算某一列当前页面的数据和

```js

  "initComplete": function (settings, json) {//初始化完成执行的函数
                var api = this.api();
                //计算当前页面的
                $( api.table().footer() ).html(
                    api.column( 3 ).data().sum()
                );
            }
```

需要添加 [sum.js](https://cdn.datatables.net/plug-ins/1.10.21/api/sum%28%29.js) 

参考:

[datatables的sum方法](https://datatables.net/plug-ins/api/sum%28%29) 

[关于javascript：DataTables.net表页脚总和](https://www.codenong.com/27918051/) 