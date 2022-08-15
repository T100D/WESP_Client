#!/bin/bash
#
# Door: Arie van den Heuvel
# Purpose: Create dumpfolder te send a file by mail
#
# 03-07-2019
# versie 0.1
#
# 12-07-2019
# versie 0.2 including multiple file handling
#
# 16-07-2019
# Versie 0.3 include handling spaces in flienames
#

if  [ $(ls -1A /home/wesp/Mail/outgoing_mail/ | wc -l) -gt 0 ];
    then
        for file in /home/wesp/Mail/outgoing_mail/*
        do
        mv "$file" "${file// /_}" ;done
        for sendfile in /home/wesp/Mail/outgoing_mail/*
        do
        echo "Wesp bestand - please do not replay to this email" | mutt -a $sendfile -s "Wesp filetransfer $sendfile" -- you@yourselv.com ;
        mv $sendfile /home/wesp/Mail/send_mail/
        done
   else
      exit
fi
