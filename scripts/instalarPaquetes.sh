#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

#Colores
SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'

#Constantes
readonly pimeraInstalacion=0
readonly repositoriosHabilitados=1
readonly paquetesPacmanInstalados=2
readonly repositoriosAgregados=3
readonly paquetesChaoticInstalados=4
readonly paquetesYayInstalados=5
readonly paquetesInstalados=-1

rutaEstado="./estadosDelInstalador/estadoInstaladorDePaquetes.txt"
let estadoActual=$(cat $rutaEstado)

rutaPacmanConf="/etc/pacman.conf"


function habilitarRepositorios() {
	#Hay que configurar las dos lineas al mismo tiempo, de caso contrario se descomentan todos
	#los otros include por defecto del archivo que llevan al mismo mirrorlist de pacman.d
	echo "${AZUL}Habilitando repositorios multilib y extra...${SIN_COLOR}"
	if sudo sed -i -f ./scripts/multilibAnidado.sed $rutaPacmanConf && sudo sed -i -f ./scripts/extraAnidado.sed $rutaPacmanConf ; then
		echo "${VERDE}Éxito...${SIN_COLOR}"
	else
		echo "${ROJO}Error al habilitar los repositorios multilib y extra...${SIN_COLOR}"
		exit 1
	fi
}

function instalarPaquetesPacman() {
	echo "${AZUL}Instalando paquetes generales (pacman)${SIN_COLOR}"
	if sudo pacman -Syy $(cat ./packages/paquetesPacman.txt) ; then
  		echo "${VERDE}Éxito...${SIN_COLOR}"
	else
  		echo "${ROJO}Error al instalar los paquetes (pacman)${SIN_COLOR}"
  		exit 2
	fi
}

function agregarRepositorios () {
	if bash ./scripts/establecerRepositorios.sh ; then
		echo "${VERDE}###Repositorios añadidos exitosamente...${SIN_COLOR}"
	else
  		echo "${ROJO}Error añadiendo los repositorios...${SIN_COLOR}"
  	exit 3
	fi
}

function instalarPaquetesChaotic () {
	echo "${AZUL}Instalando paquetes generales (chaotic-aur repo)${SIN_COLOR}"
	if sudo pacman -Syy $(cat ./packages/paquetesChaotic.txt) ; then
  		echo "${VERDE}Éxito...${SIN_COLOR}"
	else
  		echo "${ROJO}Error al instalar los paquetes (chaotic-aur repo)${SIN_COLOR}"
  		exit 4
	fi
}

function instalarPaquetesYay () {
	echo "${AZUL}Instalando paquetes generales (yay)${SIN_COLOR}"
	if yay -Syy $(cat ./packages/paquetesYay.txt) ; then
  		echo "${VERDE}Éxito...${SIN_COLOR}"
	else
  		echo "${ROJO}Error al instalar los paquetes (yay)${SIN_COLOR}"
  		exit 5
	fi
}

function instalarNvchad () {
	echo "Instalando nvchad..."
	if git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 ; then
		echo "nvchad instalado con éxito..."
	else
  		echo "Error instalando nvchad..."
		exit 6
	fi
}

function modificarEstadoActual () {
	echo $1 > $rutaEstado
	estadoActual=$1
}

function main () {
	echo "${AZUL}###INSTALADOR DE PAQUETES${SIN_COLOR}"
	
	if [[ $estadoActual -eq $primeraInstalacion ]] ; then
		habilitarRepositorios
		modificarEstadoActual $repositoriosHabilitados
	fi

	if [[ $estadoActual -eq $repositoriosHabilitados ]] ; then
		instalarPaquetesPacman
		modificarEstadoActual $paquetesPacmanInstalados
	fi

	if [[ $estadoActual -eq $paquetesPacmanInstalados ]] ; then
		agregarRepositorios
		modificarEstadoActual $repositoriosAgregados
	fi

	if [[ $estadoActual -eq $repositoriosAgregados ]] ; then
		instalarPaquetesChaotic
		modificarEstadoActual $paquetesChaoticInstalados
	fi
	
	if [[ $estadoActual -eq $paquetesChaoticInstalados ]] ; then
		instalarPaquetesYay
		modificarEstadoActual $paquetesYayInstalados
	fi

	if [[ $estadoActual -eq $paquetesYayInstalados ]] ; then
		instalarNvchad
		modificarEstadoActual $paquetesInstalados
	fi

	exit 0
}


main
