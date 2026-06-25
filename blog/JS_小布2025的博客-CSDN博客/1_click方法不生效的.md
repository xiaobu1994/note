# click方法不生效的

> 原创 于 2019-03-21 17:23:19 发布 · 公开 · 3.9k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/88720500

```html
 
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>图片上传</title>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <link rel="stylesheet" href="/plugins/weui/css/weui.css"/>
    <link rel="stylesheet" href="/plugins/weui/css/weuix.css"/>
 
 
    <script src="/plugins/weui/js/jquery-2.1.4.js"></script>
    <script src="/plugins/weui/js/zepto.min.js"></script>
    <script src="/plugins/weui/js/zepto.weui.js"></script>
    <script src="/plugins/weui/js/lrz.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script src="https://res.wx.qq.com/open/libs/weuijs/1.0.0/weui.min.js"></script>
    <script>
 
        $(function(){
 
            var tmpl = '<li class="weui-uploader__file" style="background-image:url(#url#)"></li>';
            var      $uploaderInput = $("#uploaderInput"); //上传按钮+
            var       $uploaderFiles = $("#uploaderFiles");    //图片列表
            var $galleryImg = $(".weui-gallery__img");//相册图片地址
            var $gallery = $(".weui-gallery");
            $uploaderInput.on("change", function(e){
                var src, url = window.URL || window.webkitURL || window.mozURL, files = e.target.files;
                for (var i = 0, len = files.length; i < len; ++i) {
                    var file = files[i];
 
                    if (url) {
                        src = url.createObjectURL(file);
                    } else {
                        src = e.target.result;
                    }
 
                    $uploaderFiles.append($(tmpl.replace('#url#', src)));
                    document.getElementById("upload").style.display = 'none';
                }
            });
            $uploaderFiles.on("click", "li", function(){
                $galleryImg.attr("style", this.getAttribute("style"));
                console.log(this);
                $gallery.fadeIn(100);
            });
            $gallery.on("click", function(){
                $gallery.fadeOut(100);
            });
            //生效
          /*  $('#submit_button').on('click', function(){
                alert("提交中");
            });*/
        });
 
        //提交 不生效
        $('#submit_button').on('click', function(){
            alert("提交中");
        });
 
 
 
 
    </script>
</head>
 
<body ontouchstart>
<div class="page-hd">
    <h1 class="page-hd-title">
        图片上传和预览压缩
    </h1>
    <p class="page-hd-desc">需要加载lrz.min.js压缩插件</p>
</div>
 
<div class="page-bd-15">
    <div class="weui-uploader">
        <div class="weui-uploader__hd">
            <p class="weui-uploader__title">图片预览</p>
            <div class="weui-uploader__info">0/1</div>
        </div>
        <div class="weui-uploader__bd">
            <ul class="weui-uploader__files" id="uploaderFiles">
            </ul>
            <div class="weui-uploader__input-box" id="upload">
                <input id="uploaderInput" class="weui-uploader__input" accept="image/*" multiple="" type="file">
            </div>
        </div>
    </div>
 
    <div class="weui-gallery" style="display: none">
        <span class="weui-gallery__img"></span>
        <div class="weui-gallery__opr">
        </div>
    </div>
 
 
    <div class="page__bd page__bd_spacing">
        <a href="javascript:void(0);" id="submit_button" class="weui-btn weui-btn_primary">提交</a>
    </div>
 
 
 
 
 
</div>
<br>
<br>
<div class="weui-footer weui-footer_fixed-bottom">
    <p class="weui-footer__links">
        <a href="../index.html" class="weui-footer__link">WeUI首页</a>
    </p>
    <p class="weui-footer__text">Copyright &copy; xiaobu</p>
</div>
</body>
<script>
    //提交  生效
   /* $('#submit_button').on('click', function(){
        alert("提交中");
    });*/
</script>
</html>
```

---

注:需要把js方法放在下面或者放在onload方法里面才会执行。放在head里面有可能出现,js加载了但是dom节点没有加载。