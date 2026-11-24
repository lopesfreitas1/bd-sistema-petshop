-- ============================================================
-- SCRIPT DDL | RESTAURANTE
-- Baseado no modelo restaurante_adaptacao enviado pelo aluno.
-- Banco: MySQL 8.0.16 ou superior (para aplicar as restricoes CHECK).
-- Este arquivo cria somente a estrutura; os INSERTs ficam no script-dml.sql.
--
-- Ajustes para atender ao requisito de 4 campos por tabela:
-- cliente: data_nascimento, data_cadastro e status_cliente.
-- cliente_telefone / cliente_email: tipo de contato e indicador de principal.
-- mesa: localizacao.
-- Os nomes fucionario e pedodo_item foram mantidos como no modelo original.
-- ============================================================

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS restaurante_adaptacao;
CREATE DATABASE restaurante_adaptacao
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE restaurante_adaptacao;

-- CENARIO 1 | Cadastros principais
-- Tabela pai: cliente. Os contatos serao cadastrados depois.
CREATE TABLE cliente (
    cpf            VARCHAR(11)  NOT NULL,
    nome            VARCHAR(150) NOT NULL,
    data_nascimento DATE         NULL,
    data_cadastro   DATE         NOT NULL,
    status_cliente  VARCHAR(20)  NOT NULL DEFAULT 'Ativo',
    CONSTRAINT pk_cliente PRIMARY KEY (cpf),
    CONSTRAINT ck_cliente_status CHECK (status_cliente IN ('Ativo', 'Inativo')) ,
    CONSTRAINT ck_cliente_nascimento CHECK (data_nascimento IS NULL OR data_nascimento <= data_cadastro)
) ENGINE=InnoDB;

-- 1FN | Telefones em linhas separadas, permitindo varios por cliente.
CREATE TABLE cliente_telefone (
    cpf_cliente   VARCHAR(11) NOT NULL,
    telefone      VARCHAR(20) NOT NULL,
    tipo_telefone VARCHAR(20) NOT NULL DEFAULT 'Celular',
    principal     BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_cliente_telefone PRIMARY KEY (cpf_cliente, telefone),
    CONSTRAINT fk_telefone_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES cliente (cpf),
    CONSTRAINT ck_telefone_principal CHECK (principal IN (0, 1))
) ENGINE=InnoDB;

-- 1FN | E-mails em linhas separadas. O e-mail tambem e unico no cadastro.
CREATE TABLE cliente_email (
    cpf_cliente VARCHAR(11)  NOT NULL,
    email       VARCHAR(254) NOT NULL,
    tipo_email  VARCHAR(20)  NOT NULL DEFAULT 'Pessoal',
    principal   BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_cliente_email PRIMARY KEY (cpf_cliente, email),
    CONSTRAINT uk_cliente_email UNIQUE (email),
    CONSTRAINT fk_email_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES cliente (cpf),
    CONSTRAINT ck_email_principal CHECK (principal IN (0, 1))
) ENGINE=InnoDB;

-- Cadastro dos funcionarios que trabalham nos atendimentos.
CREATE TABLE fucionario (
    cpf_fucionario VARCHAR(11)  NOT NULL,
    nome           VARCHAR(150) NOT NULL,
    cargo          VARCHAR(80)  NOT NULL,
    turno          VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_fucionario PRIMARY KEY (cpf_fucionario)
) ENGINE=InnoDB;

-- Mesas do salao. A localizacao complementa os campos do modelo original.
CREATE TABLE mesa (
    num_mesa   INT         NOT NULL,
    capacidade INT         NOT NULL,
    status     VARCHAR(40) NOT NULL DEFAULT 'Livre',
    localizacao VARCHAR(50) NOT NULL DEFAULT 'Salao principal',
    CONSTRAINT pk_mesa PRIMARY KEY (num_mesa),
    CONSTRAINT ck_mesa_capacidade CHECK (capacidade > 0),
    CONSTRAINT ck_mesa_status CHECK (status IN ('Livre', 'Ocupada', 'Reservada', 'Manutencao'))
) ENGINE=InnoDB;

