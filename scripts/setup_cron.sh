# write out current crontab
# crontab -l > mycron
# echo new cron into cron file
echo "*/30 * * * * fswebcam -r 1280x960 --jpeg 100 -S 10 \"/home/$USER/Pictures/.Moi/wc-\`date +\%Y-\%m-\%dT\%H-\%M\`.jpeg\"" > mycron
echo "*/30 * * * * DISPLAY=:1 scrot \"/home/$USER/Pictures/.Moi/sc-\`date +\%Y-\%m-\%dT\%H-\%M\`.jpeg\"" >> mycron
#install new cron file
crontab mycron
rm mycron
