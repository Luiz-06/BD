/*b) Crie um trigger na tabela Livro que não permita quantidade em estoque negativa e sempre
que a quantidade em estoque atingir 10 ou menos unidades, um aviso de quantidade mínima
deve ser emitido ao usuário (para emitir alertas sem interromper a execução da transação,
você pode usar "raise notice" ou "raise info").*/

CREATE FUNCTION positivando() 
RETURNS TRIGGER AS 
$$
    BEGIN   
        IF NEW.QTD_ESTOQUE <= 10 THEN 
            RAISE INFO ('Respeite a quantidade mínima');
        END IF;

        IF NEW.QTD_ESTOQUE < 0 THEN 
            RAISE EXCEPTION 'Quantidade de estoque não pode ser negativa!';
        END IF;
    RETURN NEW;    
    END;
$$ LANGUAGE plpgsql;

CREATE TABLE TITULO (
    COD_TITULO SERIAL PRIMARY KEY, 
    NOME_TITULO VARCHAR(100), 
    DESC_TITULO VARCHAR(100)
);

CREATE TABLE LIVRO (
    COD_LIVRO SERIAL PRIMARY KEY, 
    COD_TITULO INT, 
    VALOR_LIVRO INT,
    QTD_ESTOQUE INT,
    FOREIGN KEY (COD_TITULO) REFERENCES TITULO(COD_TITULO)
);

CREATE TABLE FORNECEDOR (
    COD_FORNECEDOR SERIAL PRIMARY KEY, 
    NOME_FORNECEDOR VARCHAR(100),
    FONE_FORNECEDOR VARCHAR(100)
);

CREATE TABLE PEDIDO (
    COD_PEDIDO SERIAL PRIMARY KEY, 
    COD_FORNECEDOR INT, 
    HORA_PEDIDO TIME,
    DATA_PEDIDO DATE,
    VALOR_TOTAL_PEDIDO INT,
    FOREIGN KEY (COD_FORNECEDOR) REFERENCES FORNECEDOR(COD_FORNECEDOR)
);

CREATE TABLE ITEM_PEDIDO (
    COD_ITEM_PEDIDO SERIAL PRIMARY KEY, 
    COD_PEDIDO INT, 
    COD_LIVRO INT,
    FOREIGN KEY (COD_PEDIDO) REFERENCES PEDIDO(COD_PEDIDO),
    FOREIGN KEY (COD_LIVRO) REFERENCES LIVRO(COD_LIVRO)
);

CREATE TRIGGER POSITIVO_CAPITAO
BEFORE
INSERT OR UPDATE ON LIVRO
FOR EACH ROW
EXECUTE FUNCTION positivando();
