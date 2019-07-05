    #!/bin/bash
    #
    # Door: Arie van den Heuvel
    # Doel: Controleren van een map en het te aanwezige bestand verzenden
    #
    # 03-07-2019
    # versie 0.1
    #

    if  [ $(ls -1A /home/wesp/Mail/outgoing_mail/ | wc -l) -gt 0 ];
         then file=$(ls -1A /home/wesp/Mail/outgoing_mail/) ;
         echo "Wesp bestand - please do not replay to this email" | mutt -a /home/wesp/Mail/outgoing_mail/$file -s "Wesp filetransfer $file " -- (receiver addres) ;
         mv /home/wesp/Mail/outgoing_mail/$file /home/wesp/Mail/send_mail/
        else
         exit
    fi
