-- ============================================================
-- SCRIPT DML | RESTAURANTE
-- Execute este arquivo depois do script-ddl.sql.
-- Todos os dados sao ficticios e representam a operacao inicial
-- de um pequeno restaurante ao longo dos dias 07 e 08/11/2026.
-- Cada uma das 10 tabelas termina com pelo menos 5 registros.
-- ============================================================

USE restaurante_adaptacao;
START TRANSACTION;

-- CENARIO 1 | Configuracao inicial e catalogo (dados-base)
-- Antes da abertura, a equipe foi cadastrada.
INSERT INTO fucionario (cpf_fucionario, nome, cargo, turno) VALUES
    ('00000000901', 'Alice Farias',  'Garconete',   'Almoco'),
    ('00000000902', 'Bruno Rocha',   'Garcom',      'Jantar'),
    ('00000000903', 'Carla Souza',   'Caixa',       'Integral'),
    ('00000000904', 'Diego Martins', 'Cozinheiro',  'Almoco'),
    ('00000000905', 'Elisa Ribeiro', 'Cozinheira',  'Jantar');

-- O salao foi organizado com cinco mesas e capacidades diferentes.
INSERT INTO mesa (num_mesa, capacidade, status, localizacao) VALUES
    (1, 2, 'Livre',     'Salao principal'),
    (2, 4, 'Livre',     'Salao principal'),
    (3, 4, 'Livre',     'Varanda'),
    (4, 6, 'Livre',     'Salao principal'),
    (5, 2, 'Livre',     'Varanda');

-- O proprietario cadastrou as categorias e os precos iniciais do cardapio.
-- O modelo enviado nao possui campos/tabelas de fornecedor ou quantidade em estoque;
-- por isso, esta etapa registra somente os itens, suas categorias e seus precos.
INSERT INTO item_cardapio (cod_item, categoria, nome_item, preco_unitario) VALUES
    (10, 'Salgados',    'Coxinha de frango',       8.00),
    (20, 'Salgados',    'Pastel de queijo',        9.00),
    (30, 'Bebidas',     'Suco de maracuja',        9.50),
    (40, 'Bebidas',     'Agua mineral',            5.00),
    (50, 'Sobremesas',  'Pudim',                  12.00),
    (60, 'Doces',       'Brownie',                13.00),
    (70, 'Combos',      'Combo lanche e bebida',  22.00),
    (80, 'Salgados',    'Sanduiche natural',      16.00),
    (90, 'Bebidas',     'Cafe',                    6.00),
    (100,'Doces',       'Fatia de bolo',           10.00);

-- CENARIO 2 | Chegada dos primeiros clientes e cadastros
-- No primeiro dia de funcionamento, cinco clientes fizeram cadastro
-- para aproveitar a promocao de inauguracao. Foi incluido o campo
-- data_nascimento para registrar a informacao fornecida sobre Jose Silva.
-- As demais datas ficam NULL porque nao foram informadas no enunciado.
INSERT INTO cliente (cpf, nome, data_nascimento, data_cadastro, status_cliente) VALUES
    ('00000000101', 'Jose Silva',       '1990-04-15', '2026-11-07', 'Ativo'),
    ('00000000102', 'Maria Oliveira',   NULL,         '2026-11-07', 'Ativo'),
    ('00000000103', 'Ana Costa',        NULL,         '2026-11-07', 'Ativo'),
    ('00000000104', 'Pedro Lima',       NULL,         '2026-11-07', 'Ativo'),
    ('00000000105', 'Camila Souza',     NULL,         '2026-11-07', 'Ativo');

-- Os clientes informaram seus telefones; Jose cadastrou dois contatos.
INSERT INTO cliente_telefone (cpf_cliente, telefone, tipo_telefone, principal) VALUES
    ('00000000101', '84 99000-0101', 'Celular',    TRUE),
    ('00000000101', '84 3000-0101',  'Comercial',  FALSE),
    ('00000000102', '84 99000-0102', 'Celular',    TRUE),
    ('00000000103', '84 99000-0103', 'Celular',    TRUE),
    ('00000000104', '84 99000-0104', 'Celular',    TRUE),
    ('00000000105', '84 99000-0105', 'Celular',    TRUE);

-- Tambem foram registrados os e-mails para comunicados e confirmacoes.
INSERT INTO cliente_email (cpf_cliente, email, tipo_email, principal) VALUES
    ('00000000101', 'jose.silva@example.org',     'Pessoal', TRUE),
    ('00000000102', 'maria.oliveira@example.org', 'Pessoal', TRUE),
    ('00000000103', 'ana.costa@example.org',      'Pessoal', TRUE),
    ('00000000104', 'pedro.lima@example.org',     'Pessoal', TRUE),
    ('00000000105', 'camila.souza@example.org',   'Pessoal', TRUE),
    ('00000000101', 'jose.trabalho@example.org',  'Comercial', FALSE);

