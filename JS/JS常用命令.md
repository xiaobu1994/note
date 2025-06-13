```text

var img_container = document.getElementById('img_container');

var $image = $("#img_container");

<a href="javascript:history.back();" class="btn btn-default">返回</a>

$.trim($("#level").val())

window.location.reload();

window.location.href

$(function () {}) juqery的onload事件


将JSON字符串转为json对象。

JavaScript JSON.parse()

var data=eval('('+data+')'); 将JSON字符串转为json对象。eval() 函数可计算某个字符串，并执行其中的的 JavaScript 代码。

JSON.stringify(obj)将JSON对象转为JSON字符串。
var obj = { "name":"runoob", "alexa":10000, "site":"www.runoob.com"};
var myJSON = JSON.stringify(obj);
myJSON--->>{"name":"runoob","alexa":10000,"site":"www.runoob.com"}

var arr = [ {"name":"Google"}];
var myJSON = JSON.stringify(arr);
document.getElementById("demo").innerHTML = myJSON;
'[{"name":"Google"}]'---->>字符串
var str='{ "name": "cxh", "sex": "man" }';

var obj = JSON.parse('{ "name":"runoob", "alexa":10000, "site":"www.runoob.com" }');
obj.alexa + "：" + obj.site;


var obj=eval('('+data+')');
var msg=obj.msg;
console.log(msg);
JSON.parse(string)将字符串转为JSON对象；
var obj = str.parseJSON(); //由JSON字符串转换为JSON对象
var obj = JSON.parse(str); //由JSON字符串转换为JSON对象

href="javascript:history.back();
window.history.go(-1);//正常返回，a.htm不刷新

window.history.back();//同上

window.history.forward();//同上

<a href="javascript:window.location.href = document.referrer;" class="weui-btn weui-btn_primary">返回</a> 返回并且刷新页面

document.cookie   js显示cookie


```