<div align="left">  
    <img height="30px" <img src="https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white" alt="Azure" />
    <img height="30px" <img src="https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white" alt="Azure" />
    <img height="30px" src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=power-bi&logoColor=black" alt="Power BI" >
    <h2> Azure-Power BI-ETL</h2>
    <p> Projeto desafio DIO de conexão Power BI com Azure PostgreSQL e ETL em Power BI.</p>
</div>

---

<p align="justify" >
    O presente projeto consistiu em elaborar um ecossistema de armazenamento de dados em nuvem, configurando o setup de banco de dados na Azure; popular o servidor de acordo com scipt SQL fornecido, integrar o MySQL (PostgreSQL, no presente caso) com Power BI e realizar transformações indicadas.
    O material disponibilizado pela DIO consiste nos <a href="https://academiapme-my.sharepoint.com/:p:/g/personal/renato_dio_me/EdffxWqDbGVJot3p7_g_NVUBShVwWq09KWr-PGW_aAegdw?e=bLRfjv">slides do desafio</a>, <a href="https://academiapme-my.sharepoint.com/:w:/g/personal/renato_dio_me/EVxAxO7akV5FoNy3mOk_3QwB3wKeyXMaFUi3ekTLQkY_sA?e=eJc3La">arquivo de instruções</a> e <a href="https://github.com/julianazanelatto/power_bi_analyst/tree/b010c1874a183a0fb4b831e76dc68b9b872becec/M%C3%B3dulo%203/Desafio%20de%20Projeto">queries</a> para construção do dataset.
</p>

---

<h3>SETUP DO PROJETO</h3>

<p align="justify" >
    Decidi pelo uso de PostgreSQL ao invés de MySQL por estar alinhado com outros estudos e minhas atividades profissionais no momento. Assim, iniciei o projeto pela criação de uma instância na Azure para PostgreSQL. Uma vez criada a instância, observei e adaptei as queries disponibilizadas a fim de a sintaxe fosse coerente para a ferramenta (<a href="https://github.com/hugodamasceno/azure-pbi-etl/tree/90cc8d11f31018f8ca1f4a15990762259820666b/queries">novas queries</a>).
    Para executar as queries, fiz uso de um <a href="https://github.com/hugodamasceno/azure-pbi-etl/tree/90cc8d11f31018f8ca1f4a15990762259820666b/code">script em Python</a> que faz uso das credenciais do usuário para criar uma conexão e executar as queries disponibilizadas nos arquivos disponibilizados, tanto para criação das tabelas e seus respectivos vínculos quanto para a inserção dos dados propostos.
    Assim, prossegui realizando uma conexão entre o <a href="">Power BI</a> e a base de dados na Azure, importando os dados para devido tratamento no editor do Power Query, fazendo uso da linguagem M. A escolha da importação se deu por se tratar de um dataset que dificilmente tomará proporções para tornar inviável a importação para se trabalhar com os dados diretamente no Power BI, desempenhando melhor performance. Para datasets que apresentem alta volumetria de dados, na ordem de Gb, o directquery se tornaria vantajoso, buscando apenas os dados a serem visualizados.
</p>

---

<h3>OS DADOS</h3>

<p>
Os dados descreve detalhes de uma empresa fictícia contando com quatro tabelas inicialmente:<br>
    </p>
    
- colaboradores (employee);
- dependentes dos colaboradores (dependent);
- departamentos (department);
- projetos (project);
- horas trabalhadas nos projetos (hands_on);
- localização dos departamentos (dept_location).

<p align="justify"> Em primeiro momento, foi realizado uma checagem na integridade dos dados e feito padronização dos valores de identificação para o tipo texto. Os nomes das colunas e demais tipos foram mantidos de maneira a não ser inserido etapas redundantes ao longo do ETL, e assim o processo pode ser otimizado através da elaboração de processos de mudança de tipagem e nomeclatura uma única vez ao final. Desta forma garanto um código mais limpo, fácil de realizar manutenções e melhor performance.<br><br>
    
A tabela departamento foi duplicada, dando origem à tabela department_inactive, que teve sua carga desabilitada, e foi utilizada para realizar uma mesclagem com a tabela de colaboradores a fim de adicionar o nome dos departamentos a que cada colaborador estava vinculado.<br><br>
A tabela de departamento foi mesclada com a tabela de localização dos departamentos, mantendo departamento a esquerda e realizando um join completo, de tal forma que o departamento que aparece em mais de uma cidade teve o número de registros aumentado para cada cidade. Desta forma, para manter uma identidade dos registros, foi criado uma coluna calculada com o valor igual à concatenação do nome do departamento à cidade em que estava localizada. A tabela de localização também teve sua carga desabilitada.<br><br>
    
Na tabela de colaboradores, foi realizado uma divisão da coluna endereço entre número, rua, cidade e estado. Esta divisão permitiu identificar a divergência entre local de moradia e trabalho dos colaboradores.<br><br>

