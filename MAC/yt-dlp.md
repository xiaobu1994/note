#### chrome 浏览器下载youtube视频

```shell
yt-dlp --cookies-from-browser chrome -f bestvideo+bestaudio -o "~/Downloads/%(title)s.%(ext)s" "https://www.youtube.com/watch?v=mhyGjjrY9h0"
```


yt-dlp --cookies-from-browser chrome -f bestvideo+bestaudio -o "~/Downloads/%(title)s.%(ext)s" "{clipboard}"

{clipboard}


[{argument name="链接标题"}]({clipboard}){cursor}