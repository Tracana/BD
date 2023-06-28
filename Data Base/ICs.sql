DROP TRIGGER num_unidades_trig ON evento_reposicao;
DROP TRIGGER categoria_produto_prateleira_trig ON evento_reposicao;


/* (RI-4) O número de unidades repostas num Evento de Reposição não pode exceder o número de unidades especificado no Planograma */

	CREATE OR REPLACE FUNCTION num_unidades_proc() 
	RETURNS TRIGGER AS $$ 
	DECLARE unidades_reposicao INT := 0;
	BEGIN 
		SELECT unidades INTO unidades_reposicao FROM (evento_reposicao r INNER JOIN planograma p ON r.nro = p.nro
		AND r.num_serie = p.num_serie AND r.fabricante = p.fabricante);
		IF unidades_reposicao > p.unidades THEN
			RAISE EXCEPTION 'Unidades excedidas';
		END IF;
	RETURN NEW; 
	END; 
	$$ LANGUAGE plpgsql;

	CREATE CONSTRAINT TRIGGER num_unidades_trig AFTER INSERT OR
	UPDATE ON evento_reposicao
	FOR EACH ROW EXECUTE PROCEDURE num_unidades_proc();


/* (RI-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das Categorias desse produto */

	CREATE OR REPLACE FUNCTION categoria_produto_prateleira_proc() 
	RETURNS TRIGGER AS $$ 
	DECLARE prod CHAR(13) := '';
	BEGIN 
		SELECT ean INTO prod FROM produto WHERE (ean IN (SELECT ean FROM tem_categoria) AND ean IN (SELECT ean FROM planograma pl INNER JOIN prateleira p 
		ON pl.nro = p.nro AND pl.num_serie = p.num_serie AND pl.fabricante = p.fabricante));
		IF prod IS NULL THEN
			RAISE EXCEPTION 'Impossivel Repor';
		END IF;
	RETURN NEW; 
	END; 
	$$ LANGUAGE plpgsql;

	CREATE CONSTRAINT TRIGGER categoria_produto_prateleira_trig AFTER INSERT OR
	UPDATE ON evento_reposicao
	FOR EACH ROW EXECUTE PROCEDURE categoria_produto_prateleira_proc();