A seguir, foi calculado uma nova coluna concatenando nome e sobrenome dos colaboradores em um nome completo. Ainda na tabela de colaboradores, foi realizado uma mescla dela com ela mesma, usando os códigos dos supervisores de cada colaborador para a tabela da esquerda e relacionando com os códigos dos próprios colaboradores da tabela da direita, efetuando um left-join, o qual foi responsável por trazer nome completo dos respectivos supervisores.<br><br>
Já na tabela de projetos, foi realizado inicialmente um left-join com a tabela department_inactive, de maneira a importar o nome do departamento em que o projeto está sendo realizado, o que permitiu a seguir, criar uma coluna calculada concatenando o nome do departamento com a cidade em que o projeto ocorre, permitindo assim usar de chave estrangeira para vincular a tabela com a tabela de departamento completa.<br><br>

Por fim, as colunas sem mais finalidade foram excluídas, nomes trocados e tipos adequados, o que resultou num star-esquema como segue:
</p>
<div align="center">
    <img height="360px" src="https://github.com/hugodamasceno/azure-pbi-etl/blob/e3e294387fd3573b3803ddf01a809e50eb5ae5cc/imagens/modelo_dados.drawio.png"/>
</div>
 <p align="justify"> Os termos 'CALC' sinalizam as variáveis que foram calculadas usando DAX a fim de facilitar a construção das visualizações.</p>

---

<h3>DAS DIRETRIZES</h3>

<p>
A respeito das diretrizes propostas para tratamento e análises, pode-se concluir o seguinte:<br>
    </p>
    
1. Cabeçalhos e tipos: <br>
- Os cabeçalhos foram identificados adequadamente pelo Power BI, restando apenas adequação das nomeclaturas, que foram todas passadas para o português por simplicidade.
- Os tipos dos dados também foram, em geral, interpretados de forma adequada, restando apenas a padronização dos tipos de ID para TEXTO e monetário para decimal fixo. No mais, apenas as variáveis resultantes de cálculos apresentaram necessidade de serem ajustadas aos tipos convenientes.
2. Valores nulos: <br>
- Os valores nulos encontrados não configuravam necessidade de exclusão/remoção, pois diziam respeito a colaboradores que não estavam sob supervisão, mas que eram supervisores.
- Foi assegurado que todos os demais colaboradores tinham supervisores, que por sua vez, estavam devidamente registrados entre os colaboradores. Em caso de atualização da base de tal forma que um colaborador seja supervisionado por um supervisor cujo código não está inserido dentre os colaboradores, os relatórios serão capazes de acusar este erro.
3. Departamentos e gerências <br>
- Foi averiguado que todos os departamentos possuiam gerentes, os quais estavam dentre os registros de colaboradores
- Em caso de departamento sem gerente, os relatórios também serão capazes de acusar a falha.
4. Tratamento de dados: <br>
- Campos complexos, os quais apresentavam mais de um dado acumulado, foram separados, como é o caso do endereço dos colaboradores, que foram separados em estado, cidade, rua e número.
- Ao mesclar as tabelas, foi tomado o cuidado ao perceber quando estavamos em busca de um left-join. Um exemplo de left join foi a mescla de colaboradores com departamentos, a fim de trazer o nome dos departamentos em que os colaboradores estavam alocados.
- Aqui é importante apontar que foi realizado mescla, onde colunas de uma tabela são adicionadas a outra, tornando o dado mais completo. A mescla se difere da combinação de dados uma vez que a mescla busca novas colunas para completar os dados, enquanto as combinação de dados leva à adição de novas linhas para o mesmo conjunto de colunas, o que é adequado em casos de construção incremental de uma base de dados. Um exemplo de combinação incremental de dados seria a adição de dados ao longo do tempo, onde cada dia é adicionado uma tabela de dados de vendas para integrar o histórico.
- Foi utilizado o recurso de coluna calculada no Power Query a fim de mesclar as colunas relativas ao nome e sobrenome dos colaboradores, criando a coluna nome completo.

<h3 align="center">DASHBOARD</h3>
<p align="justify">É possível encontrar o dashboard neste <a href="https://app.powerbi.com/view?r=eyJrIjoiZDVkMjNmZjktMTlmZS00ZmMwLTk4MzMtZDA1MDY4OTYyOGQ4IiwidCI6IjIwYzQyZmY4LWI5NGYtNGM3ZC1iOWZkLWM1OTMwMTY1YjEyZSJ9&pageName=ReportSection5d4e26e9d78b57127c3a">LINK</p>. Fique a vontade para interagir e propor melhorias.

---

<div align="center"> 
  <h3>PREVIEW</h3>
</div>

<div align="centre">  
  <img width="49%" height="250px" src="https://github.com/hugodamasceno/azure-pbi-etl/blob/e3e294387fd3573b3803ddf01a809e50eb5ae5cc/imagens/slide%201.png" alt="Hugo Damasceno github stats" />
  <img width="49%" height="250px" src="https://github.com/hugodamasceno/azure-pbi-etl/blob/e3e294387fd3573b3803ddf01a809e50eb5ae5cc/imagens/slide%203.png" style="border: 2px solid white;">
</div>
