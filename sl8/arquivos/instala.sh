#!/bin/bash
# vi:si:et:sw=4:sts=4:ts=4
#===============================================================================
# AUTOR       : Gustavo Soares <gustavo@ailti.com.br>
# DATA        : Sex 19/Jun/2015 hs 13:42
# SHELL       : instala.sh
# DESCRICAO   : instala o php4 e o apache 2.2 no debian 8
# DEPENDENCIA : 
#===============================================================================

mkdir -p /root/tmp

# Para o php4 
#mkdir -p /etc/php4/apache2
mkdir -p /{usr,lib}/kerberos
ln -sf /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
ln -sf /usr/lib/x86_64-linux-gnu/libXpm.so /usr/lib
ln -sf /usr/lib/x86_64-linux-gnu/libtiff.so.4 /usr/lib
ln -sf /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib
ln -sf /usr/lib/x86_64-linux-gnu /usr/kerberos/lib
ln -sf /usr/include/freetype2/freetype.h /usr/lib

# PHP4
#tar jxvf php-4.4.9.tar.bz2 -C /root/tmp
### PHP4
#(pv -n arquivos/php-4.4.9.tar.bz2 | tar jxf -  -C /root) 2>&1 | whiptail --title "${TITULO}" --backtitle "${BANNER}" --gauge "         Aguarde descompactando php4." 10 50 0
cp configure /root/tmp/php-4.4.9
cd /root/tmp/php-4.4.9
./configure --prefix=/opt \
--datadir=/opt/usr/share/php4 \
--libdir=/opt/usr/share \
--includedir=/opt/usr/include \
--bindir=/opt/usr/bin \
--mandir=/opt/usr/share \
--with-config-file-path=/opt/etc/php4 \
--with-pdo-pgsql \
--with-zlib-dir=/usr/lib \
--with-freetype-dir=/usr/include/freetype2 \
--with-libxml-dir=/usr/lib \
--with-curl \
--with-mcrypt \
--with-gd \
--with-pgsql \
--with-bz2 \
--with-zlib \
--with-mhash \
--with-pcre-regex \
--with-png-dir=/usr/lib \
--with-jpeg-dir=/usr/lib \
--with-tiff-dir=/usr/lib \
--with-ttf-dir=/usr/lib \
--with-xpm-dir=/usr/lib \
--with-imap \
--with-imap-ssl \
--with-gettext \
--with-iconv \
--with-kerberos \
--with-ftp \
--without-pear \
--enable-gd-imgstrttf \
--enable-gd-native-ttf \
--enable-mbstring \
--enable-mbregex \
--enable-ftp \
--enable-memory-limit \
--enable-safe-mode \
--enable-bcmath \
--enable-calendar \
--enable-ctype \
--enable-magic-quotes \
--enable-inline-optimization \
--enable-soap \
--enable-calendar \
--enable-sockets \
--enable-sysvsem \
--enable-sysvshm \
--enable-pcntl \
--enable-mbregex \
--enable-zip \
--enable-gd-native-ttf \
--enable-ftp \
--enable-fastcgi
make -j2 
make -j2 install

## APACHE2
#cp arquivos/default /etc/apache2/sites-available/
#cp arquivos/default-ssl /etc/apache2/sites-available/
#cp arquivos/charset /etc/apache2/conf.d/
#cp arquivos/security /etc/apache2/conf.d/
#tar jxf arquivos/zend-3.3.0a-linux-glibc21-i386.tar.bz2 -C /
#chmod -R 777 /usr/local/Zend
#chown -R root. /usr/local/Zend
#rm -f /usr/local/Zend/etc/php.ini
#cp arquivos/php.ini /usr/local/Zend/etc/
#ln -sf /usr/local/Zend/etc/php.ini /etc/php4/apache2/php.ini
#

