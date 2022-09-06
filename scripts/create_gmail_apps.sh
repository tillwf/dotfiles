# Move minimize to the right
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# Disable guest account
# echo allow-guest=false | sudo tee -a /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf

# Disable overlay scrollbars
gsettings set com.canonical.desktop.interface scrollbar-mode normal

# Re-enable overlay scrollbars
# gsettings reset com.canonical.desktop.interface scrollbar-mode

# display name in the menu
# gsettings set com.canonical.indicator.session show-real-name-on-panel true

# Add repositories
# Sublime
# sudo add-apt-repository -y ppa:webupd8team/sublime-text-3

# Opera

# Oracle Java 1.7
# sudo add-apt-repository ppa:webupd8team/java 

# Nuvola
# sudo add-apt-repository ppa:nuvola-player-builders/stable

# Gerer batterie life
# sudo add-apt-repository ppa:linrunner/tlp

# Rhythmbox plugins
# sudo add-apt-repository ppa:fossfreedom/rhythmbox

# fogger
# echo "deb http://ppa.launchpad.net/loneowais/fogger/ubuntu saucy main" >> /etc/apt/source.list
# echo "deb-src http://ppa.launchpad.net/loneowais/fogger/ubuntu saucy main" >> /etc/apt/source.list

# Remove alerts
# sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport 

# Heroku
# wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Vim Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Setup epiphany for  multiple gmail app
for i in R S T
do
  mkdir $HOME/.gmail$i
  echo "[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Gmail$i
Comment=Gmail$i
Exec=epiphany --private-instance --profile=$HOME/.gmail$i
Icon=application.png
Terminal=false" > $HOME/gmail$i.desktop
  sudo mv $HOME/gmail$i.desktop /usr/share/applications/gmail$i.desktop
done

