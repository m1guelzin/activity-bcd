CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(80) NOT NULL,
    descricao TEXT
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    primeiro_nome VARCHAR(60) NOT NULL,
    nome_meio VARCHAR(60),
    sobrenome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    bairro VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL
);

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_venda NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),

    CHECK (preco_venda >= 0)
);

CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,
    tipo VARCHAR(20),

    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) NOT NULL DEFAULT 'pendente',

    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto),

    CHECK (quantidade > 0),
    CHECK (preco_unitario >= 0)
);

CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL UNIQUE,
    valor_pago NUMERIC(10,2) NOT NULL,
    data_pagamento TIMESTAMP,
    forma_pagamento VARCHAR(30) NOT NULL,
    status_pagamento VARCHAR(30) NOT NULL DEFAULT 'pendente',

    FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),

    CHECK (valor_pago >= 0)
);

CREATE TABLE movimentacao_estoque (
    id_movimentacao SERIAL PRIMARY KEY,
    id_produto INT NOT NULL,
    id_item_pedido INT,
    tipo_movimentacao VARCHAR(10) NOT NULL,
    quantidade_movimentada INT NOT NULL,
    data_movimentacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(150) NOT NULL,

    FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto),

    FOREIGN KEY (id_item_pedido)
        REFERENCES item_pedido(id_item_pedido),

    CHECK (tipo_movimentacao IN ('entrada', 'saida')),
    CHECK (quantidade_movimentada > 0)
);
