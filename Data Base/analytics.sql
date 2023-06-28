/* Num dado período (i.e. entre duas datas), por dia da semana, por concelho e no total */

	SELECT dia_semana, concelho, SUM(unidades) FROM vendas 
		WHERE ano BETWEEN EXTRACT(YEAR FROM TIMESTAMP '2021-04-21') AND EXTRACT(YEAR FROM TIMESTAMP '2021-04-21') AND
		mes BETWEEN EXTRACT(MONTH FROM TIMESTAMP '2021-04-21') AND EXTRACT(MONTH FROM TIMESTAMP '2021-04-21') AND
		dia_mes BETWEEN EXTRACT(DAY FROM TIMESTAMP '2021-04-21') AND EXTRACT(DAY FROM TIMESTAMP '2021-04-21') AND
		dia_semana BETWEEN EXTRACT(ISODOW FROM TIMESTAMP '2021-04-21') AND EXTRACT(ISODOW FROM TIMESTAMP '2021-04-21')
		GROUP BY ROLLUP(dia_semana, concelho);


/* Num dado distrito (i.e. “Lisboa”), por concelho, categoria, dia da semana e no total */

	SELECT concelho, cat, dia_semana, SUM(unidades) FROM vendas WHERE distrito = 'Lisboa' GROUP BY ROLLUP(concelho, cat, dia_semana);