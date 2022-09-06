# https://askubuntu.com/questions/1135264/why-cant-i-install-tomboy-in-ubuntu-mate-19-04

wget https://launchpad.net/ubuntu/+source/tomboy/1.15.9-0ubuntu1/+build/13188678/+files/tomboy_1.15.9-0ubuntu1_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gnome-sharp2/libgconf2.0-cil_2.24.2-4_all.deb  

wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gmime2.6/libgmime2.6-cil_2.6.23+dfsg1-4_all.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gmime2.6/libgmime-2.6-0_2.6.23+dfsg1-4_amd64.deb

sudo apt install libappindicator0.1-cil libdbus-glib2.0-cil libdbus2.0-cil libglib2.0-cil libgtk2.0-cil libgtkspell0 libmono-addins-gui0.2-cil libmono-addins0.2-cil libmono-cairo4.0-cil libmono-posix4.0-cil mono-runtime

sudo dpkg --install libgmime-2.6-0_2.6.23+dfsg1-4_amd64.deb
sudo dpkg --install libgmime2.6-cil_2.6.23+dfsg1-4_all.deb

sudo dpkg --install libgconf2.0-cil_2.24.2-4_all.deb
sudo dpkg --install tomboy_1.15.9-0ubuntu1_amd64.deb