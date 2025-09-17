#!/bin/bash
# 批量将当前目录下的 .ts 转换为 .mp4

for f in *.ts; do
    # 去掉后缀
    filename="${f%.*}"
    echo "正在转换: $f -> $filename.mp4"
    ffmpeg -i "$f" -c copy -bsf:a aac_adtstoasc "$filename.mp4"
done

echo "全部转换完成 ✅"