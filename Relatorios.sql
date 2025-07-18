
-- Iniciando com mais fáceis e aumentando a dificuldade

-- 1) Listar os clientes
select * from cliente;

-- 2) Listar os pagamentos
select * from pagamento_pedido;

-- 3) Listar os itens pedidos
select * from itens_pedido;

--  4) Quais clientes ainda não informaram o telefone?
SELECT * FROM cliente
WHERE Telefone IS NULL;

-- 5) Liste todos os produtos com seus respectivos códigos.
select Nome_produto, Codigo_produto from Produto;

-- 6) Total de  pedidos foram feitos por cliente
SELECT 
    c.Nome AS Cliente,
    COUNT(pp.Id_cliente) AS Total_pedidos
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp 
ON c.Id_cliente = pp.Id_cliente
GROUP BY 
    c.Nome
ORDER BY 
    Total_pedidos DESC;

-- 7) Mesmo anterior usando comando having para total_pedidos >= 5
SELECT 
    c.Nome AS Cliente,
    COUNT(pp.Id_cliente) AS Total_pedidos
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp 
    ON c.Id_cliente = pp.Id_cliente
GROUP BY 
    c.Nome
HAVING 
    COUNT(pp.Id_cliente) >= 5
ORDER BY 
    Total_pedidos DESC;




-- 8) Liste os nomes dos fornecedores com seus e-mails e seus produtos e  codigo do produto.
SELECT 
    f.Nome_fornecedor AS Fornecedor,
    f.Email,
    p.Nome_produto,
    p.Codigo_produto
FROM 
    fornecedor AS f
JOIN 
    produto AS p 
ON f.Id_fornecedor = p.Id_Fornecedor
ORDER BY 
    f.Nome_fornecedor;
    
-- 9) Listar o anterior com o preco do produto
SELECT 
    f.Nome_fornecedor AS Fornecedor,
    f.Email,
    p.Nome_produto,
    p.Codigo_produto,
    i.valor_unitario
FROM 
    fornecedor AS f
JOIN 
    produto AS p
ON 
	f.Id_fornecedor = p.Id_Fornecedor
JOIN 
    itens_pedido AS i
ON 
	p.Id_Produto = i.Id_Produto
ORDER BY 
    f.Nome_fornecedor;

-- 10) Contar quantos pedidos nao foram pagos
SELECT COUNT(*) AS total_pedidos_nao_pagos 
FROM pagamento_pedido
WHERE Pagamento_efetuado = false;

-- 11) Selecionar pedidos nao pagado
SELECT * FROM Pagamento_Pedido 
WHERE Pagamento_efetuado = false;

-- 12) Selecionar os Clientes, fornecedor, numero de pedidos, quantidade, valor unitarios, valor total do pedido e o nome do produtos dos clientes que nao pagaram os pedidos
SELECT 
    c.Nome AS Clientes,
    pp.Pagamento_efetuado,
    pp.Nr_pedido AS Numero_pedido,
    i.Quantidade,
    i.Valor_unitario,
    (i.Quantidade * i.Valor_unitario) AS Valor_total_do_pedido,
    p.Nome_produto,
    f.Nome_fornecedor
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp
ON 
	c.Id_cliente = pp.Id_Cliente
JOIN 
    itens_pedido AS i
ON 
	pp.Id_Pedido = i.Id_Pedido
JOIN 
    produto AS p
ON 
	p.Id_Produto = i.Id_Produto
JOIN 
    fornecedor AS f
ON 
	p.Id_Fornecedor = f.Id_Fornecedor
WHERE
	pp.Pagamento_efetuado = false
ORDER BY 
    c.Nome;

-- 13) Selecionar os valores dos pedidos de cada cliente
SELECT 
    c.Nome AS Cliente,
    sum(i.Quantidade * i.Valor_unitario) AS Valor_total_item
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp
ON 
	c.Id_cliente = pp.Id_cliente
JOIN 
    itens_pedido AS i
ON 
	pp.Id_Pedido = i.Id_pedido
GROUP BY 
	c.Nome
order by c.Nome;

-- 14) Repetindo a anterior com as colunas que os clientes que pagaram e nao pagaram
SELECT 
    c.Nome AS Cliente,
    pp.Nr_pedido,
    pp.Pagamento_efetuado,
    pp.Data_pagamento,
    sum(i.Quantidade * i.Valor_unitario) AS Valor_total_item
    
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp
ON 
	c.Id_cliente = pp.Id_cliente
JOIN 
    itens_pedido AS i
ON 
	pp.Id_Pedido = i.Id_pedido
