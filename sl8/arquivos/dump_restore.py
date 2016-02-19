#!/usr/bin/env python
#===============================================================================
# AUTOR       : Gustavo Soares <gustavo@ailti.com.br>
# DATA        : Seg 17/Nov/2014 hs 18:14
# SHELL       : dump_restore.py
# DESCRICAO   : substituto do dump_restore.php
# DEPENDENCIA :
#===============================================================================
import subprocess, os
from optparse import OptionParser
from sys import exit
from datetime import datetime
from commands import getoutput

def help():
    """Funcao de help do dump_restore.py"""
    print """
dump_restore - utilitario que gera/restaura um dump do banco de dados.

Sintaxe:
          dump_restore.py --acao=CRIAR/RESTAURAR --arquivo=ARQUIVO.DMP --banco=NOME_DO_BANCO --pgsql=VERSAO_DO_BANCO

Exemplos:
          Para CRIAR um dump do banco contab0 usando o postgresql 8.2:
            # dump_restore.py --acao=CRIAR --arquivo=contab0.dmp --banco=contab0 --pgsql=8

          Para RESTAURAR um dump do banco contab0 usando o postgresql 9.4:
            # dump_restore.py --acao=RESTAURAR --arquivo=contab0.dmp --banco=contab0 --pgsql=9
        
"""
    exit(1)

def testa(pgsql):
    """Funcao responsavel por verificar se o banco esta online"""
    print "AGUARDE\n=======\n"
    #if os.path.exists('/etc/init.d/postgresql'):
    #    comando="/etc/init.d/postgresql"
    #else:
    #    comando="/etc/init.d/postgresql-8.2"
    
    #if getoutput("%s status | awk '/^%s/{print $4}'" %(comando, pgsql)) == "online":
    #    pass
    #else:
    #    print "ERRO AO CONECTAR NO BANCO POSTGRESQL ", pgsql
    #    exit(1)

def criar(d_inicial, arquivopath, arquivolog, banco, porta, pgsql):
    """Funcao que ira fazer o dump do banco."""
    testa(pgsql)
    print "Opcao selecionada      : Criar"
    print "Data Inicial           : " + d_inicial
    print "Nome do banco          : " + banco
    print "Versao do banco        : " + pgsql
    print "Nome do arquivo        : " + arquivopath
    print "Nome do arquivo de log : " + arquivolog
    print "\nFazendo copia completa do Banco de Dados %s..." %banco
    getoutput('/usr/lib/postgresql/%s/bin/pg_dump -U postgres -Z9 -v -Fc -p%s -f %s %s 2> %s' %(pgsql, porta, arquivopath, banco, arquivolog))

def restaurar(d_inicial, arquivopath, arquivolog, banco, porta, pgsql):
    """Funcao que ira fazer o restore."""
    testa(pgsql)
    print "Opcao selecionada      : Restaurar"
    print "Data Inicial           : " + d_inicial
    print "Nome do banco          : " + banco
    print "Versao do banco        : " + pgsql
    print "Nome do arquivo        : " + arquivopath
    print "Nome do arquivo de log : " + arquivolog
    
    if ( not os.path.isfile(arquivopath)):
        print "\n\nERRO, O ARQUIVO %s NAO EXISTE." %arquivopath
        exit(1)

    if getoutput('psql -Alt -U postgres -p%s | egrep -wc "%s"' %(porta, banco)) == "1":
        if raw_input('\nO Banco %s exites, deseja recria-lo?[s/n] ' %banco) == 's':
            print "Recriando o banco %s." %banco
            getoutput('/usr/lib/postgresql/%s/bin/dropdb -U postgres -p%s %s' %(pgsql, porta, banco))
            getoutput('/usr/lib/postgresql/%s/bin/createdb -U postgres -p%s -E LATIN1 -T template1 %s' %(pgsql, porta, banco))
            getoutput('/usr/lib/postgresql/%s/bin/pg_restore -U postgres -Fc -v -p%s -d %s %s 2> %s' %(pgsql, porta, banco, arquivopath, arquivolog))
        else:
            print "\n\nERRO, BANCO DE DADOS %s EXISTE E VOCE NAO QUIS RECRIA-LO." %banco
            exit(1)
    else:
        getoutput('/usr/lib/postgresql/%s/bin/createdb -U postgres -p%s -E LATIN1 -T template1 %s' %(pgsql, porta, banco))
        getoutput('/usr/lib/postgresql/%s/bin/pg_restore -U postgres -Fc -v -p%s -d %s %s 2> %s' %(pgsql, porta, banco, arquivopath, arquivolog))

def main():
     """Funcao principal que faz chamada as demais."""
     uso = ('dump_restore.py --acao=CRIAR/RESTAURAR --arquivo=ARQUIVO.DMP --banco=NOME_DO_BANCO --pgsql=VERSAO_DO_BANCO_DE_DADOS')
     parser = OptionParser(usage=uso)
     parser.add_option('--acao', help='A acao que voce quer, CRIAR ou RESTAURAR')
     parser.add_option('--arquivo', help='nome do ARQUIVO.DMP')
     parser.add_option('--banco', help='nome do BANCO que voce deseja')
     parser.add_option('--pgsql', help='pgsql do BANCO de dados, opcoes: 8 e 9.')
     (opcoes, args) = parser.parse_args()
    
     if ((opcoes.acao and opcoes.arquivo and opcoes.banco and opcoes.pgsql)) is None:
         help()

     d_inicial=datetime.now().strftime('%d/%m/%Y %H:%M')
     #arquivopath=os.getcwd()+"/"+opcoes.arquivo
     #arquivolog=os.getcwd()+"/"+opcoes.arquivo+".log"
     arquivopath=opcoes.arquivo
     #arquivolog=opcoes.arquivo+".log"
     arquivolog=opcoes.arquivo+"_"+opcoes.acao.lower()+".log"
     
     banco=opcoes.banco.lower()
     if opcoes.pgsql == "8":
        porta="5432"
        pgsql="8.2"
     elif opcoes.pgsql == "9":
        porta="5433"
        pgsql="9.4"
        
     if opcoes.acao.lower() == "criar":
         criar(d_inicial, arquivopath, arquivolog, banco, porta, pgsql)
     elif opcoes.acao.lower() == "restaurar":
         restaurar(d_inicial, arquivopath, arquivolog, banco, porta, pgsql)
     else:
         help()

if __name__ in '__main__':
    if os.getuid()!=0:
        print "\n\nERRO, VOCE PRECISA SER ROOT PARA EXECUTAR ESSE PROGRAMA."
        exit(1)
    main()
    print "\nData Final             : " + datetime.now().strftime('%d/%m/%Y %H:%M')
