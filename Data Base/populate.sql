 drop table categoria cascade;
 drop table categoria_simples cascade;
 drop table super_categoria cascade;
 drop table tem_outra cascade;
 drop table produto cascade;
 drop table tem_categoria cascade;
 drop table ivm cascade;
 drop table ponto_de_retalho cascade;
 drop table instalada_em cascade;
 drop table prateleira cascade;
 drop table planograma cascade;
 drop table retalhista cascade;
 drop table responsável_por cascade;
 drop table evento_reposicao cascade;


create table categoria (
  nome VARCHAR(100) NOT NULL, 
  constraint pk_categoria primary key(nome)
);

create table categoria_simples (
  nome VARCHAR(100) NOT NULL,
  primary key (nome),
  foreign key (nome) references categoria(nome) ON DELETE cascade
);

create table super_categoria (
  nome VARCHAR(100) NOT NULL,
  primary key (nome),
  foreign key (nome) references categoria(nome) ON DELETE cascade
);

create table tem_outra (
  super_categoria VARCHAR(100) NOT NULL,
  categoria VARCHAR(100) NOT NULL,
  primary key (categoria),
  foreign key (super_categoria) references super_categoria(nome) ON DELETE cascade,
  foreign key (categoria) references categoria(nome) ON DELETE cascade,
  check (super_categoria != categoria)
);

create table produto (
  ean CHAR(13) NOT NULL,
  cat VARCHAR(100) NOT NULL,
  descr VARCHAR(100),
  primary key (ean),
  foreign key (cat) references categoria(nome) ON DELETE cascade
);

create table tem_categoria (
  ean CHAR(13) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  primary key(ean, nome),
  foreign key (ean) references produto(ean) ON DELETE cascade,
  foreign key (nome) references categoria(nome) ON DELETE cascade
);

create table ivm (
  num_serie CHAR(8) NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  primary key (num_serie, fabricante)

);

create table ponto_de_retalho (
  nome VARCHAR(20) NOT NULL,
  distrito VARCHAR(20) NOT NULL,
  concelho VARCHAR(20) NOT NULL,
  primary key (nome)
);

create table instalada_em (
  num_serie CHAR(8) NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  locl VARCHAR(20) NOT NULL,
  primary key(num_serie, fabricante),
  foreign key (locl) references ponto_de_retalho(nome) ON DELETE cascade, ----Questionar stor sobre o local
  foreign key (num_serie, fabricante) references ivm(num_serie, fabricante) ON DELETE cascade
);

create table prateleira (
  nro INT NOT NULL,
  num_serie CHAR(8) NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  altura INT NOT NULL,
  nome VARCHAR(100) NOT NULL, 
  primary key (nro, num_serie, fabricante),
  foreign key (num_serie, fabricante) references ivm(num_serie, fabricante) ON DELETE cascade,
  foreign key (nome) references categoria(nome) ON DELETE cascade
);

create table planograma (
  ean CHAR(13) NOT NULL,
  nro INT NOT NULL,
  num_serie CHAR(8) NOT NULL,
  fabricante VARCHAR(100),
  faces INT NOT NULL,
  unidades INT NOT NULL,
  loc INT NOT NULL,
  primary key (ean, nro, num_serie, fabricante),
  foreign key (ean) references produto(ean) ON DELETE cascade,
  foreign key (nro, num_serie, fabricante) references prateleira(nro, num_serie, fabricante) ON DELETE cascade

);

create table retalhista (
  tin CHAR(11) NOT NULL,
  nome VARCHAR(100) NOT NULL UNIQUE,
  primary key (tin)
);

create table responsavel_por(
  num_serie CHAR(8) NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  nome_cat char(20) NOT NULL,
  tin CHAR(11) NOT NULL,
  primary key (num_serie, fabricante),
  foreign key (num_serie, fabricante) references ivm(num_serie, fabricante) ON DELETE cascade,
  foreign key (tin) references retalhista(tin) ON DELETE cascade,
  foreign key (nome_cat) references categoria(nome) ON DELETE cascade
  
);

