/* Qual o nome do retalhista (ou retalhistas) responsáveis pela reposição do maior número de categorias? */

	SELECT name
	FROM (SELECT tin, COUNT(*)
	FROM responsavel_por
	GROUP BY tin) 
	AS tab NATURAL JOIN retalhista	
	WHERE count >= ALL(SELECT COUNT(*)
                  FROM responsavel_por
                  	GROUP BY tin);


/* Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples? */

	SELECT nome FROM (retalhista NATURAL JOIN (SELECT tin, count(DISTINCT nome_cat) AS count 
		FROM responsavel_por 
		WHERE nome_cat IN (SELECT nome FROM categoria_simples)
		GROUP BY tin) AS aux_tab)
		WHERE count = (SELECT count(nome) FROM categoria_simples);

/* Quais os produtos (ean) que nunca foram repostos? */

	SELECT ean FROM produto WHERE ean NOT IN(SELECT ean FROM evento_reposicao);


/* Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista? */

	SELECT ean FROM evento_reposicao GROUP BY ean HAVING COUNT(DISTINCT tin) = 1;
