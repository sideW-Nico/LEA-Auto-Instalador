#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'

rutaPacmanConf="/etc/pacman.conf"


echo "${AZUL}###INSTALADOR DE PAQUETES${SIN_COLOR}"

#Hay que configurar las dos lineas al mismo tiempo, de caso contrario se descomentan todos los otros include por defecto del archivo que llevan al mismo mirrorlist de pacman.d
echo "${AZUL}Habilitando repositorios multilib y extra...${SIN_COLOR}"
if sudo sed -i -f ./multilibAnidado.sed $rutaPacmanConf && sudo sed -i -f ./extraAnidado.sed $rutaPacmanConf ; then
	echo "${VERDE}Éxito...${SIN_COLOR}"
else
	echo "${ROJO}Error al habilitar los repositorios multilib y extra...${SIN_COLOR}"
	exit 1
fi

echo "${AZUL}Instalando paquetes generales (pacman)${SIN_COLOR}"
if sudo pacman -Syy $(cat ./packages/paquetesPacman.txt) ; then
  echo "${VERDE}Éxito...${SIN_COLOR}"
else
  echo "${ROJO}Error al instalar los paquetes (pacman)${SIN_COLOR}"
  exit 2
fi

# Añadiendo repositorios
if bash ./scripts/establecerRepositorios.sh ; then
  echo "${VERDE}###Repositorios añadidos exitosamente...${SIN_COLOR}"
else
  echo "${ROJO}Error añadiendo los repositorios...${SIN_COLOR}"
  exit 3
fi

echo "${AZUL}Instalando paquetes generales (chaotic-aur repo)${SIN_COLOR}"
if sudo pacman -Syy $(cat ./packages/paquetesChaotic.txt) ; then
  echo "${VERDE}Éxito...${SIN_COLOR}"
else
  echo "${ROJO}Error al instalar los paquetes (chaotic-aur repo)${SIN_COLOR}"
  exit 4
fi

echo "${AZUL}Instalando paquetes generales (yay)${SIN_COLOR}"
if yay -Syy $(cat ./packages/paquetesYay.txt) ; then
  echo "${VERDE}Éxito...${SIN_COLOR}"
else
  echo "${ROJO}Error al instalar los paquetes (yay)${SIN_COLOR}"
  exit 5
fi

echo "Instalando nvchad..."
if git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 ; then
  echo "nvchad instalado con éxito..."
else
  echo "Error instalando nvchad..."
  exit 6
fi

exit 0
