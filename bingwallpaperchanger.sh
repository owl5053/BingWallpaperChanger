#!/bin/bash

# Easy script to change wallpaper from BING
# by OWL5053

#not work on FreeBsd/Mac
#lnk=$(curl -s -L "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1" | grep -oPm1 "(?<=urlBase>)[^<]+");
lnk=$(curl -s -L "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1" | sed -ne '/urlBase/{s/.*<urlBase>\(.*\)<\/urlBase>.*/\1/p;q;}');
url="http://www.bing.com/"$lnk"_1920x1080.jpg";
echo "Downloading: "$url;
pathimg=$HOME"/Pictures/bing.jpg";

echo "Saving in: "$pathimg;
curl -s -o $pathimg $url

#if detected Mac OS
if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'$pathimg'"'
 else
#if not Mac OS
if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]
  then
    xres=$(echo $(xfconf-query --channel xfce4-desktop --list | grep last-image))
    for x in "${xres[@]}"
    do
      xfconf-query --channel xfce4-desktop --property $x --set $pathimg
    done
  # Set the wallpaper for unity, gnome3, cinnamon.
  elif gsettings set org.gnome.desktop.background picture-uri "file://$pathimg"; then
    gsettings set org.gnome.desktop.background picture-options "zoom"
  else
    echo "$XDG_CURRENT_DESKTOP not supported."
    break
 fi
 echo "New wallpaper set for $XDG_CURRENT_DESKTOP."
fi