-- Catalogo do cardapio, com categoria e preco unitario.
CREATE TABLE item_cardapio (
    cod_item       INT           NOT NULL,
    categoria      VARCHAR(80)   NOT NULL,
    nome_item      VARCHAR(150)  NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_item_cardapio PRIMARY KEY (cod_item),
    CONSTRAINT ck_item_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

-- Reservas dependem de um cliente ja cadastrado.
CREATE TABLE reserva_mesa (
    cod_reserva       INT         NOT NULL,
    data_hora_reserva DATETIME    NOT NULL,
    qtd_pessoas       INT         NOT NULL,
    status            VARCHAR(40) NOT NULL DEFAULT 'Confirmada',
    cpf_cliente       VARCHAR(11) NOT NULL,
    CONSTRAINT pk_reserva_mesa PRIMARY KEY (cod_reserva),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (cpf_cliente)
        REFERENCES cliente (cpf),
    CONSTRAINT ck_reserva_pessoas CHECK (qtd_pessoas > 0),
    CONSTRAINT ck_reserva_status CHECK (status IN ('Confirmada', 'Em andamento', 'Concluida', 'Cancelada'))
) ENGINE=InnoDB;

-- Atendimento depende da reserva, do funcionario e da mesa.
CREATE TABLE atendimento (
    cod_comanda           INT           NOT NULL,
    data_hora_abertura    DATETIME      NOT NULL,
    data_hora_fechamento  DATETIME      NULL,
    valor_total           DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cod_reserva           INT           NOT NULL,
    cpf_fucionario        VARCHAR(11)   NOT NULL,
    num_mesa              INT           NOT NULL,
    CONSTRAINT pk_atendimento PRIMARY KEY (cod_comanda),
    CONSTRAINT uk_atendimento_reserva UNIQUE (cod_reserva),
    CONSTRAINT fk_atendimento_reserva FOREIGN KEY (cod_reserva)
        REFERENCES reserva_mesa (cod_reserva),
    CONSTRAINT fk_atendimento_fucionario FOREIGN KEY (cpf_fucionario)
        REFERENCES fucionario (cpf_fucionario),
    CONSTRAINT fk_atendimento_mesa FOREIGN KEY (num_mesa)
        REFERENCES mesa (num_mesa),
    CONSTRAINT ck_atendimento_total CHECK (valor_total >= 0),
    CONSTRAINT ck_atendimento_datas CHECK (
        data_hora_fechamento IS NULL OR data_hora_fechamento >= data_hora_abertura
    )
) ENGINE=InnoDB;

-- Cada lancamento pertence a uma comanda e referencia um item do cardapio.
CREATE TABLE pedodo_item (
    cod_pedido     INT           NOT NULL,
    quantidade     INT           NOT NULL DEFAULT 1,
    observacao     VARCHAR(255)  NULL,
    hora_pedido    DATETIME      NOT NULL,
    valor_subtotal DECIMAL(10,2) NOT NULL,
    cod_comanda    INT           NOT NULL,
    cod_item       INT           NOT NULL,
    CONSTRAINT pk_pedodo_item PRIMARY KEY (cod_pedido),
    CONSTRAINT fk_pedido_atendimento FOREIGN KEY (cod_comanda)
        REFERENCES atendimento (cod_comanda),
    CONSTRAINT fk_pedido_cardapio FOREIGN KEY (cod_item)
        REFERENCES item_cardapio (cod_item),
    CONSTRAINT ck_pedido_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_pedido_subtotal CHECK (valor_subtotal >= 0)
) ENGINE=InnoDB;

-- Uma comanda pode receber um ou varios pagamentos.
CREATE TABLE pagamento (
    cod_pagamento   INT           NOT NULL,
    datahora        DATETIME      NOT NULL,
    valor           DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(50)   NOT NULL,
    cod_comanda     INT           NOT NULL,
    CONSTRAINT pk_pagamento PRIMARY KEY (cod_pagamento),
    CONSTRAINT fk_pagamento_atendimento FOREIGN KEY (cod_comanda)
        REFERENCES atendimento (cod_comanda),
    CONSTRAINT ck_pagamento_valor CHECK (valor > 0),
    CONSTRAINT ck_pagamento_forma CHECK (forma_pagamento IN ('Pix', 'Cartao de credito', 'Cartao de debito', 'Dinheiro'))
) ENGINE=InnoDB;

-- Fim do DDL. Execute script-dml.sql depois deste arquivo.
