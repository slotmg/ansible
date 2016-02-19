/*
Autor     : Guilherme Augusto da Rocha Silva
Data      : 01/11/2005
Sistema   : SCM - Materiais (Licitações, Compras, Patrimonio, Almoxarifado, Frotas).
Objetivo  : Criação de grupos e usuários.
Observação: O SYSID não pode ser mais forçado na criação de grupos e usuários
            a partir do PostgreSQL 8.x.x.
Release   : 200604171130
*/

\t
\o /tmp/comum_grupos_usuarios.sql.tmp.1
SELECT '-- Gerado em      : ' || current_timestamp
    || '-- Base de dados  : ' || current_database()
    || '-- Nome do usuário: ' || current_user
    || '-- Versão do SGBD : ' || version()
;

--------------------------------------------------------------------------------
-- Criação dos usuários dos sistemas.
--------------------------------------------------------------------------------
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'nobody'::TEXT AS nome           , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'nobody'           ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'contabilidade'::TEXT AS nome    , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'contabilidade'    ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'controle_interno'::TEXT AS nome , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'controle_interno' ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'folha'::TEXT AS nome            , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'folha'            ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'integracao'::TEXT AS nome       , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'integracao'       ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'material'::TEXT AS nome         , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'material'         ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'ocorrencia'::TEXT AS nome       , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'ocorrencia'       ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'processo'::TEXT AS nome         , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'processo'         ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'tributo'::TEXT AS nome          , COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'tributo'          ) AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE USER ' || existe.nome  || ';' END FROM (SELECT 'tributo_auditoria'::TEXT AS nome, COUNT(*) AS quantidade FROM pg_catalog.pg_user WHERE usename = 'tributo_auditoria') AS existe;

--------------------------------------------------------------------------------
-- Criação dos grupos de usuários dos sistemas.
--------------------------------------------------------------------------------
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'contabilidade'::TEXT AS nome    , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'contabilidade') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'controle_interno'::TEXT AS nome , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'controle_interno') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'folha'::TEXT AS nome            , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'folha') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'integracao'::TEXT AS nome       , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'integracao') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'material'::TEXT AS nome         , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'material') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'ocorrencia'::TEXT AS nome       , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'ocorrencia') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'processo'::TEXT AS nome         , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'processo') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'tributo'::TEXT AS nome          , COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'tributo') AS existe;
SELECT CASE WHEN existe.quantidade = 0 THEN 'CREATE GROUP ' || existe.nome || ';' END FROM (SELECT 'tributo_auditoria'::TEXT AS nome, COUNT(*) AS quantidade FROM pg_catalog.pg_group WHERE groname = 'tributo_auditoria') AS existe;

\o
\t
\i /tmp/comum_grupos_usuarios.sql.tmp.1
\! rm -vf /tmp/comum_grupos_usuarios.sql.tmp.1

--------------------------------------------------------------------------------
-- Ajustes após a criação de usuários e grupos.
--------------------------------------------------------------------------------
\t
\o /tmp/comum_grupos_usuarios.sql.tmp.2
SELECT '-- Gerado em      : ' || current_timestamp
    || '-- Base de dados  : ' || current_database()
    || '-- Nome do usuário: ' || current_user
    || '-- Versão do SGBD : ' || version()
;

-- Vinculação dos usuários com seus respectivos esquemas.
SELECT 'ALTER GROUP ' || g.groname || ' ADD USER nobody;'
    || 'ALTER GROUP ' || g.groname || ' ADD USER ' || u.usename || ';'
  FROM pg_catalog.pg_user u
  JOIN pg_catalog.pg_group g ON (u.usename = g.groname)
;
\o
\t
\i /tmp/comum_grupos_usuarios.sql.tmp.2
\! rm -vf /tmp/comum_grupos_usuarios.sql.tmp.2
