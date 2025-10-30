-- Warning: Esse script está definido em etapas e NÃO DEVE SER EXECUTADO EM UMA SÓ RODADA. 

CREATE DATABASE BDG_RJ_ELECTION;
CREATE EXTENSION postgis;

-- Tabela dos municipios
DROP TABLE IF EXISTS munic_tse_ibge;

create table munic_tse_ibge(
    cod_tse int,
    uf char(3),
    nome_munic varchar(200),
    capital int,
    cod_ibge int);


-- (!) Necessário importacao dos dados
-- Importação pela interface:
--      selecionar schema e tabela. botão diretiro na tabela, "Import", selecionar arquivo no explorador e configurações
--      opções: delimiter = ;, encoding = LATIN1, quote = ", header = checked
-- (pode ser feito com comandos /copy também mas possível erros a depender do Sistema Operacional utilizado).
-- após importação:

-- confirmação pode ser feita com
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'munic_tse_ibge';

-- Tabela dos votos
DROP TABLE IF EXISTS public.eleicoes_2022_rj;

CREATE TABLE public.eleicoes_2022_rj
(
    dt_geracao          text,
    hh_geracao          text,
    ano_eleicao         integer,
    cd_tipo_eleicao     integer,
    nm_tipo_eleicao     text,
    nr_turno            integer,
    cd_eleicao          integer,
    ds_eleicao          text,
    dt_eleicao          text,
    tp_abrangencia_eleicao text,
    sg_uf               text,
    sg_ue               text,
    nm_ue               text,
    cd_municipio        integer,
    nm_municipio        text,
    nr_zona             integer,
    nr_secao            integer,
    cd_cargo            integer,
    ds_cargo            text,
    nr_votavel          integer,
    nm_votavel          text,
    qt_votos            integer,
    nr_local_votacao    integer,
    sq_candidato        bigint,
    nm_local_votacao    text,
    ds_local_votacao_endereco text
);

-- (!) Necessário importacao dos dados
-- Importação pela interface:
--      selecionar schema e tabela. botão diretiro na tabela, "Import", selecionar arquivo no explorador e configurações
--      opções: delimiter = ;, encoding = LATIN1, quote = ", header = checked
-- (pode ser feito com comandos /copy também mas possível erros a depender do Sistema Operacional utilizado).
-- após importação:

ALTER TABLE public.eleicoes_2022_rj
  ALTER COLUMN dt_geracao TYPE date USING to_date(dt_geracao, 'DD/MM/YYYY'),
  ALTER COLUMN dt_eleicao TYPE date USING to_date(dt_eleicao, 'DD/MM/YYYY');

-- VERIFICAÇÃO BÁSICA!
SELECT * FROM public.eleicoes_2022_rj
LIMIT 100;


ALTER TABLE public.municipios_rj
    RENAME COLUMN CD_MUN TO cd_municipio;

-- Deputados estaduais
-- números de votação possuem 5 digitos (2 partido + 3 a mais)

DROP TABLE IF EXISTS tj_2022_depest;

CREATE TABLE tj_2022_depest AS
SELECT 
    m.cod_ibge,
    e.nr_votavel,
    e.nm_votavel,
    SUM(e.qt_votos) AS votos_total
FROM eleicoes_2022_rj e
JOIN munic_tse_ibge m
  ON e.cd_municipio = m.cod_tse
WHERE e.nr_votavel BETWEEN 10000 AND 99999
GROUP BY m.cod_ibge, e.nr_votavel, e.nm_votavel;

-- Tabela de alfabetização

DROP TABLE IF EXISTS alfabetizacao_municipios_rj;

CREATE TABLE alfabetizacao_municipios_rj (
    CD_MUN        INTEGER NOT NULL,           -- Código do IBGE
    NM_MUN        VARCHAR(255) NOT NULL,     -- Nome do município
    V00748        INTEGER,                    -- Pessoas alfabetizadas, 15 a 19 anos
    V00749        INTEGER,                    -- Pessoas alfabetizadas, 20 a 24 anos
    V00750        INTEGER,                    -- Pessoas alfabetizadas, 25 a 29 anos
    V00751        INTEGER,                    -- Pessoas alfabetizadas, 30 a 34 anos
    V00752        INTEGER,                    -- Pessoas alfabetizadas, 35 a 39 anos
    V00753        INTEGER,                    -- Pessoas alfabetizadas, 40 a 44 anos
    V00754        INTEGER,                    -- Pessoas alfabetizadas, 45 a 49 anos
    V00755        INTEGER,                    -- Pessoas alfabetizadas, 50 a 54 anos
    V00756        INTEGER,                    -- Pessoas alfabetizadas, 55 a 59 anos
    V00757        INTEGER,                    -- Pessoas alfabetizadas, 60 a 64 anos
    V00758        INTEGER,                    -- Pessoas alfabetizadas, 65 a 69 anos
    V00759        INTEGER,                    -- Pessoas alfabetizadas, 70 a 79 anos
    V00760        INTEGER,                    -- Pessoas alfabetizadas, 80 anos ou mais
    PRIMARY KEY (CD_MUN)
);

-- 