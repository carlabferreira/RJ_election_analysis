# RJ Election 2022 Analysis
Trabalho Prático da Disciplina Banco de Dados Geográficos na UFMG em 2025/2. 

Análise espacial da votação de deputado estadual no estado do Rio de Janeiro em 2022, comparando com dados socioeconmicos de escolaridade/alfabetização e dados de criminalidade agrupados por municipio.

## Conteúdo apresentado:
1. [Integrantes do grupo](#integrantes-do-grupo)
2. [Enunciado](#enunciado)
3. [Documentação](#documentação)
4. [Fontes de dados](#fonte-de-dados)
5. [Instruções de instalação e execução para reprodutividade dos testes](#intruções-de-instalação-e-execução)

    5.1. [Adicionando dados em tabelas](#adicionando-dados-em-tabelas) 

    5.2. [Visualização no QGIS](#visualização-dos-dados-no-qgis)

## Integrantes do grupo:
- Ana Luisa Messias Ferreira Mendes
- Carla Beatriz Ferreira
- Clara Garcia Tavares
- Filipe Mauro da Terra Caldeira

## Enunciado
O enunciado do trabalho prático está disponível em [AUXILIARES/Enunciado.pdf](./AUXILIARES/Enunciado.pdf)

## Documentação
A documentação está organizada em duas partes, seguindo o especificado pelo enunciado.
A parte I está disponível em https://docs.google.com/document/d/1sFVS7tWvMS8REUltiS8Mdkl9BEqp0kmWNaqbILLi1dM/edit?usp=sharing

## Fonte de dados
- Dados eleitorais: Portal de dados abertos do TSE - https://dadosabertos.tse.jus.br/dataset/resultados-2022
- Alfabetização: CENSO 2022 - https://www.ibge.gov.br/estatisticas/sociais/saude/22827-censo-demografico-2022.html?=&t=downloads
- Estatísticas de segurança: Dados Abertos GOV - https://dados.gov.br/dados/conjuntos-dados/isp-estatisticas-de-seguranca-publica (Série histórica mensal por município desde 2014)
- Malha Geométrica: Dados Abertos GOV - https://dados.gov.br/dados/conjuntos-dados/malha-geometrica-dos-municipios-brasileiros (Malha geométrica dos municípios do Rio de Janeiro (RJ) em 2010)

## Intruções de instalação e execução
### Aplicativos necessários: 
1. PostgreSQL (+ pgadmin + postgis)
Observação: A senha utilizada durante as configurações será necessária! 
- Referência para orientações de instalação em: https://postgis.net/workshops/postgis-intro/installation.html (Introduction to PostGIS - Capítulo 3: Instalação). Ver também capítulo 4 (Criando um banco de dados espacial), que contém a ativação da extensção _postgis_.

2. QGIS
- Referência para instalação em: https://qgis.org/resources/installation-guide/ (QGIS Installation Guide), sendo utilziada a versão Windows Desktop (offline) 3.44.4

### Adicionando dados em tabelas
É possível adicionar dados a partir de arquivos .csv apenas com comandos de texto, entretando, a solução mais simples encontrada foi criando as tabelas com comandos SQL e adicionando os arquivos a partir da interface do pgAdmin.

O código necessário para a criação das tabelas está disponível em [./AUXILIARES/Scripts/Create_table.sql](./AUXILIARES/Scripts/Create_table.sql)
- Ref. para criação das tabelas com código: [Slides da disciplina](/AUXILIARES/Slide_BDG_CDG_03_b%20Analise.pdf) pelo professor dr. Clodoveu Davis, páginas 15 e 16.
- Ref. para importação de dados com código: [Slides da disciplina](/AUXILIARES/Slide_BDG_CDG_03_b%20Analise.pdf) pelo professor dr. Clodoveu Davis, página 15.

Para importação a partir da interface clique com o botão direito em cima do título da tabela e em "Import/Export Data".
- Ref. para importação no pgAdmin: https://www.pgadmin.org/docs/pgadmin4/latest/import_export_data.html (Documentação do pgAdmin: Import/Export Data)

Os dados geométricos/geográficos a partir dos arquivos de malhas serão importados diretamente no QGIS.

### Visualização dos dados no QGIS
Para conexão entre o QGIS e as tabelas criadas a partir do pgAdmin é necessário que com ambos aplicativos abertos seja feita a conexão. É necessário saber a senha de criação do servidor usada durante a instalção.

Um passo a passo básico está descrito abaixo.
1. No QGIS, clique com o botão direito em "PostGreSQL" no menu de "Navegagor" na lateral esquerda

<p align="center">
  <img src=".//AUXILIARES/imgs/image_1.png" alt="Opção PostGreSQL no menu de Navegagor" width="300">
</p>

2. Selecione a opção "Nova Conexão" e forneça as informações solicitadas.

<p align="center">
  <img src=".//AUXILIARES/imgs/image_2.png" alt="Exemplo de preenchimento das informações de conexão" width="300">
</p>

3. Clique em "Testar Conexão" e então em "OK"

- A conexão estará feita!

Para adicionar os dados geográficos no QGIS faça o seguinte:
1. Tendo em mãos o arquivo shapefile da malha municipal (a partir do site do IBGE ou já baixado em [DADOS/MalhaGeometrica](./DADOS/MalhaGeometrica/rj_municipios/33MUE250GC_SIR.shp)), localize as opções "Database" e "Gerenciador de BD"

<p align="center">
  <img src=".//AUXILIARES/imgs/image_3.png" alt="Opções Database e Gerenciado de BD no QGIS" width="500">
</p>

2. Selecione a sua conexão com o banco (BDG_RJ_ELECTION)
3. Clique em Import Layer/File (ou Import Layer → File)
4. Preencha as informações a seguir na janela que abrir:

| Opção | Preenchimento | 
| --- | --- |
| Input | escolha o shapefile (.shp) do município do RJ |
| Schema | public |
| Table | municipios_rj |
| Primary key | id (ou deixe criar automática) |
| SRID | 4674 (do shapefile) |
| Create spatial index | - [x] |

Clique OK e a tabela será criada no PostgreSQL com geometria.

Inicialmente, a exibição no QGIS (configurado para exibir tabelas não geográficas também) será como a apresentada abaixo:
<p align="center">
  <img src=".//AUXILIARES/imgs/image_4.png" alt="Tela do QGIS após import" width="600">
</p>