create table evento_reposicao(
  ean CHAR(13) NOT NULL,
  nro INT NOT NULL,
  num_serie CHAR(8) NOT NULL,
  fabricante VARCHAR(100),
  instante timestamp,
  units INT NOT NULL,
  tin CHAR(11) NOT NULL,
  primary key (ean, nro, num_serie, fabricante, instante),
  foreign key (tin) references retalhista(tin) ON DELETE cascade,
  foreign key (ean, nro, num_serie, fabricante) references planograma(ean, nro, num_serie, fabricante) ON DELETE cascade
);

---------------------------------------------------------------------------------------------------------
----Preenchendo a nossa base de dados
---------------------------------------------------------------------------------------------------------
--Popular Categoria
insert into categoria values ('Pao');
insert into categoria values ('Pizza');
insert into categoria values ('Refrigerantes');
insert into categoria values ('Agua');
insert into categoria values ('Bebidas energeticas');
insert into categoria values ('Sumo natural');
insert into categoria values ('Iogurte');
insert into categoria values ('Leite');
insert into categoria values ('Padaria');
insert into categoria values ('Bebidas');
insert into categoria values ('Quentes');
insert into categoria values ('Frios');
insert into categoria values ('Laticinios');


--Popular categoria simples
insert into categoria_simples values ('Pao');
insert into categoria_simples values ('Pizza');
insert into categoria_simples values ('Refrigerantes');
insert into categoria_simples values ('Agua');
insert into categoria_simples values ('Bebidas energeticas');
insert into categoria_simples values ('Sumo natural');
insert into categoria_simples values ('Iogurte');
insert into categoria_simples values ('Leite');


--Popular super categoria
insert into super_categoria values ('Padaria');
insert into super_categoria values ('Bebidas');
insert into super_categoria values ('Quentes');
insert into super_categoria values ('Frios');
insert into super_categoria values ('Laticinios');



--tem_outra:
insert into tem_outra values ('Quentes', 'Padaria');
insert into tem_outra values ('Padaria', 'Pao');
insert into tem_outra values ('Padaria', 'Pizza');
insert into tem_outra values ('Frios', 'Laticinios');
insert into tem_outra values ('Laticinios', 'Iogurte');
insert into tem_outra values ('Laticinios', 'Leite');
insert into tem_outra values ('Bebidas', 'Bebidas energeticas');
insert into tem_outra values ('Bebidas', 'Refrigerantes');
insert into tem_outra values ('Bebidas', 'Agua');
insert into tem_outra values ('Bebidas', 'Sumo natural');




