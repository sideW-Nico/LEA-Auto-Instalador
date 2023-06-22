#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

repositorios="[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"

SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'

echo "${AZUL}###INSTALACION DE REPOSITORIOS###"
echo "Instalando claves del repositorio chaotic-aur...${SIN_COLOR}"

if sudo bash pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && sudo bash pacman-key --lsign-key 3056513887B78AEB && sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' ; then
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error instalando la claves del repositorio..."
  exit 1
fi

echo "${SIN_COLOR}Añadiendo chaotic-aur a /etc/pacman.conf..."

if echo $repositorios | sudo tee -a /etc/pacman.conf > /dev/null ; then
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error añadiendo chaotic-aur a /etc/pacman.conf..."
  exit 2
fi

echo "${VERDE}Repositorio agregado correctamente...${SIN_COLOR}"
exit 0
