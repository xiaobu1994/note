# dataTables设置表头居中和列内容居中，以及过多隐藏悬浮显示

> 原创 于 2019-06-12 15:19:58 发布 · 公开 · 5.5k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/91535514

### 设置dataTables列内容居中

```html
    .table>tbody>tr>td{
        text-align:center;
    }
```

### 设置表头居中

```html
    .table>thead:first-child>tr:first-child>th{
        text-align:center;
    }
```

### 列内容过长实现隐藏并悬浮显示

```js
                      {
                                          "data": "operationInfo",
                                          "render": function (data, type, row) {
                                              if (data.length > 40) {
                                                  return "<a title='" + data + "' href='#' style='text-decoration: none;'>" + data.trim().substr(0, 40) + "..." + "</a>";
                                              } else {
                                                  return data;
                                              }
                                          }
                                      }
```