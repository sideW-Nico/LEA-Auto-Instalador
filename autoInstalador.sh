#!/bin/bash

#Útil para casos donde se necesita habilitar el manejo de caractéres especiales con echo y printf, dejando de necesitar el argumento -e
shopt -s xpg_echo

#Colores
SIN_COLOR='\033[0m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'

#Constantes
readonly primeraInstalacion=0
readonly paquetesInstalados=1
readonly sshConfigurado=2
readonly sistemaInstalado=-1

#Estados del instalador, en este espacio se especifíca la ruta y el contenido del archivo,
#los estados son identificados por los nombres de las cosntantes.
rutaEstado="./estadosDelInstalador/estadoAutoInstalador.txt"
let estadoActual=$(cat $rutaEstado)

function instalarPaquetes () {
	if bash ./scripts/instalarPaquetes.sh ; then
		echo "${VERDE}###Paquetes instalados exitosamente...${SIN_COLOR}"
	else
	echo "${ROJO}###Error al instalar los paquetes...${SIN_COLOR}"
  		exit 1
	fi
}

function configurarSSH () {
	if bash ./scripts/configuracionSSH.sh ; then
		echo "${VERDE}###SSH configurado correctamente...${SIN_COLOR}"
	else
		echo "${ROJO}###Error configurando SSH...${SIN_COLOR}"
		exit 2
	fi
}

function agregarArchivosDeConfiguracion () {
	if bash ./scripts/archivosDeConfiguracion.sh ; then
  		echo "${VERDE}###Archivos del sistema configurados correctamente...${SIN_COLOR}"
	else
  		echo "${VERDE}###Error configurando los archivos del sistema${SIN_COLOR}"
  		exit 3
	fi
}

function reanudarInstalacion () {
	if [[ $estadoActual -gt 0 ]]; then
		while : ; do
			echo "${SIN_COLOR}Reanudar desde el último punto? [S/n]:"
			read confirmacion
			if [[ $confirmacion =~ ^[sS]$ ]] ; then
				break
			elif [[ $confirmacion =~ ^[nN]$ ]] ; then
				echo "0" > $rutaEstado
				finalizarInstalacion
			else
				echo "Debe ingresar {s,S}..."
			fi
		done
	fi
}

function modificarEstadoActual () {
	echo $1 > $rutaEstado
	$estadoActual=$(cat $rutaEstado)
}

function finalizarInstalacion (){
	echo "${AZUL}###AUTO INSTALADOR FINALIZADO SIN ERRORES###${SIN_COLOR}"
	exit 0
}

function main () {
	echo "${AZUL}###AUTO INSTALADOR (por Leandro López)###${SIN_COLOR}"

	reanudarInstalacion
	if [[ $estadoActual -eq $primeraInstalacion ]] ; then
		instalarPaquetes
		modificarEstadoActual $paquetesInstalados
	fi

	if [[ $estadoActual -eq $paquetesInstalados ]] ; then
		configurarSSH
		modificarEstadoActual $sshConfigurado
	fi

	if [[ $estadoActual -eq $sshConfigurado ]] ; then
		agregarArchivosDeConfiguracion
		modificarEstadoActual $sistemaInstalado
	fi

	finalizarInstalacion
}

main
