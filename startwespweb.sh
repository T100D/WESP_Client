#!/bin/sh
#
# The VNC server does not support OpenGL extensions.
#
# Disable annoying password store question --password-store=basic
# The --disable-gpu is to disable the GPU error on starting
# The --password-store=basic disables the keyring question at opening the browser
# The --new-window is needed for a sepperate window in combination with --user-data-dir=/home/wesp/.config/chromium/
# The --no-xshm Disables MIT-SHM (shared memory) extension - helps to overcome mallformed browser windows
# this directory is the same as the basic datastore so the windows are linked
#
# wmctrl positions the second started window on the first screen
#
# Version 1.1 dd 29-01-2021
# Version 2.0 dd 07-02-2022 after switching form chromium to chrome
#
# exec /usr/bin/chromium-browser --password-store=basic --disable-gpu --no-xshm --window-size=1920,1166 --window-position=1921,28 %u http://our.applciation.url & sleep 1 ; /usr/bin/chromium-browser --user-data-dir=/home/wesp/.config/chromium/ --new-window --password-store=basic --disable-gpu --no-xshm --window-position=1921,28 --window-size=1920,1166 %u http://our.applciation.url & sleep 1 ; wmctrl -r :ACTIVE: -e 0,0,28,1919,1166
#
# HVL
/usr/bin/google-chrome-stable --password-store=basic --window-size=1920,1132 --window-position=1921,18 %u https://wesp.schelderadar.net/wesp/ & sleep 1 ; /usr/bin/google-chrome-stable --new-window --password-store=basic --window-size=1920,1132 --window-position=1921,18 %u https://wesp.schelderadar.net/wesp/ & sleep 1 ; wmctrl -r :ACTIVE: -e 0,-40,18,1962,1176
