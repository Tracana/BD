DROP VIEW vendas; 

CREATE VIEW vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades)
	AS SELECT 
		evento_reposicao.ean, 
		produto.cat, 
        	EXTRACT(YEAR FROM evento_reposicao.instante),
        	EXTRACT(QUARTER FROM evento_reposicao.instante),
        	EXTRACT(MONTH FROM evento_reposicao.instante),
        	EXTRACT(DAY FROM evento_reposicao.instante),
        	EXTRACT(ISODOW FROM evento_reposicao.instante),
        	ponto_de_retalho.distrito,
        	ponto_de_retalho.concelho,
		evento_reposicao.units
		FROM (produto INNER JOIN evento_reposicao ON produto.ean = evento_reposicao.ean 
		INNER JOIN instalada_em ON evento_reposicao.num_serie = instalada_em.num_serie AND evento_reposicao.fabricante = 			instalada_em.fabricante
		INNER JOIN ponto_de_retalho ON instalada_em.locl = ponto_de_retalho.nome);
        
SELECT * FROM vendas;




		
		




		