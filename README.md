# pethouse_bd

Projeto de banco de dados para um pet shop de pequeno porte, feito pelo **Grupo 7**.

A Pet House vende produtos (rações, acessórios, higiene) e faz serviços agendados (banho, tosa e consultas).
Hoje tudo é controlado em cadernos e planilhas. Este projeto cria um banco de dados para organizar tudo em um só lugar.

## O que tem nesta pasta

```
PetHouse/
├── README.md                          <- este arquivo
├── documentacao/
│   └── Documentacao_DER_PetHouse.docx <- explicação completa do projeto e do DER
└── banco_de_dados/
    ├── pethouse_backup.sql            <- cópia do banco em texto (dá para abrir e ler)
    └── pethouse_backup.dump           <- cópia do banco em formato compactado
```

### Documentação (DER)
O **DER** é o desenho que mostra como as informações do pet shop se conectam
(por exemplo: um cliente pode ter vários pets). O arquivo `.docx` explica:
- como a empresa funciona hoje e quais são os problemas;
- o que o sistema precisa fazer;
- cada tabela do banco e para que ela serve.

### Backup do banco de dados
Os dois arquivos têm **o mesmo conteúdo**: a estrutura do banco (as tabelas e suas regras).

| Arquivo | Para que serve |
|---|---|
| `pethouse_backup.sql` | Arquivo de texto. Dá para abrir no bloco de notas e ler. |
| `pethouse_backup.dump` | Arquivo compactado. Só abre com o programa de restauração. |

## Grupo 7

Adicione aqui o nome dos integrantes.
