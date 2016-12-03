#!/bin/bash

bing="www.bing.com"

# Parametros válidos: pt-BR, en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA.
xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=pt-BR"

#$saveDir é usado para difinir o destino onde as imagens do Bing seram salvas
saveDir=$HOME'/Bing/bingwallpapers/'

# Criar pasta se ela não existir
mkdir -p $saveDir

# Definir proporção imagem
# Parametros válidos: none,wallpaper,centered,scaled,stretched,zoom,spanned
picOpts="zoom"

# Resolução da imagem
# Parametros válidos: "_1024x768" "_1280x720" "_1366x768" "_1920x1200"
desiredPicRes="_1920x1200"
picExt=".jpg"

desiredPicURL=$bing$(echo $(curl -s $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$desiredPicRes$picExt
defaultPicURL=$bing$(echo $(curl -s $xmlURL) | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

if wget --quiet --spider "$desiredPicURL"
then
    picName=${desiredPicURL##*/}
    curl -s -o $saveDir$picName $desiredPicURL
else
    picName=${defaultPicURL##*/}
    curl -s -o $saveDir$picName $defaultPicURL
fi

#Envia notificação sobre o tema da imagem
titulo=$(echo $(curl -s $xmlURL) | grep -oP "<copyright>(.*)</copyright>" | cut -d ">" -f 2 | cut -d "(" -f 1)
descricao="É o tema de seu Wallpaper hoje."
notify-send "$titulo" "$descricao" --icon=dialog-information

#Definir como papel de parede
gsettings set org.gnome.desktop.background picture-uri $saveDir$picName

#Definir como plano de fundo de tela de bloqueio
gsettings set org.gnome.desktop.screensaver picture-uri $saveDir$picName

exit
