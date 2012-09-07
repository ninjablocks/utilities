#!/bin/bash

mjpg_streamer -i "/usr/local/lib/input_uvc.so -d /dev/video0" -o "/usr/local/lib/output_http.so -p 5000";
