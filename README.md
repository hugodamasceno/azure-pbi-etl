<div align="left">  
    <img height="30px" <img src="https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white" alt="Azure" />
    <img height="30px" <img src="https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white" alt="Azure" />
    <img height="30px" src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=power-bi&logoColor=black" alt="Power BI" >
    <h2> AZURE-PowerBI-ETL</h2>
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

    Os dados descreve detalhes de uma empresa fictícia como colaboradores, departamentos, projetos, horas trabalhadas nos projetos, localização dos departamentos e dependentes dos colaboradores. Os dados são criados a partir de queries disponibilizadas <a href="https://github.com/julianazanelatto/power_bi_analyst/tree/b010c1874a183a0fb4b831e76dc68b9b872becec/M%C3%B3dulo%203/Desafio%20de%20Projeto">aqui</a>. Estas queries foram adequadas para serem utilizadas em PostgreSQL, o que reesultou nas .



<p align="justify">
    Os 