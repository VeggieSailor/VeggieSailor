#!/bin/sh
gource --logo harbour-veggiesailor.png --date-format '%Y-%m-%d' -1280x720 . -o - | avconv  -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset medium -pix_fmt yuv420p -crf 1  -mbd rd -flags +mv4+aic -trellis 2 -cmp 2 -threads 0 -bf 0 /tmp/sgource.mp4
avconv -y -i /tmp/sgource.mp4 -b 2048k   -threads 0 -mbd rd -flags +mv4+aic -trellis 2 -cmp 2 -subcmp 2 -g 300    -crf 15 /tmp/veggiesailor.mp4