--Produtos:
insert into produto values ('6159538343286', 'Pao' ,'Pao c/ chourico');
insert into produto values ('8756961320587', 'Pao' ,'Pao rustico');
insert into produto values ('4536390997950', 'Pao' ,'Pao de lo');
insert into produto values ('6921433830393', 'Pao' ,'Sandes c/ atum');
insert into produto values ('5611703510556', 'Pao' ,'Sandes c/ frango');
insert into produto values ('3545375898387', 'Pao' ,'Sandes mista');
insert into produto values ('2017340983057', 'Pao' ,'Pao rustico');
insert into produto values ('2409687517723', 'Leite' ,'Leite c/ chocolate');
insert into produto values ('9591365572101', 'Leite' ,'Leite de aveia');
insert into produto values ('5795024633075', 'Leite' ,'Leite de soja');
insert into produto values ('6505742074894', 'Leite' ,'Leite de amendoa');
insert into produto values ('9924300330778', 'Pizza' ,'Pizza c/ fiambre');
insert into produto values ('5862905836242', 'Pizza' ,'Pizza c/ bacon');
insert into produto values ('8994203857339', 'Pizza' ,'Pizza marguerita');
insert into produto values ('2199724666618', 'Pizza' ,'Pizza c/ atum');
insert into produto values ('5053153129698', 'Sumo natural' ,'Sumo de laranja');
insert into produto values ('9530418213046', 'Sumo natural' ,'Sumo de maca');
insert into produto values ('4140129892604', 'Sumo natural' ,'Sumo de pera');
insert into produto values ('6368408070710', 'Sumo natural' ,'Sumo de morango');
insert into produto values ('8641639593327', 'Sumo natural' ,'Sumo de ananas');
insert into produto values ('2316313104916', 'Sumo natural' ,'Sumo de manga');
insert into produto values ('2028635168293', 'Sumo natural' ,'Sumo de frutos vermelho');
insert into produto values ('9968900727985', 'Agua' ,'Agua c/ limao');
insert into produto values ('1159151793743', 'Agua' ,'Agua c/ gas');
insert into produto values ('3028797255994', 'Agua' ,'Agua c/ frutos vermelhos');
insert into produto values ('8634847685022', 'Bebidas energeticas' ,'Gatorade');
insert into produto values ('9701994078920', 'Bebidas energeticas' ,'Redbull');
insert into produto values ('6608315624211', 'Bebidas energeticas' ,'Monster');
insert into produto values ('9123072697945', 'Bebidas energeticas' ,'Powerade');
insert into produto values ('4299157272235', 'Refrigerantes' ,'Coca-cola');
insert into produto values ('4554676872748', 'Refrigerantes' ,'Fanta laranja');
insert into produto values ('4583109804963', 'Refrigerantes' ,'Fanta ananas');
insert into produto values ('7953761298314', 'Refrigerantes' ,'Pepsi');
insert into produto values ('3563580189818', 'Refrigerantes' ,'Guarana');
insert into produto values ('5074239694257', 'Refrigerantes' ,'Iced-tea limao');
insert into produto values ('8720667803817', 'Refrigerantes' ,'Iced-tea pessego');
insert into produto values ('4347236000783', 'Refrigerantes' ,'Iced-tea manga');
insert into produto values ('4220272526259', 'Iogurte' ,'Iogurte Grego');
insert into produto values ('2099623285807', 'Iogurte' ,'Iogurte c/ frutos vermelhos');
insert into produto values ('2786149147964', 'Iogurte' ,'Iogurte c/ morangos');
insert into produto values ('6919675729906', 'Iogurte' ,'Iogurte c/ pessego');


-- tem_categoria
insert into tem_categoria values ('6159538343286', 'Pao');
insert into tem_categoria values ('8756961320587', 'Pao');
insert into tem_categoria values ('4536390997950', 'Pao');
insert into tem_categoria values ('6921433830393', 'Pao');
insert into tem_categoria values ('5611703510556', 'Pao');
insert into tem_categoria values ('3545375898387', 'Pao');
insert into tem_categoria values ('2409687517723', 'Leite');
insert into tem_categoria values ('9591365572101', 'Leite');
insert into tem_categoria values ('5795024633075', 'Leite');
insert into tem_categoria values ('6505742074894', 'Leite');
insert into tem_categoria values ('9924300330778', 'Pizza');
insert into tem_categoria values ('5862905836242', 'Pizza');
insert into tem_categoria values ('8994203857339', 'Pizza');
insert into tem_categoria values ('2199724666618', 'Pizza');
insert into tem_categoria values ('5053153129698', 'Sumo natural');
insert into tem_categoria values ('9530418213046', 'Sumo natural');
insert into tem_categoria values ('4140129892604', 'Sumo natural');
insert into tem_categoria values ('6368408070710', 'Sumo natural');
insert into tem_categoria values ('8641639593327', 'Sumo natural');
insert into tem_categoria values ('2316313104916', 'Sumo natural');
insert into tem_categoria values ('2028635168293', 'Sumo natural');
insert into tem_categoria values ('9968900727985', 'Agua');
insert into tem_categoria values ('1159151793743', 'Agua');
insert into tem_categoria values ('3028797255994', 'Agua');
insert into tem_categoria values ('8634847685022', 'Bebidas energeticas');
insert into tem_categoria values ('9701994078920', 'Bebidas energeticas');
insert into tem_categoria values ('6608315624211', 'Bebidas energeticas');
insert into tem_categoria values ('9123072697945', 'Bebidas energeticas');
insert into tem_categoria values ('4299157272235', 'Refrigerantes');
insert into tem_categoria values ('4554676872748', 'Refrigerantes');
insert into tem_categoria values ('4583109804963', 'Refrigerantes');
insert into tem_categoria values ('7953761298314', 'Refrigerantes');
insert into tem_categoria values ('3563580189818', 'Refrigerantes');
insert into tem_categoria values ('5074239694257', 'Refrigerantes');
insert into tem_categoria values ('8720667803817', 'Refrigerantes');
insert into tem_categoria values ('4347236000783', 'Refrigerantes');
insert into tem_categoria values ('4220272526259', 'Iogurte');
insert into tem_categoria values ('2099623285807', 'Iogurte');
insert into tem_categoria values ('2786149147964', 'Iogurte');



