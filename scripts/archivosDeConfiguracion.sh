#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'


echo "${AZUL}###CONFIGURACIÓN DE ARCHIVOS DEL SISTEMA${SIN_COLOR}"

echo "${AZUL}Creando directorios...${SIN_COLOR}"
if mkdir -p $HOME/.config && mkdir -p $HOME/.config/alacritty && mkdir -p $HOME/.config/qtile; then
  echo "${VERDE}Éxito...${SIN_COLOR}"
else
  echo "${ROJO}Error creando directorios...${SIN_COLOR}"
  exit 1
fi

sudo touch $HOME/.config/alacritty/alacritty.yml
sudo touch $HOME/.config/qtile/config.py
sudo touch $HOME/.config/qtile/autostart.sh
sudo chmod 700 $HOME/.config/qtile/autostart.sh
sudo chown $(whoami) $HOME/.config/qtile/autostart.sh
sudo chgrp $(whoami) $HOME/.config/qtile/autostart.sh
sudo touch $HOME/.config/picom.conf
#Hay que colocar este archivo
#sudo touch $HOME/.config/rofi/rofiPersonalizado.rasi


echo "${AZUL}Insertando/modificando archivos de configuración...${SIN_COLOR}"
if cat ../sourceFiles/alacritty.yml | sudo tee $HOME/.config/alacritty/alacritty.yml && cat ../sourceFiles/qtile/config.py | sudo tee $HOME/.config/qtile/config.py && cat ../sourceFiles/qtile/autostart.sh | sudo tee $HOME/.config/qtile/autostart.sh && cat ../sourceFiles/picom.conf | sudo tee $HOME/.config/picom.conf ; then
  echo "${VERDE}Éxito...${SIN_COLOR}"
else
  echo "${ROJO}Error insertando/modificando los archivos de configuración...${SIN_COLOR}"
  exit 2
fi

exit 0
