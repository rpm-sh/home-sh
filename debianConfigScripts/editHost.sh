#!/bin/bash
# remove specified host from /etc/hosts
removehost() {
    if [ $name ];
    then
	echo $name
        local HOSTNAME=$name
        if [ -n "$(grep $HOSTNAME /etc/hosts)" ];
        then
            echo "$HOSTNAME econtrado en tu fichero /etc/hosts, borrando..."
            sudo sed -i".bak" "/$HOSTNAME/d" /etc/hosts
        else
            echo "$HOSTNAME no encontrado /etc/hosts"
        fi
    else
        echo "Error: No has introducido ningun parametro."
        echo "uso: "
        echo " removehost hostname"
    fi
}

#change hostname
changename() {
    if [ $domain ];
    then
        IP="127.0.1.1"
        HOSTNAME=$name
		DOMAIN=$domain
        if [ -n "$(grep $HOSTNAME /etc/hosts)" ];
            then
                echo "$HOSTNAME ya existe:";
                echo $(grep $HOSTNAME /etc/hosts);
            else
                echo "Cambiando $HOSTNAME en tu fichero /etc/hosts";
                printf "%s\t%s\n" "$IP" "$HOSTNAME"".""$DOMAIN" "$HOSTNAME" | sudo tee -a /etc/hosts > /dev/null;
				echo "ejecutando systemctl"
				sudo hostnamectl set-hostname "$HOSTNAME"".""$DOMAIN";
                if [ -n "$(grep $HOSTNAME /etc/hosts)" ];
                    then
                        echo "$HOSTNAME agregado correctamente a /etc/hosts:";
                        echo $(grep $HOSTNAME /etc/hosts);
                    else
                        echo "Error al agregar $HOSTNAME, prueba de nuevo!";
                fi
        fi
    else
        echo "Error: No has introducido ningun parametro."
        echo "uso: "
        echo " changename hostname domain"
    fi
}
#add new ip host pair to /etc/hosts
addhost() {
    if [ $ip && $name && $domain ]
    then
        IP=$ip
        HOSTNAME=$name
	DOMAIN=$domain
        if [ -n "$(grep $HOSTNAME /etc/hosts)" ];
            then
                echo "$HOSTNAME ya existe:";
                echo $(grep $HOSTNAME /etc/hosts);
            else
                echo "Agregando $HOSTNAME a tu fichero /etc/hosts";
                printf "%s\t%s\n" "$IP" "$HOSTNAME"".""$DOMAIN" "$HOSTNAME" | sudo tee -a /etc/hosts > /dev/null;
                if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
                    then
                        echo "$HOSTNAME agregado correctamente:";
                        echo $(grep $HOSTNAME /etc/hosts);
                    else
                        echo "Error al agregar $HOSTNAME, prueba de nuevo!";
                fi
        fi
    else
        echo "Error: No has introducido ningun parametro."
        echo "uso: "
        echo " addhost ip hostname domain"
    fi
}

if [ $1 ]
   then
	if [ $1 = "changename" ];
	   then
		name=$2
		domain=$3
		changename $name $domain
	fi

	if [ $1 = "addhost" ];
	   then
		ip=$2
		name=$3
		domain=$4
		addhost $ip $name $domain
	fi

	if [ $1 = "removehost" ];
	   then
		name=$2
		removehost $name
	fi
	
	if [ $1 != "changeme" ] || [ $1 != "changeme" ] || [ $1 != "changeme" ];
	  then
		echo "No has elgido una función válida"
		echo "		changename + name + domain"
		echo "		addhost + ip + name + domain"
		echo "		removehost + name"
	fi
else
	echo "No has introducido ningún parametro"
	echo "funciones:"
	echo "		changename + name + domain"
	echo "		addhost + ip + name + domain"
	echo "		removehost + name"
fi
