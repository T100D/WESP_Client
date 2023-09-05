## Configuration Centos7 client setup for WESP

### Remove software
```
# yum remove -y vinagre empathy cheese totem gnome-boxes gnome-software gnome-disk-utility icedtea-web orca tigervnc-server-minimal firewall-config setroubleshoot-server gnome-packagekit spice-vdagent spice-server spice-glib spice-gtk3
```
### Install software
```
yum install -y alacarte htop nmon mc dconf-editor lftp xinetd wmctrl
yum localinstall -y check_mk agent
```

### Install software for acrobat/pdf 32bit dependencies
```
yum install -y gtk-murrine-engine.x86_64 libmount.i686 libmount.x86_64 msttcorefonts
yum install libpk-gtk-module.so (incl. dependancies, removes lib-gtk-error)
yum install libcanberra-gtk-module.so (incl. dependancies,removes lib-gtk-error)
yum install adwaita-gtk2-theme-3.28-2.el7.i686 (removes 'Unable to locate theme engine in module_path: "adwaita"' Error)
```

### Install and configure chromium browser
```
yum install -y chromium

vi /usr/share/applications/chromium-browser.desktop en vi ~/Desktop/chromium-browser.desktop
Exec=chromium --password-store=basic %U
```

### Aditional chromium startup settigs due to malformed presentation
```
--disable-gpu -no-xshm

Exec=chromium --password-store=basic -disable-gpu --no-xshm %U
```

### Install Google-Chrome
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum localinstall google-chrome-stable_current_x86_64.rpm
```

### Deny update of check-mk-agent from epel repo

Add exclude in /etc/yum.repos.d/epel.repo as seen bellow:
```
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
exclude=check-mk-agent
```

### Install Shell Extention (declined from centos 7.7)

Install shell extention Taskbar (https://extensions.gnome.org/extension/584/taskbar/) version 3.32/57  
Configuration:
  - Overview: Task Only
  - Tasks (1): Label > App Name
  - Tasks (1): Label > Width 130
  - Buttons: Disable Desktopbutton Click
  - Misc: Activities & Applicaion & Hot Corner Menu & Dash: OFF

### Disable shell extention Window-list (declined from centos 7.7)
```
mv /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com/ /root/
```
### Configure ntpd
configure ntp servers in /etc/ntp.conf

### Configure services
```
systemctl stop firewalld; systemctl disable firewalld
systemctl stop mdmonitor; systemctl disable mdmonitor
systemctl stop smart; systemctl disable smart
systemctl enable xinetd; systemctl start xinetd
systemctl enable ntpd; systemctl start ntpd
systemctl stop bluetooth; systemctl disable bluetooth
systemctl stop chronyd; systemctl disable chronyd
systemctl stop libvirtd.service; systemctl disable libvirtd.service
systemctl stop bolt; systemctl disable bolt
systemctl stop ModemManager; systemctl disable ModemManager
systemctl stop wpa_supplicant; systemctl disable wpa_supplicant
systemctl disable qemu-guest-agent.service
systemctl disable mdcheck_continue.service
systemctl disable ipsec; systemctl mask ipsec
```

### Enable VI syntax Highlighting (install VIM when needed)
  - add "alias vi=vim" >> /etc/profile

### Tweak bash enviroment
  - add export PS1="\u@\h:\w>" >> /home/wesp/.bashrc
  - add alias cdw='cd /usr/local/wesp/wesp3' >> /home/wesp/.bashrc

### disable ssl certificate verification for lftp
```
  # echo "set ssl:verify-certificate no" >> /etc/lftp.conf
```

### Configure VNC & desktop environment
  - Set enviroment to "Nederlands" in Region and language (WESP depends on it)
  - Set Formats to "Nederlands" in Region and Language (WESP depends on it)
  - Modify /etc/gdm/Init/Default for single or dual monitor environment
  - Modifi /home/wesp/.config/monitors.xml for the right desktop size 
  - Disable VNC Password in /etc/gdm/Init/Default & service gdm restart to enable it.
  - Set color profile sRGB for the monitor.

### Configure SAN share
  - Create mountpoint & add mountpoint to /etc/stab
```  
mkdir /mnt/san

add to /etc/fstab
    //10.64.72.15/SAN01 /mnt/san cifs user=xxxx,pass=xxxx,noserverino,nounix,ro,sec=ntlm 0 0  (Centos 7.5)
    //10.64.72.15/SAN01 /mnt/san cifs user=xxxx,pass=xxxx,noserverino,nounix,rsize=61440,ro,sec=ntlm,vers=1.0 0 0  (Centos 7.6)
```
  - Make it mount at boot time:
``` 
chmod +x /etc/rc.d/rc.local  
echo "sleep 15; mount /mnt/san" >> /etc/rc.local  
```

### Add program directory & copy software   
  - add directory /usr/local/wesp, copy files, chown wesp:wesp -R *
  - copy desktop program icons & prohibit changes > chmod xxx -w

###  add cronjobs for user wesp for file cleaning
```
  0 09 * * * find /usr/local/wesp/wesp3/wesp_client/log -name '*log*' -mtime +7 -exec gzip "{}" \; &> /dev/null  
 30 09 * * * find /usr/local/wesp/wesp3/wesp_client/log -name '*log*' -mtime +60 -exec rm "{}" \; &> /dev/null  
```

**Extra cronjobs DOR SIM/ACC Client**  
```
 0 10 * * * find /usr/local/wesp/wesp3/wesp_client_acc/log -name '*log*' -mtime +7 -exec gzip "{}" \; > /dev/null 2>&1  
