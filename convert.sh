ffmpeg -y -r 60 -f image2 -s 1920x1080 \
    -pattern_type glob -i 'video/*.png' \
    -vcodec libx264 -crf 25  -pix_fmt yuv420p \
    'docs/output.mp4'
ffmpeg -y -i 'docs/output.mp4' \
    -vcodec libvpx -acodec libvorbis \
    'docs/output.webm'
