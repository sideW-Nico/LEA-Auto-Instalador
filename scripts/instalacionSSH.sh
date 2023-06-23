#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'

let sshdLocal = "../sourceFiles/sshd"
let sshdDestino = "/etc/pam.d/sshd"

let sshd_configLocal = "../sourceFiles/sshd_config"
let sshd_configDestino = "/etc/ssh/sshd_config"

echo "${AZUL}###INSTALACION SSH"
echo "Activando servicios de sshd...${SIN_COLOR}"

if sudo bash systemctl enable sshd.service && sudo bash systemctl start sshd.service ; then
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error al activar los servicios de sshd..."
  exit 1
fi

echo "${AZUL}Seleccione el número del puerto: ${SIN_COLOR}"
let puertoNuevo
read -r $puertoNuevo

let puertoViejo = cat $sshd_configLocal | grep "Port [0-9]*" | cut -d " " -f2

echo "${AZUL}Cambiando el número del puerto...${SIN_COLOR}"
if sudo bash cat sed -i "s%Port\ $puertoViejo%Port\ $puertoNuevo%g" $sshd_configLocal then ;
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error cambiando el número del puerto..."
  exit 2
fi

echo "${AZUL}Estableciendo información de sshd_config y sshd${SIN_COLOR}"
if sudo bash cat $sshd_configLocal > $sshd_configDestino && sudo bash cat $sshdLocal > $sshdDestino ; then
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error estableciendo información de sshd_config y sshd..."
  exit 3
fi

echo "${AZUL}Configurando Google Authenticator...${SIN_COLOR}"
if sudo bash google-authenticator ; then
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error configurando Google Authenticator..."
  exit 4
fi

echo "${AZUL}Reiniciando el servicio sshd${SIN_COLOR}"
if sudo bash systemctl restart sshd.service ; then
  echo "${VERDE}Exito..."
else
  echo "${ROJO}Error al reiniciar el servicio sshd"
  exit 4
fi

echo "${VERDE}###Instalación de ssh realizada correctamente...${SIN_COLOR}"
exit 0