GROUP BY 
	-- precisa aumentar o grupo de agregacao para ver os que pagou e nao pagou e data pagamento
	c.Nome, pp.Nr_pedido, pp.Pagamento_efetuado, pp.Data_pagamento 
order by c.Nome;


-- 15) Repetindo a anterior com a forma de pagamento 
SELECT 
    c.Nome AS Cliente,
    pp.Nr_pedido,
    pp.Pagamento_efetuado,
    pp.Data_pedido,
    pp.Data_pagamento,
    fp.Tipo_pagamento,
    sum(i.Quantidade * i.Valor_unitario) AS Valor_total_item
    
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp
ON 
	c.Id_cliente = pp.Id_cliente
JOIN 
    itens_pedido AS i
ON 
	pp.Id_Pedido = i.Id_pedido
    
JOIN 
    forma_pagamento AS fp
ON 
	pp.Id_Pedido = fp.Id_pedido
GROUP BY 
	-- precisa aumentar o grupo de agregacao para ver os que pagou e nao pagou e data pagamento, mais forma pagamento
	c.Nome, pp.Nr_pedido, pp.Pagamento_efetuado,pp.Data_pedido, pp.Data_pagamento, fp.Tipo_pagamento
order by c.Nome;

-- 16)	Qual o valor total vendido por forma de pagamento que foram concretizadas

SELECT 
    fp.Tipo_pagamento,
    sum(pp.Valor_pago) AS Valor_total_pago
      
FROM 
    forma_pagamento AS fp
JOIN 
    pagamento_pedido AS pp
ON 
	fp.Id_pedido = pp.Id_pedido
WHERE 
    pp.Pagamento_efetuado = true
GROUP BY 
	fp.Tipo_pagamento  
order by Valor_total_pago desc;

-- 17)	Quais produtos foram comprados por um determinado cliente em um pedido específico
SELECT 
    c.Nome AS Cliente,
    pp.Nr_pedido AS Numero_pedido,
    pr.Nome_produto AS Produto,
    i.Quantidade,
    i.Valor_unitario,
    (i.Quantidade * i.Valor_unitario) AS Valor_total_item
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp 
ON 
	c.Id_cliente = pp.Id_cliente
JOIN 
    itens_pedido AS i 
ON 
	pp.Id_pagamento = i.Id_pagamento AND pp.Id_pedido = i.Id_pedido
JOIN 
    produto AS pr ON i.Id_Produto = pr.Id_Produto

order by c.Nome;

-- 18) Relacione os clientes com numero de pedidos quantidade de produto  valor unitario e valor do pedido
SELECT 
    c.Nome AS Cliente,
    pp.Nr_pedido AS Número_pedido,
    i.Quantidade,
    i.Valor_unitario,
    pp.valor_pago AS Valor_do_pedido
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp
    ON c.Id_cliente = pp.Id_cliente
JOIN 
    itens_pedido AS i
    ON pp.Id_pagamento = i.Id_pagamento AND pp.Id_pedido = i.Id_pedido
    order by c.Nome;

-- 19) Selecione o nome do cliente, nr pedido, valor pago, data pedido, data pagamento, data envio, data entrega e tipo de pagamento


SELECT 
    c.Nome AS Cliente,
    pp.Nr_pedido AS Numero_pedido,
    pp.valor_pago,
    pp.Data_pedido,
    pp.Data_pagamento,
    e.Data_envio,
    e.Data_entrega, 
    fp.Tipo_pagamento
    
FROM 
    cliente AS c
JOIN 
    pagamento_pedido AS pp 
ON 
	c.Id_cliente = pp.Id_cliente

JOIN 
    forma_pagamento AS fp 
ON 
	pp.id_pedido = fp.Id_pedido
JOIN 
    entrega AS e
ON 
	pp.id_pedido = e.Id_pedido
order by c.Nome;


-- 20) Selecionar todos os TIPOS DE PAGAMENTO usando o distinct
SELECT DISTINCT TIPO_PAGAMENTO
  FROM FORMA_PAGAMENTO;
  
  -- 21) Selecionar os tickets medios gastos por todos os clientes
  SELECT c.Nome AS Cliente,
       ROUND(AVG(pp.valor_pago),2) AS Tiket_medio
  FROM cliente AS C
  JOIN pagamento_pedido as pp
  ON c.id_cliente = pp.id_cliente
  GROUP BY cliente
  ORDER BY cliente;
  
  -- 22) Selecionar os treis maiores clientes e os valores comprados pelos mesmos
 SELECT c.Nome AS Cliente,
       pp.Valor_pago AS Maior_valor
FROM cliente AS c
JOIN pagamento_pedido AS pp
  ON c.Id_cliente = pp.Id_cliente
