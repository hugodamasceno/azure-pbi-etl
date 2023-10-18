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
Na tabela de colaboradores, foi realizado uma divisão da coluna endereço entre número, rua, cidade e estado. Esta divisão permitiu que fosse criado uma coluna de concatenação entre nome do departamento do colaborador e sua cidade, resgatando vínculo entre a tabela de colaboradores e de departamento.<br><br>
A seguir, foi calculado uma nova coluna concatenando nome e sobrenome dos colaboradores em um nome completo. Ainda na tabela de colaboradores, foi realizado uma mescla dela com ela mesma, usando os códigos dos supervisores de cada colaborador para a tabela da esquerda e relacionando com os códigos dos próprios colaboradores da tabela da direita, efetuando um left-join, o qual foi responsável por trazer nome completo dos respectivos supervisores.<br><br>
Já na tabela de projetos, foi realizado inicialmente um left-join com a tabela department_inactive, de maneira a importar o nome do departamento em que o projeto está sendo realizado, o que permitiu a seguir, criar uma coluna calculada concatenando o nome do departamento com a cidade em que o projeto ocorre, permitindo assim usar de chave estrangeira para vincular a tabela com a tabela de departamento completa.<br><br>
Por fim, as colunas sem mais finalidade foram excluídas, nomes trocados e tipos adequados, o que resultou num esquema snow-flake como segue:
</p>

<!--
Verifique os cabeçalhos e tipos de dados

Modifique os valores monetários para o tipo double preciso

Verifique a existência dos nulos e analise a remoção

Os employees com nulos em Super_ssn podem ser os gerentes. Verifique se há algum colaborador sem gerente

Verifique se há algum departamento sem gerente

Se houver departamento sem gerente, suponha que você possui os dados e preencha as lacunas

Verifique o número de horas dos projetos

Separar colunas complexas

Mesclar consultas employee e departament para criar uma tabela employee com o nome dos departamentos associados aos colaboradores. A mescla terá como base a tabela employee. Fique atento, essa informação influencia no tipo de junção

Neste processo elimine as colunas desnecessárias.

Realize a junção dos colaboradores e respectivos nomes dos gerentes . Isso pode ser feito com consulta SQL ou pela mescla de tabelas com Power BI. Caso utilize SQL, especifique no README a query utilizada no processo.

Mescle as colunas de Nome e Sobrenome para ter apenas uma coluna definindo os nomes dos colaboradores

Mescle os nomes de departamentos e localização. Isso fará que cada combinação departamento-local seja único. Isso irá auxiliar na criação do modelo estrela em um módulo futuro.

Explique por que, neste caso supracitado, podemos apenas utilizar o mesclar e não o atribuir.-->