SELECT numero, nome FROM banco;
SELECT * FROM banco WHERE numero = 247;
SELECT * FROM banco ORDER BY numero Desc;
SELECT * FROM banco WHERE nome LIKE '%Brasil%';
SELECT * FROM banco WHERE nome ILIKE '%Brasil%';
SELECT COUNT(*) FROM banco; -- 151 bancos
SELECT COUNT(*) FROM banco WHERE nome ILIKE '%Brasil%'; -- 32 bancos que tem o nome "Brasil"
SELECT numero, nome AS LISTA_DE_BANCOS FROM banco;
SELECT numero, nome AS LISTA_DE_CLIENTES FROM cliente ORDER BY numero;
SELECT numero, nome FROM cliente WHERE nome LIKE 'A%' ORDER BY numero;
SELECT COUNT(*) FROM cliente WHERE nome LIKE 'A%'; -- 63 clientes tem a letra "A" como inicial do nome
SELECT numero, nome FROM cliente ORDER BY nome;
SELECT banco_numero, numero, nome FROM agencia;
SELECT banco_numero, agencia_numero, numero, digito, cliente_numero FROM conta_corrente;
SELECT id, nome FROM tipo_transacao;
SELECT id, banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero, tipo_transacao_id, valor FROM cliente_transacoes;

-- JOIN's
-- Retorna os bancos e suas agências cadastradas
SELECT banco.numero, banco.nome, agencia.numero, agencia.nome
FROM banco
JOIN agencia ON agencia.banco_numero = banco.numero;

-- Retorna os bancos que possuem agências cadastradas
SELECT banco.numero, banco.nome
FROM banco
JOIN agencia ON agencia.banco_numero = banco.numero
GROUP BY banco.numero;

-- Outra forma de verificar bancos com agências cadastradas (mostra apenas quantidade)
SELECT COUNT(DISTINCT banco.numero)
FROM banco
JOIN agencia ON agencia.banco_numero = banco.numero;

-- Retorna o banco, agência, conta e nome do cliente que estão relacionados
SELECT	banco.nome,
		agencia.nome,
		conta_corrente.numero,
		conta_corrente.digito,
		cliente.nome
FROM banco
JOIN agencia ON agencia.banco_numero = banco.numero
JOIN conta_corrente
	ON conta_corrente.agencia_numero = agencia.numero
	AND conta_corrente.banco_numero = banco.numero
JOIN cliente
	ON cliente.numero = conta_corrente.cliente_numero;

-- Tipo de transações do cliente e valores das transações
SELECT	banco.nome,
		agencia.nome,
		conta_corrente.numero,
		conta_corrente.digito,
		cliente.nome,
		tipo_transacao.nome,
		cliente_transacoes.valor
FROM banco
JOIN agencia ON agencia.banco_numero = banco.numero
JOIN conta_corrente
	ON conta_corrente.agencia_numero = agencia.numero
	AND conta_corrente.banco_numero = banco.numero
JOIN cliente
	ON cliente.numero = conta_corrente.cliente_numero
JOIN cliente_transacoes
	ON cliente_transacoes.cliente_numero = cliente.numero
JOIN tipo_transacao
	ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id;


-- Utilização de CTE (Common Table Expressions)
-- Retorna todos os clientes e transações no sistema
WITH clientes_e_transacoes AS (
	SELECT	cliente.nome AS cliente_nome,
			tipo_transacao.nome AS tipo_transacao_nome,
			cliente_transacoes.valor AS tipo_transacao_valor
	FROM cliente_transacoes
	JOIN cliente ON cliente.numero = cliente_transacoes.cliente_numero
	JOIN tipo_transacao ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id
)
SELECT cliente_nome, tipo_transacao_nome, tipo_transacao_valor
FROM clientes_e_transacoes;

-- Retorna apenas clientes e transações de um banco específico
WITH clientes_e_transacoes AS (
	SELECT	cliente.nome AS cliente_nome,
			tipo_transacao.nome AS tipo_transacao_nome,
			cliente_transacoes.valor AS tipo_transacao_valor,
			banco.nome AS banco_nome
	FROM cliente_transacoes
	JOIN cliente ON cliente.numero = cliente_transacoes.cliente_numero
	JOIN tipo_transacao ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id
	JOIN banco ON banco.numero = cliente_transacoes.banco_numero AND banco.nome ILIKE '%Itaú%'
)
SELECT cliente_nome, tipo_transacao_nome, tipo_transacao_valor, banco_nome
FROM clientes_e_transacoes;

	



