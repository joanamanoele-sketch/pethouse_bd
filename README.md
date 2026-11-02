# Pet House

Projeto de banco de dados para um pet shop de pequeno porte, desenvolvido pelo **Grupo 7** para a disciplina de Modelagem de Dados.

A Pet House é um pet shop que vende produtos (rações, acessórios, higiene) e oferece serviços agendados (banho, tosa e consultas). Hoje o controle é feito em cadernos e planilhas. Este projeto cria um banco de dados para centralizar tudo em um único lugar.

---

## O que tem nesta pasta

```
PetHouse/
├── README.md                                        ← este arquivo
├── documentacao/
│   └── Documentacao_DER_PetHouse.docx               ← explicação completa do projeto e do DER
└── banco_de_dados/
    ├── pethouse_script_sql_phpMyadmin.sql            ← script principal (MySQL, importar pelo phpMyAdmin)
    ├── pethouse_script_sql_postgre.sql               ← versão antiga em PostgreSQL (referência)
    └── pethouse_backup.dump                          ← backup compactado do banco original
```

---

## Como rodar o banco de dados

O banco de dados foi feito no **MySQL** e pode ser importado diretamente pelo **phpMyAdmin**.

### Passo a passo

1. Abra o phpMyAdmin no seu navegador (normalmente em `http://localhost/phpmyadmin`).
2. Clique em **Importar** no menu superior.
3. Selecione o arquivo `pethouse_script_sql_phpMyadmin.sql` da pasta `banco_de_dados/`.
4. Clique em **Executar**.

Pronto — o banco `pethouse` vai ser criado com todas as tabelas, dados de teste e relacionamentos.

> **Requisito:** MySQL 8.0.16 ou superior (para suporte a `CHECK`), ou MariaDB equivalente.

---

## O que a documentação explica

O arquivo `.docx` na pasta `documentacao/` tem tudo sobre o projeto:

- como o pet shop funciona hoje e quais são os problemas que ele enfrenta;
- o que o sistema precisa fazer (requisitos funcionais e não funcionais);
- as regras de negócio do pet shop;
- fluxogramas dos principais processos;
- o Diagrama Entidade-Relacionamento (DER) com justificativa de cada decisão;
- o modelo lógico convertido do DER;
- a análise de normalização (1FN, 2FN e 3FN);
- o dicionário de dados com todas as tabelas e colunas;
- o script SQL completo (CREATE, INSERT, SELECT com JOIN, UPDATE, DELETE);
- consultas gerenciais e de auditoria;
- indicadores de BI e possibilidades de uso de IA.

---

## O script SQL — o que tem dentro

O arquivo `pethouse_script_sql_phpMyadmin.sql` foi gerado a partir da versão PostgreSQL e adaptado para MySQL. Ele contém:

| O que faz | Descrição |
|---|---|
| `CREATE DATABASE` | Cria o banco `pethouse` com suporte a acentos (utf8mb4) |
| `CREATE TABLE` | Cria as 12 tabelas com chaves primárias, restrições e tipos MySQL |
| `INSERT INTO` | Insere os dados de teste (clientes, pets, produtos, pedidos etc.) |
| `CREATE INDEX` | Cria os índices para agilizar as consultas mais comuns |
| `ALTER TABLE` | Adiciona as chaves estrangeiras e os relacionamentos entre tabelas |

---

## As tabelas do banco

| Tabela | Para que serve |
|---|---|
| `cliente` | Cadastro dos clientes do pet shop |
| `pet` | Cadastro dos animais de cada cliente |
| `agendamento` | Reservas de banho, tosa e consultas |
| `produto` | Produtos vendidos pela loja |
| `categoria` | Categorias dos produtos (ração, higiene, brinquedos...) |
| `estoque` | Quantidade atual e mínima de cada produto |
| `fornecedor` | Empresas que abastecem a loja |
| `fornecedor_produto` | Qual fornecedor vende qual produto e por qual preço |
| `pedido` | Vendas realizadas |
| `item_pedido` | Produtos de cada pedido (quantidade e preço cobrado) |
| `orcamento` | Propostas feitas antes da venda |
| `feedback` | Avaliações dos clientes sobre os pedidos |

---

## Diferenças entre a versão MySQL e a versão PostgreSQL

O professor pediu que o banco fosse implementado em MySQL/phpMyAdmin. A versão anterior estava em PostgreSQL. As principais adaptações feitas foram:

| PostgreSQL | MySQL (versão atual) |
|---|---|
| `SERIAL` | `INT NOT NULL AUTO_INCREMENT` |
| `NOW()` | `CURRENT_TIMESTAMP` |
| `\c pet_house` (conectar) | `USE pethouse;` |
| `TO_CHAR(data, 'YYYY-MM')` | `DATE_FORMAT(data, '%Y-%m')` |
| `STRING_AGG(...)` | `GROUP_CONCAT(...)` |
| `INTERVAL '7 days'` | `INTERVAL 7 DAY` |

O script PostgreSQL antigo foi mantido na pasta para referência, mas **o script que deve ser usado é o MySQL**.

---

## Grupo 7

| Nome | RA |
|---|---|
| _(adicione aqui o nome de cada integrante)_ | _(adicione o RA)_ |
