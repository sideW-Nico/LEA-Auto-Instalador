#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'

echo "${AZUL}###AUTO INSTALADOR (por Leandro López)###${SIN_COLOR}"

if bash ./scripts/instalarPaquetes.sh ; then
  echo "${VERDE}###Paquetes instalados exitosamente...${SIN_COLOR}"
else
  echo "${ROJO}###Error al instalar los paquetes...${SIN_COLOR}"
  exit 1
fi


