#!/bin/bash
# vi:si:et:sw=4:sts=4:ts=4
#===============================================================================
# AUTOR       : Gustavo Soares <slot.mg@gmail.com>
# DATA        : Ter 20/Out/2015 hs 14:06
# SHELL       : |FILENAME| 
# DESCRICAO   : 
# DEPENDENCIA : 
#===============================================================================

echo "=> CONFIGURANDO REPOSITORIO"
echo "
deb http://http.debian.net/debian jessie main contrib non-free
deb http://http.debian.net/debian jessie-updates main contrib non-free
deb http://security.debian.org/ jessie/updates main contrib non-free
" > /etc/apt/sources.list
echo "=> EXECUTANDO UPDATE"
apt-get update
apt-get upgrade -y
echo "=> INSTALANDO NGINX"
apt-get install nginx screen vim -y
