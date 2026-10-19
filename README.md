# 1. Cenário

## 1.1 Descrição da empresa

A ARCHEL é uma empresa fictícia do ramo de vestuário esportivo e casual, especializada na comercialização de camisetas, moletons, shorts, bonés, garrafas e outros acessórios. A empresa busca oferecer produtos que combinem conforto, praticidade e estilo, atendendo tanto pessoas que praticam atividades físicas quanto consumidores que utilizam roupas esportivas no cotidiano.

Com o crescimento da operação, a empresa necessita de um sistema informatizado para administrar suas atividades comerciais, desde o cadastro de clientes e produtos até o registro de pedidos, o controle de estoque e o acompanhamento dos pagamentos.

## 1.2 Problema identificado

Inicialmente, a empresa realiza parte de seus controles por meio de planilhas e anotações manuais. Esse método dificulta a organização das informações, aumenta o risco de inconsistências nos registros e torna mais demorada a consulta ao histórico de compras dos clientes.

Além disso, a falta de integração entre as informações de vendas e estoque pode ocasionar divergências nas quantidades disponíveis, dificultando a identificação dos produtos mais vendidos e o acompanhamento dos resultados comerciais.

Para solucionar esses problemas, propõe-se a criação de um banco de dados relacional utilizando o Supabase e a linguagem SQL.

## 1.3 Objetivo do sistema

O objetivo é centralizar e organizar as informações da ARCHEL em um banco de dados estruturado, garantindo a integridade e a consistência dos registros.

O sistema deverá permitir:

- Cadastrar e consultar clientes.
- Armazenar os telefones dos clientes.
- Cadastrar produtos e suas respectivas categorias.
- Registrar pedidos e os produtos que compõem cada compra.
- Registrar pagamentos associados aos pedidos.
- Consultar o histórico de compras dos clientes.
- Acompanhar as quantidades disponíveis em estoque.
- Gerar relatórios para analisar as vendas e os produtos comercializados.

## 1.4 Entidades principais

O banco de dados será composto por sete entidades principais:

1. **Cliente:** armazena o identificador, nome completo, endereço e data de nascimento dos clientes.
2. **Telefone:** armazena os números de telefone associados aos clientes.
3. **Pedido:** registra a data, o cliente responsável pela compra e o status do pedido.
4. **Item do pedido:** registra os produtos incluídos em cada pedido, suas quantidades e os preços praticados no momento da compra.
5. **Produto:** armazena o nome, a descrição, o preço de venda, a quantidade em estoque e a categoria de cada produto.
6. **Categoria:** organiza os produtos em grupos, como camisetas, moletons e acessórios.
7. **Pagamento:** registra as informações financeiras de cada pedido, incluindo valor, data e forma de pagamento.

## 1.5 Regras de negócio

- Cada cliente possui um identificador único.
- Um cliente pode possuir vários telefones cadastrados.
- Um cliente pode realizar vários pedidos, mas cada pedido pertence a um único cliente.
- Cada pedido deve possuir pelo menos um item.
- Um pedido pode conter vários produtos, e um produto pode estar presente em vários pedidos.
- Cada item do pedido registra a quantidade e o preço unitário aplicado no momento da venda.
- Cada produto pertence a uma categoria, e uma categoria pode possuir vários produtos.
- Cada pedido poderá possuir um único registro de pagamento, conforme a regra adotada neste projeto.
- O valor total de um pedido será calculado a partir da soma dos valores de seus itens.
- Os preços e as quantidades devem respeitar restrições para evitar valores inválidos.
- As chaves estrangeiras garantirão que os registros relacionados existam no banco de dados.

## 1.6 Resultados esperados

Com a implementação do banco de dados, espera-se melhorar a organização das informações comerciais, reduzir inconsistências, facilitar o controle dos pedidos e do estoque e disponibilizar consultas SQL que auxiliem na análise dos resultados da empresa.