-- CENARIO 3 | Reservas para o primeiro fim de semana
-- Com os clientes cadastrados, a equipe comecou a receber reservas.
INSERT INTO reserva_mesa
    (cod_reserva, data_hora_reserva, qtd_pessoas, status, cpf_cliente) VALUES
    (6011, '2026-11-07 12:00:00', 2, 'Concluida',    '00000000101'),
    (6012, '2026-11-07 12:30:00', 3, 'Concluida',    '00000000102'),
    (6013, '2026-11-07 19:00:00', 2, 'Concluida',    '00000000103'),
    (6014, '2026-11-08 13:00:00', 4, 'Concluida',    '00000000104'),
    (6015, '2026-11-08 19:30:00', 2, 'Em andamento','00000000105'),
    (6016, '2026-11-09 12:00:00', 5, 'Confirmada',   '00000000101');

-- CENARIO 4 | Abertura das comandas e atendimento nas mesas
-- As cinco primeiras reservas chegaram ao restaurante e geraram comandas.
-- A comanda 7015 continua aberta; por isso, sua data de fechamento e NULL.
INSERT INTO atendimento
    (cod_comanda, data_hora_abertura, data_hora_fechamento, valor_total,
     cod_reserva, cpf_fucionario, num_mesa) VALUES
    (7011, '2026-11-07 12:05:00', '2026-11-07 13:10:00', 47.00, 6011, '00000000901', 1),
    (7012, '2026-11-07 12:35:00', '2026-11-07 13:20:00', 23.00, 6012, '00000000901', 2),
    (7013, '2026-11-07 19:05:00', '2026-11-07 20:00:00', 28.00, 6013, '00000000902', 3),
    (7014, '2026-11-08 13:05:00', '2026-11-08 14:00:00', 51.00, 6014, '00000000904', 4),
    (7015, '2026-11-08 19:35:00', NULL,                  38.00, 6015, '00000000902', 5);

-- CENARIO 5 | Lancamento dos pedidos feitos pelos clientes
-- Os itens foram lancados nas comandas conforme os pedidos recebidos.
-- A soma dos subtotais por comanda corresponde ao valor_total do atendimento.
INSERT INTO pedodo_item
    (cod_pedido, quantidade, observacao, hora_pedido, valor_subtotal, cod_comanda, cod_item) VALUES
    (8011, 2, 'Sem pimenta',       '2026-11-07 12:10:00', 16.00, 7011, 10),
    (8012, 2, 'Sem acucar',         '2026-11-07 12:12:00', 19.00, 7011, 30),
    (8013, 1, NULL,                 '2026-11-07 12:40:00', 12.00, 7011, 50),
    (8014, 2, NULL,                 '2026-11-07 12:40:00', 18.00, 7012, 20),
    (8015, 1, NULL,                 '2026-11-07 12:45:00',  5.00, 7012, 40),
    (8016, 1, 'Pouco gelo',         '2026-11-07 19:10:00', 22.00, 7013, 70),
    (8017, 1, NULL,                 '2026-11-07 19:15:00',  6.00, 7013, 90),
    (8018, 2, 'Sem molho',          '2026-11-08 13:10:00', 32.00, 7014, 80),
    (8019, 2, NULL,                 '2026-11-08 13:15:00', 19.00, 7014, 30),
    (8020, 2, 'Embalar para viagem','2026-11-08 19:40:00', 26.00, 7015, 60),
    (8021, 2, NULL,                 '2026-11-08 19:45:00', 12.00, 7015, 90);

-- CENARIO 6 | Recebimento dos pagamentos
-- Algumas comandas foram pagas integralmente; a comanda 7013 foi paga em duas
-- partes, demonstrando que uma comanda pode possuir varios pagamentos.
-- A comanda 7015 recebeu um pagamento parcial e ainda possui saldo em aberto.
INSERT INTO pagamento (cod_pagamento, datahora, valor, forma_pagamento, cod_comanda) VALUES
    (9011, '2026-11-07 13:05:00', 47.00, 'Pix',                 7011),
    (9012, '2026-11-07 13:15:00', 23.00, 'Cartao de debito',    7012),
    (9013, '2026-11-07 19:50:00', 15.00, 'Pix',                 7013),
    (9014, '2026-11-07 19:55:00', 13.00, 'Dinheiro',            7013),
    (9015, '2026-11-08 13:55:00', 51.00, 'Cartao de credito',   7014),
    (9016, '2026-11-08 19:55:00', 20.00, 'Pix',                 7015);

COMMIT;

-- CONFERENCIA | Quantidade de registros em cada tabela.
-- Todas devem apresentar pelo menos 5 registros ao final da carga.
SELECT 'cliente' AS tabela, COUNT(*) AS total FROM cliente
UNION ALL SELECT 'cliente_telefone', COUNT(*) FROM cliente_telefone
UNION ALL SELECT 'cliente_email', COUNT(*) FROM cliente_email
UNION ALL SELECT 'fucionario', COUNT(*) FROM fucionario
UNION ALL SELECT 'mesa', COUNT(*) FROM mesa
UNION ALL SELECT 'item_cardapio', COUNT(*) FROM item_cardapio
UNION ALL SELECT 'reserva_mesa', COUNT(*) FROM reserva_mesa
UNION ALL SELECT 'atendimento', COUNT(*) FROM atendimento
UNION ALL SELECT 'pedodo_item', COUNT(*) FROM pedodo_item
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento;