ORDER BY pp.Valor_pago DESC
LIMIT 3;


-- 23) Mostrar o faturamento  por dia 
SELECT Data_pagamento,
       SUM(Valor_pago) AS Total_faturado
FROM pagamento_pedido
WHERE Pagamento_efetuado = TRUE
GROUP BY Data_pagamento
ORDER BY Data_pagamento;

-- 24) Faturamento medio do periodo usando a subconsulta da formula anterior
SELECT 
    ROUND(AVG(Total_faturado), 2) AS Faturamento_medio_diario
FROM (
    SELECT 
        Data_pagamento,
        SUM(Valor_pago) AS Total_faturado
    FROM 
        pagamento_pedido
    WHERE 
        Pagamento_efetuado = TRUE
    GROUP BY 
        Data_pagamento
    ORDER BY 
        Data_pagamento
) AS subconsulta;



-- 25) Anterior mostrando os tipos de pagamento por dia
SELECT p.Data_pagamento,
	   fp.Tipo_pagamento,
       SUM(Valor_pago) AS Total_faturado
FROM pagamento_pedido AS p
JOIN forma_pagamento as fp
ON p.id_pagamento = fp.id_pagamento
WHERE Pagamento_efetuado = TRUE
GROUP BY p.Data_pagamento, fp.Tipo_pagamento
ORDER BY Data_pagamento;


-- 26) Selecionar os clientes que estão sem o telefone cadastrados para contato via e-mail usando o left join

SELECT c.nome AS Cliente,
       COUNT(pp.id_pedido) AS total_notas,
       c.e_mail AS E_mail
FROM cliente AS c
LEFT JOIN pagamento_pedido AS pp
  ON c.id_cliente = pp.id_cliente
WHERE c.telefone IS NULL
GROUP BY c.nome, c.e_mail;

-- 27) Qual o produto mais vendido e seu respectivo fabricante  de todas as vendas
SELECT 
    p.Nome_produto,
    f.Nome_fornecedor,
    COUNT(p.Id_Produto) AS Mais_vendido
FROM 
    produto AS p
JOIN 
    Itens_pedido AS i ON p.id_produto = i.id_produto
JOIN 
    Pagamento_Pedido AS pp ON i.Id_pedido = pp.Id_pedido
JOIN 
    Fornecedor AS f ON f.id_fornecedor = p.Id_fornecedor
WHERE 
    pp.Pagamento_efetuado = true
GROUP BY 
    p.Nome_produto, f.Nome_fornecedor
ORDER BY 
    Mais_vendido DESC
LIMIT 1;

-- 28) COMANDOS DE UPDATE E DELETE

-- 28.1) Inserir novo fornedor 
INSERT INTO Fornecedor ( Nome_fornecedor, CNPJ, Telefone, Email) 
VALUES ( 'Novo Fornecedor', '11.111.111/0001-11', '81 99999 9999', 'novofornecedor@exemplo.com');

SELECT * FROM fornecedor;

-- 28.2) Alterando os dados do fornecedor novo
UPDATE fornecedor 
SET nome_fornecedor = 'Silva Irmaos e cia ltda', 
    email = 'silvairmaos@exemplo.com' 
WHERE id_fornecedor = 11 and nome_fornecedor = 'Novo Fornecedor';

SELECT * FROM fornecedor;

-- 28.3) Visualizar a alteracao
Select * from fornecedor
WHERE Nome_fornecedor = 'Silva Irmaos e cia ltda';

-- 28.4) Deletar o novo fornecedor
DELETE FROM fornecedor
WHERE Id_fornecedor = 11 and Nome_fornecedor = 'Silva Irmaos e cia ltda' ;

SELECT * FROM fornecedor;

-- 28.5) Usando Update e subconsulta para automatizar o processo
UPDATE fornecedor 
SET nome_fornecedor = 'Silva Irmaos e cia ltda', 
    email = 'silvairmaos@exemplo.com'
WHERE id_fornecedor = (
    SELECT id_fornecedor
    FROM (
        SELECT id_fornecedor
        FROM fornecedor
        WHERE nome_fornecedor = 'Novo Fornecedor'
        LIMIT 1
    ) AS sub
)
AND nome_fornecedor = 'Novo Fornecedor';

-- 28.6) Usando delete com subconsulta para deletar o registro
DELETE FROM fornecedor
WHERE id_fornecedor = (
    SELECT id_fornecedor
    FROM (
        SELECT id_fornecedor
        FROM fornecedor
        WHERE nome_fornecedor = 'Silva Irmaos e cia ltda'
        LIMIT 1
    ) AS sub
);

SELECT * FROM fornecedor;