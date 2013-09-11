#!/bin/bash

mjpg_streamer -i "/usr/local/lib/input_uvc.so -d /dev/video0" -o "/usr/local/lib/output_http.so -p 5000";

# A higher resolution image can be taken if you modify the utilities script as suggested by Martn (sic)
# on our forums http://forums.ninjablocks.com/index.php?p=/discussion/comment/6329#Comment_6329
# For example modify above:
#   mjpg_streamer -i "/usr/local/lib/input_uvc.so --resolution SXGA -d /dev/video0" \
#      -o "/usr/local/lib/output_http.so -p 5000";
