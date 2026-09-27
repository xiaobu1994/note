# yt-dlp 常用命令

## 使用 Chrome Cookie 下载 YouTube 视频

```shell
yt-dlp --cookies-from-browser chrome -f bestvideo+bestaudio -o "~/Downloads/%(title)s.%(ext)s" "https://www.youtube.com/watch?v=mhyGjjrY9h0"
```

## 使用剪贴板中的链接下载

```shell
yt-dlp --cookies-from-browser chrome -f bestvideo+bestaudio -o "~/Downloads/%(title)s.%(ext)s" "{clipboard}"
```

剪贴板链接：

```text
{clipboard}
```

Markdown 链接模板：

```markdown
[{argument name="链接标题"}]({clipboard}){cursor}
```