--IVM 
insert into ivm values ('19276429', 'Prozis');
insert into ivm values ('52980030', 'Prozis');
insert into ivm values ('91607771', 'Fanuc');
insert into ivm values ('77094863', 'Fanuc');
insert into ivm values ('88371507', 'Sandstar');
insert into ivm values ('50071819', 'Sandstar');
insert into ivm values ('17908245', 'Tecnovending');
insert into ivm values ('17286838', 'Tecnovending');


--ponto_de_retalho
insert into ponto_de_retalho values ('Aldi-Lisboa', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho values ('Pingo Doce-Guimaraes', 'Braga', 'Guimaraes');
insert into ponto_de_retalho values ('Auchan-Sintra', 'Lisboa', 'Sintra');
insert into ponto_de_retalho values ('Pingo Doce-Monforte', 'Portalegre', 'Monforte');
insert into ponto_de_retalho values ('Auchan-Ourique', 'Beja', 'Ourique');
insert into ponto_de_retalho values ('Pingo Doce-Lousa', 'Coimbra', 'Lousa');
insert into ponto_de_retalho values ('Galp-Elvas', 'Portalegre', 'Elvas');
insert into ponto_de_retalho values ('Lidl-Nazare', 'Leiria', 'Nazare');


--instalada em
insert into instalada_em values ('19276429', 'Prozis', 'Aldi-Lisboa');
insert into instalada_em values ('52980030', 'Prozis', 'Pingo Doce-Guimaraes');
insert into instalada_em values ('91607771', 'Fanuc', 'Galp-Elvas');
insert into instalada_em values ('77094863', 'Fanuc', 'Lidl-Nazare');
insert into instalada_em values ('88371507', 'Sandstar', 'Pingo Doce-Lousa');
insert into instalada_em values ('50071819', 'Sandstar', 'Auchan-Ourique');
insert into instalada_em values ('17908245', 'Tecnovending', 'Galp-Elvas');
insert into instalada_em values ('17286838', 'Tecnovending', 'Aldi-Lisboa');


--prateleira
insert into prateleira values ('1', '19276429', 'Prozis', 11.19, 'Pao');
insert into prateleira values ('2', '19276429', 'Prozis', 7.83, 'Pizza');
insert into prateleira values ('3', '19276429', 'Prozis', 6.42, 'Laticinios');
insert into prateleira values ('4', '19276429', 'Prozis', 10.72, 'Sumo natural');
insert into prateleira values ('5', '19276429', 'Prozis', 7.88, 'Sumo natural');
insert into prateleira values ('6', '19276429', 'Prozis', 11.97, 'Laticinios');
insert into prateleira values ('1', '52980030', 'Prozis', 11.33, 'Iogurte');
insert into prateleira values ('2', '52980030', 'Prozis', 12.44, 'Laticinios');
insert into prateleira values ('3', '52980030', 'Prozis', 9.1, 'Bebidas energeticas');
insert into prateleira values ('4', '52980030', 'Prozis', 12.82, 'Iogurte');
insert into prateleira values ('5', '52980030', 'Prozis', 15.39, 'Refrigerantes');
insert into prateleira values ('6', '52980030', 'Prozis', 14.52, 'Pao');
insert into prateleira values ('1', '91607771', 'Fanuc', 9.59, 'Pizza');
insert into prateleira values ('2', '91607771', 'Fanuc', 14.49, 'Frios');
insert into prateleira values ('3', '91607771', 'Fanuc', 9.49, 'Pizza');
insert into prateleira values ('4', '91607771', 'Fanuc', 14.82, 'Pizza');
insert into prateleira values ('5', '91607771', 'Fanuc', 5.69, 'Agua');
insert into prateleira values ('6', '91607771', 'Fanuc', 12.05, 'Padaria');
insert into prateleira values ('1', '77094863', 'Fanuc', 7.72, 'Refrigerantes');
insert into prateleira values ('2', '77094863', 'Fanuc', 5.27, 'Leite');
insert into prateleira values ('3', '77094863', 'Fanuc', 11.62, 'Leite');
insert into prateleira values ('4', '77094863', 'Fanuc', 12.66, 'Sumo natural');
insert into prateleira values ('5', '77094863', 'Fanuc', 12.65, 'Laticinios');
insert into prateleira values ('6', '77094863', 'Fanuc', 5.67, 'Leite');
insert into prateleira values ('1', '88371507', 'Sandstar', 5.89, 'Padaria');
insert into prateleira values ('2', '88371507', 'Sandstar', 14.78, 'Leite');
insert into prateleira values ('3', '88371507', 'Sandstar', 15.38, 'Laticinios');
insert into prateleira values ('4', '88371507', 'Sandstar', 8.17, 'Pao');
insert into prateleira values ('5', '88371507', 'Sandstar', 8.66, 'Refrigerantes');
insert into prateleira values ('6', '88371507', 'Sandstar', 5.24, 'Pizza');
insert into prateleira values ('1', '50071819', 'Sandstar', 11.95, 'Agua');
insert into prateleira values ('2', '50071819', 'Sandstar', 11.76, 'Pao');
insert into prateleira values ('3', '50071819', 'Sandstar', 10.0, 'Frios');
insert into prateleira values ('4', '50071819', 'Sandstar', 5.09, 'Pizza');
insert into prateleira values ('5', '50071819', 'Sandstar', 7.1, 'Pizza');
insert into prateleira values ('6', '50071819', 'Sandstar', 15.16, 'Agua');
insert into prateleira values ('1', '17908245', 'Tecnovending', 5.1, 'Pao');
insert into prateleira values ('2', '17908245', 'Tecnovending', 14.6, 'Quentes');
insert into prateleira values ('3', '17908245', 'Tecnovending', 11.7, 'Pizza');
insert into prateleira values ('4', '17908245', 'Tecnovending', 11.29, 'Iogurte');
insert into prateleira values ('5', '17908245', 'Tecnovending', 7.02, 'Quentes');
insert into prateleira values ('6', '17908245', 'Tecnovending', 15.17, 'Bebidas energeticas');
insert into prateleira values ('1', '17286838', 'Tecnovending', 10.39, 'Refrigerantes');
insert into prateleira values ('2', '17286838', 'Tecnovending', 11.86, 'Refrigerantes');
insert into prateleira values ('3', '17286838', 'Tecnovending', 6.65, 'Pao');
insert into prateleira values ('4', '17286838', 'Tecnovending', 14.29, 'Laticinios');
insert into prateleira values ('5', '17286838', 'Tecnovending', 11.27, 'Leite');
insert into prateleira values ('6', '17286838', 'Tecnovending', 9.77, 'Quentes');


--planograma
insert into planograma values ('4299157272235', '1', '19276429', 'Prozis', '5', '20', '1');
insert into planograma values ('6919675729906', '2', '19276429', 'Prozis', '5', '15', '15');
insert into planograma values ('2017340983057', '3', '19276429', 'Prozis', '2', '18', '43');
insert into planograma values ('2028635168293', '4', '19276429', 'Prozis', '4', '24', '9');
insert into planograma values ('5795024633075', '5', '19276429', 'Prozis', '2', '4', '26');
insert into planograma values ('4536390997950', '6', '19276429', 'Prozis', '5', '10', '9');
insert into planograma values ('2017340983057', '1', '52980030', 'Prozis', '2', '10', '37');
insert into planograma values ('8720667803817', '2', '52980030', 'Prozis', '7', '28', '38');
insert into planograma values ('2409687517723', '3', '52980030', 'Prozis', '5', '30', '36');
insert into planograma values ('4299157272235', '4', '52980030', 'Prozis', '6', '30', '31');
insert into planograma values ('6368408070710', '5', '52980030', 'Prozis', '1', '10', '4');
insert into planograma values ('4220272526259', '6', '52980030', 'Prozis', '6', '18', '48');
insert into planograma values ('6505742074894', '1', '91607771', 'Fanuc', '5', '20', '27');
insert into planograma values ('5862905836242', '2', '91607771', 'Fanuc', '2', '16', '6');
insert into planograma values ('5053153129698', '3', '91607771', 'Fanuc', '7', '49', '4');
insert into planograma values ('9591365572101', '4', '91607771', 'Fanuc', '5', '40', '47');
insert into planograma values ('5611703510556', '5', '91607771', 'Fanuc', '6', '54', '41');
insert into planograma values ('9701994078920', '6', '91607771', 'Fanuc', '7', '14', '36');
insert into planograma values ('4347236000783', '1', '77094863', 'Fanuc', '3', '9', '45');
insert into planograma values ('9530418213046', '2', '77094863', 'Fanuc', '5', '30', '3');
insert into planograma values ('5074239694257', '3', '77094863', 'Fanuc', '4', '20', '50');
insert into planograma values ('2099623285807', '4', '77094863', 'Fanuc', '1', '3', '22');
insert into planograma values ('6608315624211', '5', '77094863', 'Fanuc', '2', '20', '24');
insert into planograma values ('2028635168293', '6', '77094863', 'Fanuc', '5', '15', '48');
insert into planograma values ('2316313104916', '1', '88371507', 'Sandstar', '6', '42', '23');
insert into planograma values ('9123072697945', '2', '88371507', 'Sandstar', '5', '50', '27');
insert into planograma values ('9924300330778', '3', '88371507', 'Sandstar', '1', '10', '7');
insert into planograma values ('3563580189818', '4', '88371507', 'Sandstar', '3', '30', '33');
insert into planograma values ('8756961320587', '5', '88371507', 'Sandstar', '1', '5', '25');
insert into planograma values ('6921433830393', '6', '88371507', 'Sandstar', '6', '30', '1');
insert into planograma values ('4220272526259', '1', '50071819', 'Sandstar', '1', '5', '18');
insert into planograma values ('8994203857339', '2', '50071819', 'Sandstar', '3', '9', '30');
insert into planograma values ('6505742074894', '3', '50071819', 'Sandstar', '6', '60', '48');
insert into planograma values ('1159151793743', '4', '50071819', 'Sandstar', '1', '8', '26');
insert into planograma values ('5074239694257', '5', '50071819', 'Sandstar', '3', '24', '38');
insert into planograma values ('4583109804963', '6', '50071819', 'Sandstar', '6', '30', '41');
insert into planograma values ('5053153129698', '1', '17908245', 'Tecnovending', '3', '27', '25');
insert into planograma values ('2017340983057', '2', '17908245', 'Tecnovending', '7', '35', '2');
insert into planograma values ('4583109804963', '3', '17908245', 'Tecnovending', '5', '10', '33');
insert into planograma values ('4140129892604', '4', '17908245', 'Tecnovending', '3', '9', '32');
insert into planograma values ('6919675729906', '5', '17908245', 'Tecnovending', '2', '8', '47');
insert into planograma values ('6921433830393', '6', '17908245', 'Tecnovending', '1', '5', '29');
insert into planograma values ('4140129892604', '1', '17286838', 'Tecnovending', '4', '36', '37');
insert into planograma values ('9123072697945', '2', '17286838', 'Tecnovending', '7', '28', '23');
insert into planograma values ('4347236000783', '3', '17286838', 'Tecnovending', '6', '36', '4');
insert into planograma values ('9123072697945', '4', '17286838', 'Tecnovending', '5', '20', '27');
insert into planograma values ('8634847685022', '5', '17286838', 'Tecnovending', '6', '36', '50');
insert into planograma values ('4220272526259', '6', '17286838', 'Tecnovending', '2', '18', '19');


--Retalhista
insert into retalhista values ('312-24-9955', 'Pingo Doce');
insert into retalhista values ('430-54-3054', 'Sonae');
insert into retalhista values ('767-29-2858', 'Lidl');

--responsavel_por
insert into responsavel_por values ('17908245', 'Tecnovending', 'Pao', '312-24-9955');
insert into responsavel_por values ('17286838', 'Tecnovending', 'Pizza', '312-24-9955');
insert into responsavel_por values ('50071819', 'Sandstar', 'Refrigerantes', '312-24-9955');
insert into responsavel_por values ('88371507', 'Sandstar', 'Agua', '312-24-9955');
insert into responsavel_por values ('77094863', 'Fanuc', 'Bebidas energeticas', '312-24-9955');
insert into responsavel_por values ('91607771', 'Fanuc', 'Sumo natural', '312-24-9955');
insert into responsavel_por values ('52980030', 'Prozis', 'Iogurte', '312-24-9955');
insert into responsavel_por values ('19276429', 'Prozis', 'Leite', '312-24-9955');


--Evento_reposicao
insert into evento_reposicao values ('6921433830393', '6', '88371507', 'Sandstar', '2021-06-25', '2', '430-54-3054');
insert into evento_reposicao values ('5862905836242', '2', '91607771', 'Fanuc', '2021-07-01', '1', '312-24-9955');
insert into evento_reposicao values ('2017340983057', '2', '17908245', 'Tecnovending', '2022-04-06', '2', '312-24-9955');
insert into evento_reposicao values ('6921433830393', '6', '88371507', 'Sandstar', '2021-04-21', '2', '767-29-2858');
insert into evento_reposicao values ('1159151793743', '4', '50071819', 'Sandstar', '2022-01-01', '2', '767-29-2858');
insert into evento_reposicao values ('2017340983057', '3', '19276429', 'Prozis', '2021-06-09', '2', '767-29-2858');
insert into evento_reposicao values ('5862905836242', '2', '91607771', 'Fanuc', '2021-09-06', '2', '312-24-9955');
insert into evento_reposicao values ('5862905836242', '2', '91607771', 'Fanuc', '2021-04-27', '2', '312-24-9955');
insert into evento_reposicao values ('5862905836242', '2', '91607771', 'Fanuc', '2021-06-27', '1', '312-24-9955');
insert into evento_reposicao values ('9123072697945', '2', '88371507', 'Sandstar', '2021-08-02', '2', '767-29-2858');
insert into evento_reposicao values ('5053153129698', '1', '17908245', 'Tecnovending', '2021-08-16', '2', '312-24-9955');
