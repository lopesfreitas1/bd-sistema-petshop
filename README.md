# Sistema de Gestão para Petshop

## 1. Descrição do Minimundo

Este projeto tem como objetivo modelar o banco de dados de um **petshop de médio porte** que oferece, ao mesmo tempo, **venda de produtos** (ração, brinquedos, medicamentos, acessórios) e **prestação de serviços** (banho, tosa, consulta veterinária, vacinação, hospedagem).

### Problema real a ser resolvido

Atualmente, o petshop controla seus clientes, animais, agendamentos e vendas por meio de planilhas soltas e cadernos de anotação. Isso gera diversos problemas:

- Dificuldade em saber o histórico de serviços e vacinas de cada pet;
- Agendamentos duplicados para o mesmo funcionário no mesmo horário;
- Falta de controle de estoque de produtos, causando rupturas ou excesso;
- Impossibilidade de gerar relatórios de faturamento por funcionário, serviço ou produto;
- Perda de informações de contato e histórico de compras dos clientes.

A proposta é criar um banco de dados relacional que centralize essas informações, permitindo consultas rápidas e confiáveis sobre clientes, pets, funcionários, serviços, agendamentos, produtos e vendas.

## 2. Contexto da Aplicação

O sistema atende a um **petshop** que combina uma loja física de produtos para animais com uma clínica de serviços de estética e saúde animal. Os principais atores do sistema são:

- **Clientes**: donos dos animais, que compram produtos e agendam serviços;
- **Pets**: os animais de estimação cadastrados, vinculados a um cliente;
- **Funcionários**: atendentes, tosadores, banhistas e veterinários que executam os serviços e registram vendas;
- **Serviços**: itens do catálogo de atendimento (banho, tosa, consulta, vacina, hospedagem);
- **Produtos**: itens físicos disponíveis para venda no estabelecimento.

## 3. Regras de Negócio

1. Um cliente pode possuir vários pets, mas cada pet pertence a um único cliente.
2. Um pet pode passar por vários agendamentos ao longo do tempo (histórico), mas cada agendamento é referente a um único pet.
3. Um agendamento pode incluir um ou mais serviços (ex.: banho + tosa no mesmo agendamento), e um serviço pode estar presente em vários agendamentos diferentes.
4. Cada agendamento é atendido por um único funcionário responsável, mas um funcionário pode atender diversos agendamentos.
5. Uma venda de produtos é sempre associada a um cliente e registrada por um funcionário.
6. Uma venda pode conter vários produtos, e um mesmo produto pode aparecer em várias vendas diferentes (relação N:N resolvida por uma entidade associativa).
7. O estoque de produtos deve ser controlado a partir das vendas realizadas.

## 4. Principais Processos (Tarefas) Atendidos

- Cadastro de clientes e de seus respectivos pets;
- Cadastro de funcionários e do catálogo de serviços oferecidos;
- Agendamento de serviços para um pet, com data/hora e funcionário responsável;
- Cadastro e controle de estoque de produtos;
- Registro de vendas de produtos, associando cliente, funcionário e itens vendidos;
- Consulta ao histórico de serviços realizados por pet e ao histórico de compras por cliente.

## 5. Estrutura do Repositório

```
.
├── README.md
└── modelagem/
    └── MER.md
```

A modelagem conceitual completa (entidades, relacionamentos, atributos e diagrama) está detalhada no arquivo [`modelagem/MER.md`](./modelagem/MER.md).
