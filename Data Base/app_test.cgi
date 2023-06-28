#!/usr/bin/python3
from crypt import methods
from wsgiref.handlers import CGIHandler
from flask import Flask, url_for
from flask import render_template, request, redirect
import psycopg2
import psycopg2.extras
## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist199082" 
DB_DATABASE=DB_USER
DB_PASSWORD="Noobreality1"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)
app = Flask(__name__)
'''a) Inserir e remover categorias e sub-categorias;
b) Inserir e remover um retalhista, com todos os seus produtos, garantindo que esta operação seja
atómica;
c) Listar todos os eventos de reposição de uma IVM, apresentando o número de unidades repostas por
categoria de produto;
d) Listar todas as sub-categorias de uma super-categoria, a todos os níveis de profundidade.'''

@app.route('/')
def home():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        return render_template("home.html", cursor=cursor)
    except Exception as e:
        str(e)


@app.route('/categorias', methods=["POST", "GET"])
def list_categorias():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT nome FROM categoria;"
        cursor.execute(query)
        return render_template("categories.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/delete_category', methods = ["POST"])
def eliminar_categoria():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        nome=request.form["nome_categoria"]
        query = 'DELETE FROM categoria WHERE nome = %s'
        data=(nome,)
        cursor.execute(query,data)
        return redirect(url_for('list_categorias'))
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/adicionar')
def add_categoria():
    try:
        return render_template("add_categoria.html")
    except Exception as e:
        return str(e)

@app.route('/insert', methods=["POST"])
def inserir_categoria():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        tipo_cat = request.form["tipo_cat"]
        categoria_add=request.form["nome_categoria"]
        query = "INSERT INTO categoria VALUES ('{}');".format(categoria_add)
        query2 = "INSERT INTO {} VALUES ('{}');".format(tipo_cat, categoria_add)
        cursor.execute(query)
        cursor.execute(query2)
        return redirect(url_for('list_categorias'))
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/categorias/super_categorias', methods=["POST"])
def list_super_categories():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT nome FROM super_categoria;"
        cursor.execute(query)
        return render_template("super_categorias.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/categorias/super_categorias/list_subcategorias', methods=["POST"])
def list_subcategories():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        super_cat = request.form["nome_sup_categoria"]
        query = "WITH RECURSIVE temp_tab AS (SELECT categoria, super_categoria FROM tem_outra WHERE super_categoria = %s UNION ALL SELECT td.categoria, td.super_categoria FROM tem_outra td INNER JOIN temp_tab tt ON tt.categoria = td.super_categoria) SELECT * FROM temp_tab;"
        data = (super_cat,)
        cursor.execute(query, data)
        return render_template("subcategorias.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()


@app.route('/IVMs', methods=["POST", "GET"])
def list_ivms():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = 'SELECT * FROM ivm;'
        cursor.execute(query)
        return render_template("ivms.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/IVMs/eventos_reposicao_ivm', methods=["POST"])
def list_eventos():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        n_serie=request.form["num_serie"]
        fabricante=request.form["fabricante"]
        query = 'SELECT er.num_serie, er.fabricante, er.nro, p.cat, sum(units) FROM evento_reposicao er JOIN produto p ON er.ean = p.ean GROUP BY p.cat, er.num_serie, er.fabricante, er.nro HAVING num_serie =%s and fabricante=%s;'
        data=(n_serie, fabricante)
        cursor.execute(query, data)
        return render_template("eventos_reposicao.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/retalhistas', methods=["POST", "GET"])
def list_retalhistas():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = 'SELECT * FROM retalhista;'
        cursor.execute(query)
        return render_template("retalhistas.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/retalhistas/adicionar_retalhista', methods=["POST", "GET"])
def adicionar_retalhista():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = '''SELECT p.num_serie, p.fabricante, p.nro FROM planograma as p where not exists
                    (select num_serie, fabricante from responsavel_por as rp
                    where p.num_serie = rp.num_serie and p.fabricante = rp.fabricante);'''
        cursor.execute(query)
        return render_template("add_retalhista.html", cursor=cursor)
    except Exception as e:
        return str(e)

@app.route('/retalhistas/inserir_retalhista', methods=["POST", "GET"])
def inserir_retalhista():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = 'INSERT INTO retalhista VALUES (%s, %s);'
        tin = request.form["tin_retalhista"]
        nome = request.form["nome_retalhista"]
        data = (tin, nome)
        cursor.execute(query, data)
        return redirect(url_for('list_retalhistas'))
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/retalhistas/remover_retalhista', methods=["POST", "GET"])
def remover_retalhista():
    dbConn=None
    cursor=None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = 'DELETE FROM retalhista WHERE tin=%s and nome=%s;'
        rm_respo_por = 'DELETE FROM responsavel_por WHERE tin=%s;'
        tin = request.form["tin"]
        nome = request.form["nome"]
        data = (tin, nome)
        data_resp = (tin,)
        cursor.execute(rm_respo_por, data_resp)
        cursor.execute(query, data)
        return redirect(url_for('list_retalhistas'))
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()



CGIHandler().run(app)