30 10 * * * find /usr/local/wesp/wesp3/wesp_client_acc/log -name '*log*' -mtime +60 -exec rm "{}" \; > /dev/null 2>&1  
 0 11 * * * find /usr/local/wesp/wesp3/wesp_client_sim/log -name '*log*' -mtime +7 -exec gzip "{}" \; > /dev/null 2>&1  
30 10 * * * find /usr/local/wesp/wesp3/wesp_client_sim/log -name '*log*' -mtime +60 -exec rm "{}" \; > /dev/null 2>&1  
```
### Optimize User space
 - Set Autologin for user wesp
 - Screen always on in energy administration
 - Edit application menu with alacarte (remove unwanted entries)
 - Add Terminal Icon to desktop with root access (gnome-terminal -e su | & permissions read-only)
 - Add Belgium keyboard for NDC & HACC Client
 - Disable Lock screen All Settings / Power &  in APPLICATIONS -> SYSTEM TOOLS -> SETTINGS -> PRIVACY -> SCREEN LOCK?
 - Put gtk.css in /home/wesp/.config/gtk-3.0/ to reduce Application bar
 - Tweaks: Top Bar, Show applications Menu > Off, enable show date
 - Tweaks: Workspaces, number of workspaces to 1, workspace creation > static
 - Tweaks: check all and adjust where needed
 - Tweaks: Power Action >> Nothing 
 - Tweaks: Desktop enable icons on desktop, disable mounted volumes
 - Put gtk.css in /home/wesp/.config/gtk-3.0/ (smaller titlebar)

### Optimze gnome settings
```
gsettings set org.gnome.nm-applet disable-wifi-create true
gsettings set org.gnome.login-screen allowed-failures 100
gsettings set org.gnome.nautilus.icon-view default-zoom-level standard
gsettings set org.gnome.online-accounts whitelisted-providers []
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.desktop.input-sources xkb-options ['numpad:microsoft', 'caps:shiftlock']
gsettings set org.gnome.desktop.session idle-delay 0
  later additions
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
```

### Modify logon session list
```
mv /usr/share/xsessions/gnome-custom-session.desktop /root/
mv /usr/share/xsessions/gnome.desktop /root/
```

### Disable network changes by user
  - Add "NM_CONTROLLED=no" >> /etc/sysconfig/network-scripts/ifcfg-<interface> 

### Add Printers  
  - Konika Minolta 10.64.60.90 port 9100, Generic PostScript level 2 Printer, media size A4
  - Canon C5235i Diver download http://canonijdriver.com/canon-ir-adv-c5235i-driver/
    - Unzip file & ./install.sh & follow procedure, type = socket ip 10.64.60.84:9100

### Prohibit Shutdown by user
  - Add 55-inhibit-shutdown.rules >> /etc/polkit-1/rules.d/

### Complete hostsfile
  - Add workstations to /ets/hosts

### Apply bugfix for polkitd error
This error shows itself by 10 to 15% cpu for polkitd and many kernel process creations  
```
gsettings set org.gnome.settings-daemon.plugins.account notify-period 0 (in the desktop as user wesp & root)
```

### Document tools
 - gnome-tweak-tool
 - alacarte
 - dconf-editor

### keyboard repeat error
Posssibly soved by -repeat option in x11vnc
Testing code if it fails  
```
gsettings get org.gnome.desktop.peripherals.keyboard repeat  
gsettings set org.gnome.desktop.peripherals.keyboard repeat true  
```

### Disable ctrl+alt+del
```
systemctl mask ctrl-alt-del.target
systemctl daemon-reload
```

### Opitmize open file limit
edit /etc/security/limits.conf and add:
```
  root soft nofile 65536
  root hard nofile 65536
  * soft nofile 65536
  * hard nofile 65536
```

### Optimize Xorg for preventing memory issue & disable DPMS
```
systemctl stop gdm
Xorg -configure
mv /root/xorg.conf.new /etc/X11/xorg.conf

add the following in section "Monitor":
	Option "DPMS" "false"
	
add the following in Section "Screen":
	DefaultDepth 16

systemclt start gdm
```

### Disable oom-killer

Add to /etc/sysctl.conf  
```
vm.overcommit_ratio = 100  
vm.overcommit_memory = 2  
```
### Set promt with path for user wesp
```
echo 'export PS1="\u@\h:\w>"' >> /home/wesp/.bashrc
```

### Backup & restore gnome settings
**Backup**
```
dconf dump /org/gnome/ > backup-gnome.txt
```

**Restore**
```
dconf load /org/gnome/ < backup.txt
```

### Add JAVA_HOME for the wesp user
```
echo "export JAVA_HOME=/usr/local/wesp/wesp3/java/jre/bin/java" >> /home/wesp/.bash_profile
```
### Add jolokia agent when needed

The agent can be downloaded here: https://jolokia.org/download.html
The current agent is:  	jolokia-jvm-1.6.2-agent.jar

create a folder /usr/local/wesp/wesp3/jolokia and put the agent in this directory

Add the following to the start command in: /usr/local/wesp/wesp3/wesp_client/start/StartWespPROD.sh
```
-javaagent:/usr/local/wesp/wesp3/jolokia/jolokia-jvm-1.6.2-agent.jar=port=8080
```

### Optimize disk speed
Make modifications to /etc/fstab for better diskspeed of the system, the added parameters are noatime and nobarrier.

```
/dev/mapper/centos_wspcvl--wstndc-root /                       xfs     defaults,noatime,nobarrier        0 0
UUID=b3fd6416-68d5-4812-b099-ca0ba280af03 /boot                   xfs     defaults        0 0
/dev/mapper/centos_wspcvl--wstndc-home /home                   xfs     defaults,noatime,nobarrier        0 0
/dev/mapper/centos_wspcvl--wstndc-swap swap                    swap    defaults,noatime,nobarrier        0 0
```
