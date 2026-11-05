-- =====================================================
-- PROJETO ARCHEL - ETAPA 5: POPULACAO DO BANCO
-- Insere 500 registros em cada uma das 8 tabelas.
--
-- IMPORTANTE:
-- Execute este script somente se as tabelas estiverem vazias.
-- O script NAO apaga dados existentes.
-- =====================================================

-- 1. CATEGORIA: 500 registros
INSERT INTO categoria (nome_categoria, descricao)
SELECT
    CASE ((n - 1) % 8)
        WHEN 0 THEN 'Camisetas'
        WHEN 1 THEN 'Moletons'
        WHEN 2 THEN 'Shorts'
        WHEN 3 THEN 'Regatas'
        WHEN 4 THEN 'Calcas'
        WHEN 5 THEN 'Bones'
        WHEN 6 THEN 'Mochilas'
        ELSE 'Acessorios'
    END || ' - modelo ' || LPAD(n::text, 3, '0'),
    'Linha de produtos ARCHEL para uso esportivo e casual.'
FROM generate_series(1, 500) AS n;

-- 2. CLIENTE: 500 registros
INSERT INTO cliente (
    primeiro_nome, nome_meio, sobrenome, data_nascimento,
    logradouro, numero, bairro, cidade, estado, cep
)
SELECT
    (ARRAY['Miguel','Lucas','Gabriel','Rafael','Matheus',
           'Pedro','Joao','Davi','Arthur','Guilherme'])[((n - 1) % 10) + 1],
    CASE
        WHEN n % 3 = 0 THEN (ARRAY['Silva','Santos','Oliveira','Souza','Lima'])[((n - 1) % 5) + 1]
        ELSE NULL
    END,
    (ARRAY['Costa','Pereira','Almeida','Ferreira','Rodrigues',
           'Carvalho','Gomes','Martins','Barbosa','Ribeiro'])[((n - 1) % 10) + 1],
    DATE '1980-01-01' + ((n * 29) % 12000),
    'Rua ' || (ARRAY['das Flores','Principal','Sao Miguel',' do Comercio',' das Palmeiras'])[((n - 1) % 5) + 1],
    n::text,
    (ARRAY['Centro','Jardim Paulista','Vila Nova','Santa Cruz','Jardim Aeroporto'])[((n - 1) % 5) + 1],
    (ARRAY['Franca','Ribeirao Preto','Campinas','Sao Paulo','Santos'])[((n - 1) % 5) + 1],
    'SP',
    LPAD((14400000 + n)::text, 8, '0')
FROM generate_series(1, 500) AS n;

-- 3. PRODUTO: 500 registros
INSERT INTO produto (id_categoria, nome_produto, descricao, preco_venda)
SELECT
    n,
    (ARRAY['Camiseta','Moletom','Shorts','Regata','Calca',
           'Bone','Mochila','Garrafa'])[((n - 1) % 8) + 1]
        || ' ARCHEL ' || LPAD(n::text, 3, '0'),
    'Produto ARCHEL para treino e uso diario.',
    CASE ((n - 1) % 8)
        WHEN 0 THEN 79.90 + ((n % 5) * 2)
        WHEN 1 THEN 159.90 + ((n % 5) * 5)
        WHEN 2 THEN 89.90 + ((n % 5) * 3)
        WHEN 3 THEN 69.90 + ((n % 5) * 2)
        WHEN 4 THEN 129.90 + ((n % 5) * 4)
        WHEN 5 THEN 39.90 + (n % 5)
        WHEN 6 THEN 119.90 + ((n % 5) * 5)
        ELSE 29.90 + (n % 5)
    END
FROM generate_series(1, 500) AS n;

-- 4. TELEFONE: 500 registros
INSERT INTO telefone (id_cliente, numero_telefone, tipo)
SELECT
    n,
    '(16) 9' || LPAD((10000000 + n)::text, 8, '0'),
    CASE WHEN n % 2 = 0 THEN 'Celular' ELSE 'Principal' END
FROM generate_series(1, 500) AS n;

-- 5. PEDIDO: 500 registros
-- Os pedidos possuem situacoes diferentes.
INSERT INTO pedido (id_cliente, data_pedido, status_pedido)
SELECT
    n,
    TIMESTAMP '2025-01-01 10:00:00' + (n * INTERVAL '1 day'),
    CASE
        WHEN n % 4 = 0 THEN 'pendente'
        WHEN n % 4 = 1 THEN 'pago'
        WHEN n % 4 = 2 THEN 'enviado'
        ELSE 'entregue'
    END
FROM generate_series(1, 500) AS n;

-- 6. ITEM_PEDIDO: 500 registros
-- Cada pedido possui um item, com produto e quantidade.
INSERT INTO item_pedido (
    id_pedido, id_produto, quantidade, preco_unitario
)
SELECT
    n,
    n,
    1 + (n % 3),
    (SELECT preco_venda FROM produto WHERE id_produto = n)
FROM generate_series(1, 500) AS n;

-- 7. PAGAMENTO: 500 registros
-- O valor corresponde a quantidade x preco do item.
-- Pedidos pendentes possuem pagamento pendente.
INSERT INTO pagamento (
    id_pedido, valor_pago, data_pagamento,
    forma_pagamento, status_pagamento
)
SELECT
    p.id_pedido,
    ip.quantidade * ip.preco_unitario,
    CASE
        WHEN p.status_pedido = 'pendente' THEN NULL
        ELSE p.data_pedido + INTERVAL '1 hour'
    END,
    (ARRAY['Pix','Cartao de credito','Cartao de debito','Boleto'])[((p.id_pedido - 1) % 4) + 1],
    CASE
        WHEN p.status_pedido = 'pendente' THEN 'pendente'
        ELSE 'aprovado'
    END
FROM pedido p
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido;

-- 8. MOVIMENTACAO_ESTOQUE: 500 registros
-- 400 saidas ligadas a itens de pedidos e 100 entradas
-- de reposicao sem item de pedido associado.
INSERT INTO movimentacao_estoque (
    id_produto, id_item_pedido, tipo_movimentacao,
    quantidade_movimentada, data_movimentacao, motivo
)
SELECT
    n,
    CASE WHEN n % 5 = 0 THEN NULL ELSE n END,
    CASE WHEN n % 5 = 0 THEN 'entrada' ELSE 'saida' END,
    CASE
        WHEN n % 5 = 0 THEN 10 + (n % 20)
        ELSE 1 + (n % 3)
    END,
    TIMESTAMP '2025-01-01 12:00:00' + (n * INTERVAL '1 day'),
    CASE
        WHEN n % 5 = 0 THEN 'Reposicao de estoque'
        ELSE 'Separacao de produto para pedido'
    END
FROM generate_series(1, 500) AS n;

-- CONFERENCIA: cada tabela deve apresentar 500 registros.
SELECT 'categoria' AS tabela, COUNT(*) AS total FROM categoria
UNION ALL SELECT 'cliente', COUNT(*) FROM cliente
UNION ALL SELECT 'produto', COUNT(*) FROM produto
UNION ALL SELECT 'telefone', COUNT(*) FROM telefone
UNION ALL SELECT 'pedido', COUNT(*) FROM pedido
UNION ALL SELECT 'item_pedido', COUNT(*) FROM item_pedido
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento
UNION ALL SELECT 'movimentacao_estoque', COUNT(*) FROM movimentacao_estoque
ORDER BY tabela;
